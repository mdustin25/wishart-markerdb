# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'
Rails.application.config.assets.precompile += %w( wishart/banners/survey_with_prize.svg )
Rails.application.config.assets.precompile += %w( tmic-banner-left-back.jpg )
Rails.application.config.assets.precompile += %w( tmic-banner-right-back.jpg )
Rails.application.config.assets.precompile += %w( wishart-banner-logo.png )

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
