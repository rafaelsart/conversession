class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
        t.string   "provider",   :null => false
        t.string   "uid",        :null => false
        t.string   "token"
        t.datetime "expires_at"
        t.datetime "created_at", :null => false
        t.datetime "updated_at", :null => false
        t.integer  "user_id",    :null => false
        
        t.timestamps
    end

    add_index "authentications", ["provider", "uid"], :name => "index_authentications_on_provider_and_uid"
    add_index "authentications", ["user_id"], :name => "index_authentications_on_user_id"
  end
end
