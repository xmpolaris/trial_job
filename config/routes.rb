TrialJob::Application.routes.draw do
  match 'api/v1/principals/list' => 'home#index'

  root :to => 'home#index'
end
