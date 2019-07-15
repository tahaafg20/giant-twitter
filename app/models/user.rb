class User < ActiveRecord::Base
	has_many :tweets, foreign_key: :user_id, dependent: :destroy

	has_many :relationships, foreign_key: :follower_id, class_name: "Relationship", dependent: :destroy
  has_many :followed, through: :relationships #, source: :followed

  has_many :reverse_relationships, foreign_key: :followed_id, class_name: 'Relationship', dependent: :destroy
  has_many :followers, through: :reverse_relationships #, source: :follower


  validates :username, format: { without: /\s/, message: "must contain no spaces" }
  validates :username, uniqueness: true
  validates :username, presence: true
  validates :name, presence: true
	validates :email, uniqueness: true
	validates :email, presence: true
	validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/, message: "Only valid email allowed."}
	validates :password, length: 8..20, on: :create

	has_secure_password

  def follow!(user)
    followed << user
  end
  
  
  # Returns true if the current user is following the other user.
  def following?(user)
    followed.include?(user) 
  end
    
  def self.search(search)
    where('name ILIKE :term or username ILIKE :term', :term => "%#{search}%")
  end




end

   #First, setup the relationship to the join table using the first line. 
   #We need to specify exactly which foreign_key for the relationship to use. 
   #Normally, when we declare a relationship to a join table, the foreign key is inferred 
   #using the name of the model itself. In this case, since the follower_id is not just a user_id, 
   #we need to be explicit.



