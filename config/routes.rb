Rails.application.routes.draw do
  devise_for :users
  root "surveys#index"
  post "votes/update"

  resources :surveys
  get "surveys/result/:id" => "surveys#result", as: "result_survey"
end
