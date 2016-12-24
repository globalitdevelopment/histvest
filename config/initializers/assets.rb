Rails.application.config.assets.version = '1.0'

# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile = %w( *.png *.jpg *.gif *.ico application.css application.js v2.js home.js wysiwyg.js v2.css )
