module TwitterUsersHelper
  def bigger_image(url)
    url.gsub!("_normal", "_bigger")
  end
end
