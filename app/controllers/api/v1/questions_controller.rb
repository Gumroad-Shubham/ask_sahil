class Api::V1::QuestionsController < ApplicationController
    def ask
        question = params[:question]
        strategy = params[:strategy] || "sahils_strategy_ruby"
        unless question && strategy
            render json: { error: 'Missing question' }, status: 400
            return
        end

        if question == "I am feeling lucky"
            ques_obj = Question.order("RANDOM()").limit(1).first
            @question = ques_obj.question
            @answer = ques_obj.answer
        else
            @question = question
            @answer = QuestionService.new(strategy).answer(question)
        end
        if @answer == nil
            render json: { error: 'Error occured. Unknown strategy?' }, status: 400
            return
        end
        render json: {question: @question, answer: @answer }
    end
end
