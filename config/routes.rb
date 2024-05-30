Rails.application.routes.draw do

  resources :expression_profiles, :only => [:index, :show]

  mount Unearth::Engine => "/unearth", as: "unearth"
  mount SeqSearch::Engine => "/seq_search"
  mount Moldbi::Engine => "/structures"

  # API 
  mount Conditionapi::ConditionRequest => '/api'
  mount Chemicalapi::ChemicalRequest => '/api'
  mount Geneapi::GeneRequest => '/api'
  mount Proteinapi::ProteinRequest => '/api'
  mount Karyotypeapi::KaryotypeRequest => '/api'
  mount Generalapi::GeneralRequest => '/api'
  # mount Nutreport::Nutrepo =>'/api'
  # mount Contentreport::Contentrepo => '/api'

  # information pages
  %w{ about manual contact downloads markerdb_api compliance }.each do |page|
    get page => "pages##{page}"
  end

  # shared resources
  resources :lab_tests, :only => [:index, :show]  
  get 'conditions/category/:category' => 'conditions#show_category', 
    :as => :category
  resources :conditions, :only=>[:index,:show]
  resources :references

  # biomarkers
  get 'biomarkers' => 'biomarkers#index'
  resources :genes, :only=>[:index, :show] do 
    resources :sequence_variants
    get 'download_fasta' => 'genes#download_fasta'
  end

  resources :sequence_variants, :only => [:index, :show]
  resources :chemicals,  :only => [:index, :show] 
  resources :proteins, :only => [:index, :show] do
    get 'download_fasta' => 'proteins#download_fasta'
  end
  resources :karyotypes, :only => [:index, :show]
  resources :consumption, :only => [:index]

  get "categories/diag/diagnostic"       => 'biomarker_categories#diagnostic'
  get "categories/diag/predictive"       => 'biomarker_categories#predictive'
  get "categories/exposure" => 'biomarker_categories#exposure'
  get 'categories/:marker_category' => 'biomarker_categories#index'
  
  
  # biomarker id urls
  # TODO make polymorphic controller for biomarkers
  #  get ':id' => 'biomarkers#show',
  #    :id => /M[A-Z][0-9A-Z]{3,5}/,

  # get ':id' => redirect('/chemicals/%{id}'), 
  #   :id => /MC[0-9A-Z]{3,5}/

  # get ':id' => 'genes#show',
  #   :id => /MG[0-9A-Z]{3,5}/

  # get ':id' => redirect('/proteins/%{id}'),
  #   :id => /MP[0-9A-Z]{3,5}/


  # search
  #get 'search/advanced' => 'search#advanced', :as => :advanced_search

  # the this sets the url to /text_query instead of /pages/text_query
  get 'text_query' => "pages#text_query", :as => :text_query
  root to: "pages#main"

  get "pages/download_all_proteins"
  get "pages/download_all_chemicals"
  get "pages/download_all_sequence_variants"
  get "pages/download_all_karyotypes"
  get "pages/download_all_diagnostics"
  get "pages/download_all_diagnostic_chemicals"
  get "pages/download_all_diagnostic_proteins"
  get "pages/download_all_diagnostic_karyotypes"
  get "pages/download_all_prognostics"
  get "pages/download_all_predictives"
  get "pages/download_all_predictive_genetics"
  get "pages/download_all_exposures"
  get "pages/download_all_exposure_chemicals"
  
  get "/404", :to => "error#not_found"
  get "/422", :to => "error#unacceptable"
  get "/500", :to => "error#internal_error"
 

end
