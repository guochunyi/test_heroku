module UsersHelper
  def gravatar_for(user)
    example_url = "example@railstutorial.org"
    gravatar_id = Digest::MD5::hexdigest(example_url.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end