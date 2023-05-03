class Api::V1::QuestionsController < ApplicationController
    def ask
        question = params[:question]
        strategy = params[:strategy] || "sahils_strategy_ruby"
        unless question && strategy
            render json: { error: 'Missing question' }, status: 400
            return
        end

        @answer = QuestionService.new(strategy).answer(question)

        if @answer == nil
            render json: { error: 'Error occured. Unknown strategy?' }, status: 400
            return
        end
        render json: { answer: @answer }
    end
end
