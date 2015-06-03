Rails.application.routes.draw do
  
  concern :tagged do
    resources :tags, only: [ :index ]
  end
  
  concern :taggable do
    resources :tags, except: [ :show, :edit, :update ]
  end
  
  concern :likeable do
    resources :likes, except: [ :show, :edit, :update ]
  end
  
  concern :commentable do
    resources :comments, except: [ :show, :edit, :update ], concerns: :likeable
  end
  
  # visitor and user functionality
  root 'application#home'
  get 'about', to: 'application#about', as: :about
  scope module: 'visitors' do
    resources :bible, :news, :events, :media, :resources, concerns: [ :tagged, :likeable, :commentable ]
    resources :departments do
      resources :contacts
    end
  end
  
  # user and member functionality
  resource :user, module: 'users' do
    get 'login'
    post 'signin'
    get 'logout'
    get 'signup', on: :new
  end
  scope 'user', module: 'users' do
    resources :people
  end
  
  # developer functionality
  resource :developer, module: 'developers'
  namespace :developers do
    resources :visitors, :developers, :members, :maintainers, :adminstrators
    resources :persons do
      resources :relationships
    end
    resources :users do
      resources :contacts
    end
    resources :relationships, :contacts
    resources :bible_articles, :news_articles, :events, :images, :sounds, :videos, :resources, concerns: [ :taggable, :likeable, :commentable ]
    resources :bible_categories, :news_categories, :tags
  end
  
  # maintainer functionality
  resource :maintainer, module: 'maintainers'
  
  # admin functionality
  resource :admin, module: 'admin'
  
  # AYS Department
  namespace :ays do
    root 'department#home'
    resources :events
    # AY Games
    resources :games, module: 'games' do
      collection do
        namespace :jeopardy do
          root 'game#home'
        end
        namespace :family_feud do
          root 'game#home'
        end
      end
    end
  end
  
  # test routes
  #get ':controller(/:action)'
  
end
