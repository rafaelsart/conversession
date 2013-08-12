class ChangeOpentokSessionToOpentokSessionId < ActiveRecord::Migration
  def change
	remove_column :conversations, :opentok_session
	add_column :conversations, :opentok_session_id, :text
  end
end
