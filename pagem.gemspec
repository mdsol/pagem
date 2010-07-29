# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{pagem}
  s.version = "1.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["David Fenster"]
  s.date = %q{2010-07-28}
  s.description = %q{Pagination helper that works off of scopes (named) to facilitate data retrieval and display.}
  s.email = %q{dfenster@mdsol.com}
  s.extra_rdoc_files = ["README.rdoc", "lib/pagem.rb"]
  s.files = ["README.rdoc", "Rakefile", "lib/pagem.rb", "spec/pagem_spec.rb", "Manifest", "pagem.gemspec"]
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
    else
    end
  else
  end
end
