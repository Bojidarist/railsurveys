class Survey < ApplicationRecord
	has_many :answers, dependent: :delete_all, inverse_of: :survey
	has_many :geo_votes, dependent: :delete_all
	validates :question, presence: true, length: { minimum: 10 }
	accepts_nested_attributes_for :answers, reject_if: :all_blank, allow_destroy: true
end
