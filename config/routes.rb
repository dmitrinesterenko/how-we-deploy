Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/:words', to:'gifme#view'
  root 'gifme#view', {words: 'congratulations you win'}
end
