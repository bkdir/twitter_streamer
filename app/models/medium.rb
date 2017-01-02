class Medium < ApplicationRecord
  belongs_to :tweet, 
             foreign_key: :tweet_id, 
             primary_key: :tweet_id,
             optional: true

  validates :tweet_id,  presence: :true
  validates :user_id,   presence: :true
  validates :media_url, presence: :true
  
  def self.save_media(media, tweet_id, user_id, retweeted_media = false)
    media.each do |m| 
      begin
        Medium.new do |medium|
          medium.media_id   = m.id.to_s
          medium.user_id    = user_id
          medium.tweet_id   = tweet_id
          medium.rt_media   = retweeted_media
          medium.media_url  = m.media_url.to_s
          medium.media_type = m.attrs[:type]
        end.save!
      rescue ActiveRecord::ActiveRecordError => exception
        # TODO: send e-mail, maybe
        logger.fatal "Unable to save the media<#{m.id}>"
        logger.fatal "Message: #{exception.message}"
      end
    end
  end

end
