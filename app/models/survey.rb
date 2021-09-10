class Survey < ApplicationRecord
    enum status: [:active, :pending, :rejected]
    after_initialize :set_default_status, :if => :new_record?

    has_many :answers, dependent: :delete_all, inverse_of: :survey
    has_many :geo_votes, dependent: :delete_all
    belongs_to :user
    validates :question, presence: true, length: { minimum: 10 }
    accepts_nested_attributes_for :answers, reject_if: :all_blank, allow_destroy: true

    def set_default_status
        self.status ||= :pending
    end
end
