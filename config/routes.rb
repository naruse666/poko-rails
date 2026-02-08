# frozen_string_literal: true

PokoRails.application.routes.draw do
  get '/', to: 'home#index'
  get '/users/:id', to: 'users#show'
end
