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

  def google_oauth2
    # auth = request.env["omniauth.auth"]
    # raise auth.to_yaml
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @usuario = Usuario.from_omniauth_goo(request.env['omniauth.auth'])

    if @usuario.persisted?
      flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'
      sign_in_and_redirect @usuario, event: :authentication
    else
      session['devise.google_data'] = request.env['omniauth.auth'].except(:extra) # Removing extra as it can overflow some session stores
      redirect_to new_usuario_registration_url, alert: @usuario.errors.full_messages.join("\n")
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
