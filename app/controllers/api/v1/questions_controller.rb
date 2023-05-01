class Api::V1::QuestionsController < ApplicationController
    def ask
        question = params[:question]
        strategy = params[:strategy]
        unless question && strategy
            render json: { error: 'Missing question or strategy' }, status: 400
            return
        end
        @answer = QuestionService.new(strategy).answer(question)
        render json: { answer: @answer }
    end
end
