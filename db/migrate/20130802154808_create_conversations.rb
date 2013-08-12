class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.integer :host_id
      t.integer :guest_id
      t.timestamp :ended_at
      t.integer :ended_by
      t.string :language
      t.string :opentok_session_id
      t.string :opentok_token

      t.timestamps
    end
    add_index :conversations, :host_id
    add_index :conversations, :guest_id
  end
end
