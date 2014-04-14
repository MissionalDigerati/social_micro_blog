class CreateSocialAvatars < ActiveRecord::Migration
  def change
    create_table :social_avatars do |t|
      t.string :provider
      t.string :provider_id, null: false
      t.string :account
      t.string :avatar_url

      t.timestamps
    end
  end
end
