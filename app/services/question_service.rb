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
        @question = question + (question.end_with?("?")?'':'?')
        ques_obj = Question.where(question: @question, strategy: @strategy).first
        if ques_obj
            ques_obj.update(ask_count: ques_obj.ask_count + 1)
            return ques_obj.answer
        end
        if @strategy.end_with?("_ruby")
            begin
                require File.join(__dir__, "./strategies/#{@strategy}/main")
                strategy_class = Object.const_get(snake_case_to_PascalCase(@strategy))
            rescue Exception => e
                return nil
            end
            answer = strategy_class.ask_a_question(@question)
        elsif @strategy.end_with?("_python")
            answer = Utils.run_python_function("strategies.#{@strategy}.main", 'ask_a_question', @question)            
        else
            return nil
        end
        Question.create(question: @question, strategy: @strategy, answer:answer)
        return answer
    end
  end
  