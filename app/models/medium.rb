class Medium < ApplicationRecord
  belongs_to :tweet, foreign_key: :tweet_id, 
                     primary_key: :tweet_id,
                     optional: true

  validates :tweet_id, :media_url, :created_at, presence: :true
  validates :tweet_id, uniqueness: {scope: :media_url} 
  
  def self.save_media(media, tweet_id, retweeted_media = false)
    media.each do |m| 
      begin
        Medium.new do |medium|
          medium.tweet_id   = tweet_id
          medium.media_url  = m.media_url.to_s
          medium.media_type = m.attrs[:type]
          medium.created_at = Time.now
        end.save!
      rescue ActiveRecord::ActiveRecordError => e
        logger.fatal "Unable to save the media<#{m.id}>\nMessage: #{e.message}"
      end
    end
  end

end
