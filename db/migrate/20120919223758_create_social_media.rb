class CreateSocialMedia < ActiveRecord::Migration
  def change
    create_table :social_media do |t|
      t.string :provider
			t.string :account
      t.integer :provider_id, null: false
      t.text :content
      t.datetime :provider_created_datetime

      t.timestamps
    end
  end
end
