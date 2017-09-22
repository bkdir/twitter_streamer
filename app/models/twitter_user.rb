class TwitterUser < ApplicationRecord
  has_many :tweets, foreign_key: :user_id
  has_many :deleted_tweets, -> { where(deleted: :true) }, 
           class_name: "Tweet", 
           foreign_key: :user_id

  validates :screen_name, :name, presence: true

  def self.find_or_save_user(user)
    find_or_create_by(user_id: user.id, 
                      screen_name: user.screen_name, 
                      name: user.name)
  end
end
