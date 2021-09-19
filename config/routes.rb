Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/site_admins/rails_admin', as: 'rails_admin'
  devise_for :users
  root "surveys#index"
  post "votes/update"
  
  get 'site_admins/admin_panel'
  get 'site_admins/change_survey_status/:id&:status' => 'site_admins#change_survey_status', as: "site_admins_change_survey_status"
  get 'site_admins/download_surveys_xlsx'

  resources :surveys
  get "surveys/result/:id" => "surveys#result", as: "result_survey"
end
