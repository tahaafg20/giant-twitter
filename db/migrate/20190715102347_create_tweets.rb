class CreateTweets < ActiveRecord::Migration[5.2]
	def change
		create_table :tweets do |t|
			t.string :title
			t.references :user, foreign_key: true
			t.integer :retweet_id
			t.timestamps
		end 
	end
end

