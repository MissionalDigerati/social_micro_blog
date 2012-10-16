settings = YAML.load_file(File.join(Rails.root.to_s, "config", "config.yml"))[Rails.env]
MC_API_KEY = settings['mailchimp']['api_key']
MC_NEW_LIST_ID = settings['mailchimp']['new_subscriber_list']