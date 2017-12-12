Gem::Specification.new do |s|
  s.name = 'solidus_mercado_pago'
  s.version     = '0.1'
  s.summary     = 'Solidus plugin to integrate Mercado Pago'
  s.description = 'Integrates Mercado Pago with Solidus'
  s.author      = "Ngelx"
  s.files       = `git ls-files -- {app,config,lib,test,spec,features}/*`.split("\n")
  s.homepage    = 'https://github.com/manuca/spree_mercado_pago'
  s.email       = 'ngel@protonmail.com'
  s.license     = 'MIT'

  s.add_dependency 'spree_core', '~> 3.2.0.rc2'
  s.add_dependency 'rest-client', '~> 2.0'

  s.add_dependency 'bootstrap-sass',  '>= 3.3.5.1', '< 3.4'
  s.add_dependency 'canonical-rails', '~> 0.1.0'
  s.add_dependency 'jquery-rails',    '~> 4.1'

  s.add_development_dependency 'capybara-accessible'

  s.test_files = Dir["spec/**/*"]
end
