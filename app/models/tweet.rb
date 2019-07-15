class Tweet < ActiveRecord::Base

    belongs_to :user

    validates :title, presence: true
	validates :title, length: { maximum: 140 }

end

