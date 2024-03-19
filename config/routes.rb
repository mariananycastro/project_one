Rails.application.routes.draw do
  resources :policies, only: %i[show]
end
