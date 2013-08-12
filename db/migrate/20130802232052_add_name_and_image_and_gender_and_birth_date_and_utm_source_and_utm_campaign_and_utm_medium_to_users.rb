class AddNameAndImageAndGenderAndBirthDateAndUtmSourceAndUtmCampaignAndUtmMediumToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :image, :string
    add_column :users, :gender, :string
    add_column :users, :birth_date, :date
    add_column :users, :utm_source, :string
    add_column :users, :utm_campaign, :string
    add_column :users, :utm_medium, :string
  end
end
