class ChangeOpentokTokenToText < ActiveRecord::Migration
  def change
	remove_column :conversations, :opentok_token
	remove_column :conversations, :opentok_session_id
	add_column :conversations, :opentok_token, :text
	add_column :conversations, :opentok_session, :text
  end
end
