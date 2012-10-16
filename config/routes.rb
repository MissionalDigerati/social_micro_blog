SocialBlog::Application.routes.draw do
  match 'learn-more' => 'contact#learn_more', :as => :learn_more, :method => :get
  match 'learn-more-submitted' => 'contact#submit_learn_more_form', :as => :learn_more_submit, :method => :post
	match 'about-us' => 'high_voltage/pages#show', :id => 'about_us', :as => :about_us
	match '/post/:provider/:provider_id' => 'social_media#show', :as => :post
	match '/donate' => redirect("http://bit.ly/Ry6XlK"), :as => :donate

	root :to => "social_media#index"
  get "social_media/index"

	# 301 redirects
	#
	match "/2011/04/be-a-trader/", :to => redirect("/post/twitter/250997866577944577")
	match "/2010/08/power-of-social-media/", :to => redirect("/post/twitter/250997631860486144")
	match "/2010/03/featured-in-mission-frontiers/", :to => redirect("/post/twitter/250997316696301568")
	match "/2010/02/joshua-project-iphone-app/", :to => redirect("/post/twitter/250997316696301568")
	match "/2010/02/video-dont-waste-your-life/", :to => redirect("/post/twitter/250997152426360832")
	match "/page/2/", :to => redirect("/?page=2")
	match "/page/3/", :to => redirect("/?page=3")
	match "/2010/01/video-perspective/", :to => redirect("/post/twitter/250996845743075329")
	match "/2009/12/state-of-christianity/", :to => redirect("/post/twitter/250995084609339392")
	match "/2009/12/major-in-missions/", :to => redirect("/post/twitter/250994785794547712")
	match "/2009/12/ready-for-missions/", :to => redirect("/post/twitter/250994550250799104")
	match "/2009/11/video-explore/", :to => redirect("/post/twitter/250769880452849664")
	match "/2009/11/life-perspective/", :to => redirect("/")
	match "/2009/10/video-strategy/", :to => redirect("/post/twitter/251768096015134720")
	match "/2009/10/can-god-use-computer-geeks/", :to => redirect("/post/twitter/251769251831107584")
end
