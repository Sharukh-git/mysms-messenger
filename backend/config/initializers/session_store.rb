Rails.application.config.session_store :cookie_store,
  key: '_mysms_session',          # Custom session cookie name
  same_site: :none,              # Required for cross-origin cookies (e.g., API on Render, frontend on Vercel)
  secure: Rails.env.production?  # Only send cookies over HTTPS in production
