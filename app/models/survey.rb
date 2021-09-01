class Survey < ApplicationRecord
	has_many :answers, dependent: :delete_all, inverse_of: :survey
	validates :question, presence: true, length: { minimum: 10 }
	accepts_nested_attributes_for :answers, reject_if: :all_blank, allow_destroy: true
end
