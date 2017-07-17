Rails.application.routes.draw do

	post 'user_profiles/doindex'
	get '/user_profiles/:user_profile_id/docs/:id/download' => 'docs#download', as: 'docs_download'
  root 'user_profiles#index'
  	resources :user_profiles do

  		resources :docs
	end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
