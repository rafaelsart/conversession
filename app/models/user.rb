class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  #
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable

  has_many :authentications

def add_authentication(data)
    if data[:omniauth]
        data = {
            :provider => data[:omniauth][:provider],
            :uid => data[:omniauth][:uid],
            :email => data[:omniauth][:info][:email],
            :name => data[:omniauth][:info][:name],
            :image => data[:omniauth][:info][:image],
            :gender => data[:omniauth][:extra][:raw_info][:gender],
            :birth_date => data[:omniauth][:extra][:raw_info][:birthday],
            :token => data[:omniauth][:credentials][:token],
            :expires_at => data[:omniauth][:credentials][:expires_at],
            :information => data[:omniauth]
        }
    end
    self.email = data[:email] if email.blank?
    self.name = data[:name] if name.blank?
    self.image = data[:image] #if avatar_omniauth.blank?
    self.gender = data[:gender] if gender.blank?
    if birth_date.blank? && valid_date?(data[:birth_date])
        self.birth_date = Date.strptime(data[:birth_date], "%m/%d/%Y")
    end
    # data[:expires_at] = Time.at data[:expires_at].to_i if data[:expires_at]
    authentications.build(:provider => data[:provider], :uid => data[:uid], :token => data[:token], :expires_at => data[:expires_at])
    return self
end

  private

    def valid_date?(str, format="%m/%d/%Y")
      Date.strptime(str,format) rescue false
    end
    
end
