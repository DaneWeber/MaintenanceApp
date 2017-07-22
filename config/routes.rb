Rails.application.routes.draw do
  resources :chores do
    member do
      patch 'reset_cycle'
    end
  end

  root 'chores#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
