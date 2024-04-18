Rails.application.routes.draw do
  resources :policies, only: %i[show index]
    
  get 'insured_person/:email', to: 'policies#insured_person_by_email', as: 'insured_person_by_email', controller: 'policies', :constraints => { :email => /.*/ }
end
