Rails.application.routes.draw do
  root "surveys#index"
  post "votes/update"

  resources :surveys
  get "surveys/result/:id" => "surveys#result", as: "result_survey"
end
