class Tweet < ActiveRecord::Base

    belongs_to :user
	has_many :likes

    validates :title, presence: true
	validates :title, length: { maximum: 140 }

end

