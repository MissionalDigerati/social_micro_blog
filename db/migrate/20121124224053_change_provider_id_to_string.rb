class ChangeProviderIdToString < ActiveRecord::Migration
  def up
		change_column :social_media, :provider_id, :string
  end

  def down
		change_column :social_media, :provider_id, :integer
  end
end
