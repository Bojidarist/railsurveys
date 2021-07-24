class Survey < ApplicationRecord
	has_many :answers, dependent: :delete_all
	validates :question, presence: true, length: { minimum: 10 }
end
