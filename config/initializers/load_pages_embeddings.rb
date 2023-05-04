Rails.application.config.after_initialize do
    # To fix the "cold start" problem.
    # This will make a request and hence bring the embeddings & pages to memory 
    # which will be cached by the singleton method. 
    # Without this the first query is very slow. 
    QuestionService.new("sahils_strategy_ruby").answer("I am going to work?")
end
  