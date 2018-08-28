OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, '163263814588-pg9jucrv59foia5mvuj1fdoii9eknbs5.apps.googleusercontent.com', 'BtPHk2wJ3Iqp9cCIPzhN-b0y'
end
