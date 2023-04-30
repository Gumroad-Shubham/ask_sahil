# app/controllers/api/v1/questions_controller.rb

class Api::V1::QuestionsController < ApplicationController
    def ask
        question = params[:question]
        strategy = params[:strategy]
        unless question && strategy
            render json: { error: 'Missing question or strategy' }, status: 400
            return
        end
        render json: { answer: "Hello" }
    end
end
  