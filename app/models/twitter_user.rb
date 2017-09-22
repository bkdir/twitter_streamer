class TwitterUser < ApplicationRecord
  has_many :tweets, foreign_key: :user_id
  has_many :deleted_tweets, -> { where(deleted: :true) }, 
    class_name: "Tweet", foreign_key: :user_id

  validates :screen_name,   presence: :true
  validates :name,    presence: true
end
