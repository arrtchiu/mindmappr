MindMappr::Application.routes.draw do
  resources :ideas, only: [:index, :show, :create, :destroy]
  root 'ideas#index'
end
