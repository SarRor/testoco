Rails.application.routes.draw do

  root 'home#inicio'
  devise_for :usuarios, controllers: { registrations: "registrations", omniauth_callbacks: 'usuarios/omniauth_callbacks'}
  post "/custom_sign_up", to: "usuarios/omniauth_callbacks#custom_sign_up"
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
