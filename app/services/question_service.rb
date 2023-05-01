require File.join(__dir__, "./common_utils")


def snake_case_to_PascalCase(txt)
    txt.split("_").map(&:capitalize).join("")
end


class QuestionService
    def initialize(strategy)
      @strategy = strategy
      # TODO: cache the QuestionService obj in memory and preload embeddings files.
    end
  
    def answer(question)
        @question = question
        if @strategy.end_with?("_ruby")
            require File.join(__dir__, "./strategies/#{@strategy}/main")
            return Object.const_get(snake_case_to_PascalCase(@strategy)).ask_a_question(@question)
        else # assert that strategy name ends with "_python"
            return Utils.run_python_function("strategies.#{@strategy}.main", 'ask_a_question', @question)
        end
    end
  end
  