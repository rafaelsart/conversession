class ConversationsController < ApplicationController
  before_filter :authenticate_user!

  def search
      @conversation = Conversation.where(:ended_at => nil).where("guest_id IS NULL OR guest_id = ?", current_user.id).order("created_at ASC").first
      if @conversation.nil?
          opentok = OpenTok::OpenTokSDK.new OPENTOK[:api_key], OPENTOK[:api_secret]
          properties = { OpenTok::SessionPropertyConstants::P2P_PREFERENCE => "enabled" }
          opentok_session = opentok.create_session request.remote_addr, properties
          opentok_token = opentok.generate_token :session_id => opentok_session
          @conversation = Conversation.new
          @conversation.host_id = current_user.id
          @conversation.language = "en"
          @conversation.opentok_session_id = opentok_session.to_s
          @conversation.opentok_token = opentok_token
          @conversation.save
      end
      redirect_to :action => :show, :id => @conversation.id
  end

  def show
    @conversation = Conversation.find params[:id]
    if !@conversation.accessible_by? current_user.id
        redirect_to :action => :search, :notice => "You are not part of this conversation."
        return
    elsif @conversation.closed?
        redirect_to :action => :search, :notice => "Your previous conversation has been closed."
        return
    end
    if @conversation.host_id != current_user.id && @conversation.guest_id.nil?
        @conversation.guest_id = current_user.id
        @conversation.save
    end
    @api_key
  end
end
