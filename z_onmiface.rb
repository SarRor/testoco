
>> Add to Gemfile
gem 'omniauth-facebook', '~> 5.0'

>> Add in your config/initializers/devise.rb:
config.omniauth :facebook, "1804348799662234", "2eb57eea33d43896c3f600a699be9591", token_params: { parse: :json }

>> In app/models/usuario.rb
devise :omniauthable, omniauth_providers: %i[facebook]


>> Restart the server

>> Add the following line to your layouts in order to provide facebook authentication:
<%= link_to "Sign in with Facebook", usuario_facebook_omniauth_authorize_path %>


>> In config/routes.rb
devise_for :usuarios, controllers: { omniauth_callbacks: 'usuarios/omniauth_callbacks' }


>> Create app/controllers/usuarios/omniauth_callbacks_controller.rb
class Usuarios::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    # auth = request.env["omniauth.auth"]
    # raise auth.to_yaml
    @usuario = Usuario.from_omniauth(request.env["omniauth.auth"])
    if @usuario.persisted?
      @usuario.remember_me = true
      sign_in_and_redirect @usuario, event: :authentication # this will throw if @usuario is not activated
      set_flash_message(:notice, :success, kind: "Facebook") if is_navigational_format?
      return
    end
    session["devise.auth"] = request.env["omniauth.auth"]
    render :edit
  end
  def custom_sign_up
    @usuario = Usuario.from_omniauth(session["devise.auth"])
    if @usuario.update(usuario_params)
      sign_in_and_redirect @usuario, event: :authentication
    else
      render :edit
    end
  end
  def failure
    #redirect_to root_path
    redirect_to new_usuario_session_path, notice: "No pudimos loguearte,
    Error: #{params[:error_description]}, Motivo: #{params[:error_reason]}"
  end

  private
    def usuario_params
      params.require(:usuario).permit(:nombre, :email, :imagen)
    end
end



>> In app/models/usuario.rb
def self.from_omniauth(auth)
  where(provider: auth.provider, uid: auth.uid).first_or_create do |usuario|
    if auth[:info]
      usuario.email = auth.info.email
      usuario.nombre = auth[:info][:name]
    end
    usuario.password = Devise.friendly_token[0,20]
    # usuario.imagen = auth.info.image # assuming the user model has an image
    # If you are using confirmable and the provider(s) you use validate emails,
    # uncomment the line below to skip the confirmation emails.
    # usuario.skip_confirmation!
  end
end


>> In views/onmiauth_callbacks/edit.haml
=form_tag "/custom_sign_up", method: :post do
  %ul
    -@usuario.errors.full_messages.each do |error|
      %li= error
  %div
    %label{for: "usuario_email"} Correo electrónico
    =email_field_tag "usuario[email]", @usuario.email
  %div
    %label{for: "usuario_nombre"} Nombre
    =text_field_tag "usuario[nombre]", @usuario.nombre
  %div
    =submit_tag "Completar registro"
