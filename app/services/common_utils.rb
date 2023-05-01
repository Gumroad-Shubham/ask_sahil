require "pdf-reader"
require 'open3'
# require "espeak"
require "openai"

module Utils
   def Utils.get_embedding(text, model)
      Constants.openai_client.embeddings(parameters:{model: model, input: text})["data"][0]["embedding"]
   end
   
   def Utils.get_doc_embedding(text)
      get_embedding(text, DOC_EMBEDDINGS_MODEL)
   end
 
   def Utils.pages_from_pdf(pdfname)
      pdf_file = File.open(pdfname, 'rb')
      reader = PDF::Reader.new(pdf_file)
      pages = reader.pages.map{|page| page.text}
      pdf_file.close

      pages
   end

   def Utils.run_python_function(module_name, function_name, *args)
      output, error, status = 
               Open3.capture3("python3 -c 'import #{module_name}; print(#{module_name}.#{function_name}(*#{args}))'")
      raise "Error running Python function: #{error}" unless status.success?

      output.strip
   end

   # def Utils.generate_audio(text, speak: false, store_and_return_link: false)
   #    if speak
   #       ESpeak::Speech.new(text, pitch: 60, speed:1.2).speak
   #    end
   #    if store_and_return_link
   #       speech = Espeak::Speech.new(text, voice: "en-us", format: "mp3", filename: output_file)
   #       speech.save("./my_audio.mp3")
   #       # TODO: save to s3 and send link.
   #    end
   #    # TODO: explore other libraries like Festival, Flite and MaryTTS 
   # end

   def Utils.load_embeddings(fname)
      df = CSV.read(fname, headers: true)
      max_dim = df.headers.map { |c| c.to_i }.max
      df.map { |r| [r['title'], r.to_h.select { |k, v| k != 'title' }.values.map(&:to_f)] }.to_h
   end

end


class Constants
   @@openai_client = nil
   def self.openai_client
      unless @@openai_client
         @@openai_client = OpenAI::Client.new(access_token: ENV.fetch("OPENAI_KEY"))
      end
      @@openai_client
   end

   BookName = "minimalist_entrepreneur"
   CommonKnowledge = File.join('app/services', "common_knowledge")
   BookPdf = File.join(CommonKnowledge, BookName+'.pdf')
   BookTxt = File.join(CommonKnowledge, BookName+'.txt')
   BookCsv = File.join(CommonKnowledge, BookName+'.pages.csv')
   EmbeddingsCsv = BookPdf+'.embeddings.csv'

   # TODO: If the web server kills these with every request, keep these in redis
   @@document_pages = nil
   def self.document_pages
      unless @@document_pages
         @@document_pages = CSV.read(Constants::BookCsv, headers: true)
      end
      @@document_pages
   end

   @@document_embeddings = nil
   def self.document_embeddings
      unless @@document_embeddings
         @@document_embeddings = Utils.load_embeddings(EmbeddingsCsv)
      end
      @@document_embeddings
   end
end
