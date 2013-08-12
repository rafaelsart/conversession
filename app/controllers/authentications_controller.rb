class AuthenticationsController < ApplicationController

  def create
    omniauth = request.env['omniauth.auth']
    authentication = Authentication.find_by_provider_and_uid(omniauth[:provider], omniauth[:uid])
    user = current_user || User.find_by_email(omniauth[:info][:email]) if authentication.nil?
    # Already authenticated and not logged in
    if authentication && current_user.nil?
      authentication.token = omniauth[:credentials][:token]
      authentication.expires_at = omniauth[:credentials][:expires_at]
      authentication.save
      sign_in_and_redirect(:user, authentication.user)
    # Already authenticated and logged in
    elsif authentication && current_user
      authentication.token = omniauth[:credentials][:token]
      authentication.expires_at = omniauth[:credentials][:expires_at]
      # Authentication associated to another account
      if authentication.user != current_user
        authentication.user = current_user
        flash[:success] = t('devise.omniauth_callbacks.success', :kind => omniauth[:provider].capitalize)
      else
        flash[:success] = t('devise.omniauth_callbacks.already', :kind => omniauth[:provider].capitalize)
      end
      authentication.save!
      redirect_to :back if request.env['HTTP_REFERER']
      redirect_to search_conversation_path
    # Not authenticated but logged in or email already registered
    elsif user
      if !user.confirmed? && user.email == omniauth[:info][:email]
        user.confirmed_at = Time.now
        # user.encrypted_password = "" # Evita falha de segurança mas gera confusão
      end
      if user.add_authentication({ :omniauth => omniauth }).save!(:validate => false)
        flash[:success] = t('devise.omniauth_callbacks.success', :kind => omniauth[:provider].capitalize)
        sign_in_and_redirect(:user, user)
      end
    # Not authenticated, not logged in and email not registered yet (email provided)
    elsif !omniauth[:info][:email].nil? && !omniauth[:info][:email].blank?
      user = User.new
      user.confirmed_at = Time.now
      user.utm_source = session[:utm_source]
      user.utm_campaign = session[:utm_campaign]
      user.utm_medium = session[:utm_medium]
      if user.add_authentication({ :omniauth => omniauth }).save!(:validate => false)
        sign_in_and_redirect(:user, user)
      end
    # Email not provided
    else
      session[:omniauth] = {
        :provider => omniauth[:provider], :uid => omniauth[:uid],
        :name =>  omniauth[:info][:name], :image => omniauth[:info][:image],
        :credentials => omniauth[:credentials], :gender => omniauth[:extra][:raw_info][:gender],
        :birth_date => omniauth[:extra][:raw_info][:birthday], :token => omniauth[:credentials][:token],
        :expires_at => omniauth[:credentials][:expires_at], :information => nil
      }
      redirect_to new_user_registration_path
    end
  end
  
  def failure
    flash[:alert] = t('errors.messages.invalid_credentials')
    redirect_to root_path
  end

end
