## This file has untested stale code in it as yet.

# require "../../common_utils"

# path = "../../common_knowledge/"
# name = path + "minimalist_entrepreneur"

# # prune "contents", "acknowledgement" etc
# page_range = 3..152

# # ASSUMPTION: grouped sentences are far below token limits by openai
# # Validated this assumption by a separate script
# num_sentences_to_group = 4

# openai_client = Constants.openai_client

# model_name = "davinci"

# # given a pdf called "#{name}.pdf", create a txt called "#{name}.txt" with sentences grouped into appropriate sized chunks
# def create_txt_from_pdf(name, page_range, num_sentences_to_group)
#    pages = Utils.pages_from_pdf(name).slice(page_range)
#    txt_file = File.open(name+".txt", 'w')
#    # remove arbitrary newlines and multiple spaces
#    book_in_single_string = pages.join(" ").gsub("\n", " ").gsub(/\s+/, " ")
#    sentences = book_in_single_string.split(".")
#    grouped_sentences = []
#    for i in 0..sentences.length/num_sentences_to_group do
#       grouped_sentences.append(sentences.slice(i*num_sentences_to_group, num_sentences_to_group).join ". ")
#    end
#    # put each group of sentences on its own line and write to txt file
#    txt_file.write(grouped_sentences.join ".\n")
#    txt_file.close
# end


# if File.exists? name+".txt"
#    puts "text file already exists"
# else
#    create_txt_from_pdf(name, page_range, num_sentences_to_group)
#    puts "created txt file"
# end

# # given the txt file (list of chunks), and a dictionary of few examples of the type {segment: question}, make a jsonl file of the form {question: chunk} which contains all the given chunks and corresponding questions which the chunks answer by using openai api to figure out the latter
# def create_questions_from_answers(client, path, model_name)
#    # require "openai"
#    # response = client.files.upload(parameters: { file: path + "training_data_questions_from_answers.jsonl", purpose: "fine-tune" })
#    # file_id = JSON.parse(response.body)["id"]
#    # puts file_id
#    # response = client.finetunes.create(
#    #    parameters: {
#    #    training_file: file_id,
#    #    model: model_name
#    # })
#    # puts "here"
#    fine_tune_id = "ft-Vh4VAiSpjcJCWDosblBmg6KY" # response["id"] #"ft-Z8dTsjDKMYqbC0kjgkTrTzT3"#"ft-9NpKxJnqiWI5apuXuWLhty27"#
#    puts fine_tune_id
#    response = client.finetunes.retrieve(id: fine_tune_id)
#    fine_tuned_model = response["fine_tuned_model"]
#    unless fine_tuned_model
#       puts "fine tuned model not found. status = " + response["status"]
#       return
#    end
#    response = client.completions(
#       parameters: {
#          model: fine_tuned_model,
#          prompt: "A:  The brain adapts quickly, assuming the new state of things.  It’s meant to be this hard, it thinks, or there’s a really good reason that it is, or it would be too annoying to change.  I think that’s the wrong way to go about life.  Life is getting better all the time, and you can help accelerate the pace. \n\n###\n\n Q:",
#          max_tokens: 256,
#          stop:["###"]
#       }
#    )
#    puts response
#    puts response.dig("choices", 0, "text")
# end

# # create_questions_from_answers(openai_client, path, model_name)
