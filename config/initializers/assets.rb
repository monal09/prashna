# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile += %w( question_publish.js )
Rails.application.config.assets.precompile += %w( vote_counts.js )
Rails.application.config.assets.precompile += %w( comments.js )
Rails.application.config.assets.precompile += %w( polling.js )
Rails.application.config.assets.precompile += %w( abuse_reports.js )
Rails.application.config.assets.precompile += %w( notification.js )
Rails.application.config.assets.precompile += %w( time_show.js )
Rails.application.configure do
  config.assets.precompile += %w[
    serviceworker.js
  ]
end
