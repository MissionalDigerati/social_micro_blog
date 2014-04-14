module SocialMediaHelper

  def avatar(post, url)
    image = post.avatar
    link_to image_tag("#{image}", class: 'profile-img'), url, target: "_blank" unless image.nil?
  end

end
