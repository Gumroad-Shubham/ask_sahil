# this file should only be run from controllers directory to access python_utils.
controllers_path = File.join('./', File.dirname(__FILE__), '../../')
require File.join(controllers_path, 'common_utils')
require 'daru'
require 'numo/narray'

COMPLETIONS_MODEL = 'text-davinci-003'

MODEL_NAME = 'curie'

DOC_EMBEDDINGS_MODEL = "text-search-#{MODEL_NAME}-doc-001"

def count_tokens(text)
  # This function uses the python method because transformers module/GPT2TokenizerFast
  # is not available for ruby
  Utils.run_python_function("python_utils", "count_tokens", text).to_i
  # Because this'd be too slow, we use approx_count_tokens in actual code
end

def approx_count_tokens(text)
  # https://platform.openai.com/tokenizer says:  100 tokens ~= 75 words
  # Mutliplying by 2 to keep margin of safety
  text.count(" ")*2
end


def extract_pages(page_text, index)
  return [] if page_text.empty?

  content = page_text.split.join(' ')
  ["Page #{index}", content, approx_count_tokens(content) + 4]
end


def pdf_to_csv(pdfname, csvname)
  pages = Utils.pages_from_pdf(pdfname)
  res = pages.
          select{|page| !page.empty?}.
          each_with_index.
          map{|page, i| extract_pages(page, i+1)}
  pagenums, contents, numtokens = Numo::NArray[*res].transpose.to_a
  df = Daru::DataFrame.new({"title"=>pagenums, "content"=>contents, "numtokens"=>numtokens})
  df = df.filter(:row){|row| row["numtokens"] < 2046}
  df.write_csv(csvname)
  return df
end


def compute_embeddings_and_store_to_csv()
  df = pdf_to_csv(Constants::BookPdf, Constants::BookCsv)
  puts "Proceeding will call openai and cost money. Enter 'yes' in smallcase, without quotes, to continue."
  (gets.strip() == 'yes') ?(): (p 'Exiting'; return;)
  if File.exists?(Constants::EmbeddingsCsv)
    puts "Embeddings file already exists. Enter 'yes' in smallcase, without quotes, to recreate."
    (gets.strip() != 'yes')? (return): (p "Exiting";)
  end
  doc_embeddings = df.map(:row){|row| Utils.get_doc_embedding(row["content"])}
  CSV.open(Constants::EmbeddingsCsv, 'w') do |csv|
    csv << ["title"] + (0..4095).to_a.map{|i| i.to_s}
    doc_embeddings.each_with_index do |embedding, i|
      csv << ["Page #{i+1}"] + embedding
    end
  end
end


compute_embeddings_and_store_to_csv()

