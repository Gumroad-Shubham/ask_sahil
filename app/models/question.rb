class Question < ApplicationRecord
    validates :question, presence: true, length: { maximum: 140 }
    validates :strategy, presence: true, length: { maximum: 140 }
    validates :answer, length: { maximum: 1000 }
    validates :audio_src_url, length: { maximum: 255 }
    
    attribute :ask_count, :integer, default: 1
  end
  