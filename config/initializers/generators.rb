Beaker::Application.config.generators do |g|
  g.fixture_replacement :factory_girl
  g.helper = false
  g.assets = false
end
