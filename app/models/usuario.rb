class Usuario < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  mount_uploader :imagen, ImagenUploader

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  devise :omniauthable, omniauth_providers: %i[facebook]

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

end
