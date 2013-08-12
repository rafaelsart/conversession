class Conversation < ActiveRecord::Base
    def accessible_by?(id)
        host_id == id || guest_id == id || guest_id == nil
    end

    def closed?
        !ended_at.nil?
    end
end
