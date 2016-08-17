# -*- encoding: utf-8 -*-
# stub: pagem 1.0.7 ruby lib

Gem::Specification.new do |s|
  s.name = "pagem"
  s.version = "1.0.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Ben Young"]
  s.date = "2016-08-17"
  s.description = "Pagination helper that works off of scopes (named) to facilitate data retrieval and display."
  s.email = "byoung@mdsol.com"
  s.extra_rdoc_files = ["README.rdoc", "lib/pagem.rb"]
  s.files = ["Gemfile", "Gemfile.lock", "Manifest", "README.rdoc", "Rakefile", "lib/pagem.rb", "pagem.gemspec", "rails/init.rb", "rails_root/Gemfile", "rails_root/README", "rails_root/Rakefile", "rails_root/app/assets/images/rails.png", "rails_root/app/assets/javascripts/application.js", "rails_root/app/assets/stylesheets/application.css", "rails_root/app/controllers/application_controller.rb", "rails_root/app/helpers/application_helper.rb", "rails_root/app/views/layouts/application.html.erb", "rails_root/config.ru", "rails_root/config/application.rb", "rails_root/config/boot.rb", "rails_root/config/database.yml", "rails_root/config/environment.rb", "rails_root/config/environments/development.rb", "rails_root/config/environments/production.rb", "rails_root/config/environments/test.rb", "rails_root/config/initializers/backtrace_silencers.rb", "rails_root/config/initializers/inflections.rb", "rails_root/config/initializers/mime_types.rb", "rails_root/config/initializers/secret_token.rb", "rails_root/config/initializers/session_store.rb", "rails_root/config/initializers/wrap_parameters.rb", "rails_root/config/locales/en.yml", "rails_root/config/routes.rb", "rails_root/db/seeds.rb", "rails_root/doc/README_FOR_APP", "rails_root/public/404.html", "rails_root/public/422.html", "rails_root/public/500.html", "rails_root/public/favicon.ico", "rails_root/public/index.html", "rails_root/public/robots.txt", "rails_root/script/rails", "rails_root/test/performance/browsing_test.rb", "rails_root/test/test_helper.rb", "spec/pagem_spec.rb", "spec/spec_helper.rb", "vendor/assets/images/pagem/arrow_left.gif", "vendor/assets/images/pagem/arrow_leftend.gif", "vendor/assets/images/pagem/arrow_right.gif", "vendor/assets/images/pagem/arrow_rightend.gif", "vendor/assets/stylesheets/pagem.css"]
  s.homepage = "http://github.com/mdsol/pagem"
  s.rdoc_options = ["--line-numbers", "--title", "Pagem", "--main", "README.rdoc"]
  s.rubyforge_project = "pagem"
  s.rubygems_version = "2.4.8"
  s.summary = "Pagination helper that works off of scopes (named) to facilitate data retrieval and display."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rails>, ["= 3.1.12"])
    else
      s.add_dependency(%q<rails>, ["= 3.1.12"])
    end
  else
    s.add_dependency(%q<rails>, ["= 3.1.12"])
  end
end
