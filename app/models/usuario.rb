class Usuario < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  mount_uploader :imagen, ImagenUploader

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  devise :omniauthable, omniauth_providers: [:facebook, :google_oauth2]

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |usuario|
      if auth[:info]
        usuario.email = auth.info.email
        usuario.nombre = auth[:info][:name]
        usuario.imagen = auth.info.image
      end
      usuario.password = Devise.friendly_token[0,20]
    end
  end

  def self.from_omniauth_goo(access_token)
    data = access_token.info
    usuario = Usuario.where(email: data['email']).first

    # Uncomment the section below if you want users to be created if they don't exist
    unless usuario
        usuario = Usuario.create(nnombre: data['name'],
           email: data['email'],
           password: Devise.friendly_token[0,20]
        )
    end
    usuario
  end


end
