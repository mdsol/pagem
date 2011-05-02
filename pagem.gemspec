# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{pagem}
  s.version = "1.0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ben Young"]
  s.date = %q{2011-05-02}
  s.description = %q{Pagination helper that works off of scopes (named) to facilitate data retrieval and display.}
  s.email = %q{byoung@mdsol.com}
  s.extra_rdoc_files = ["README.rdoc", "lib/pagem.rb"]
  s.files = ["Gemfile", "Gemfile.lock", "Manifest", "README.rdoc", "Rakefile", "lib/pagem.rb", "public/images/pagem/arrow_left.gif", "public/images/pagem/arrow_leftend.gif", "public/images/pagem/arrow_right.gif", "public/images/pagem/arrow_rightend.gif", "public/stylesheets/pagem.css", "rails/init.rb", "rails_root/app/controllers/application_controller.rb", "rails_root/app/controllers/users_controller.rb", "rails_root/app/models/study.rb", "rails_root/app/models/user.rb", "rails_root/app/views/users/edit.html.erb", "rails_root/app/views/users/new.html.erb", "rails_root/app/views/users/show.html.erb", "rails_root/config/boot.rb", "rails_root/config/database.yml", "rails_root/config/environment.rb", "rails_root/config/environments/test.rb", "rails_root/config/routes.rb", "rails_root/db/migrate/20090101120000_create_users.rb", "rails_root/db/migrate/20090101120001_create_studies.rb", "rails_root/script/generate", "spec/pagem_spec.rb", "spec/spec_helper.rb", "pagem.gemspec"]
  s.homepage = %q{http://github.com/mdsol/pagem}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Pagem", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{pagem}
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Pagination helper that works off of scopes (named) to facilitate data retrieval and display.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rails>, ["= 2.3.4"])
    else
      s.add_dependency(%q<rails>, ["= 2.3.4"])
    end
  else
    s.add_dependency(%q<rails>, ["= 2.3.4"])
  end
end
