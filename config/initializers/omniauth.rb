Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook,
  	"589945744376715",
    "1f4adf6613b8ee2155d327e6999d9c5a", 
  	:scope => 'email',
  	:display => 'page'
end

OmniAuth.config.on_failure = Proc.new { |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
}
