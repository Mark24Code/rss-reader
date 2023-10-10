Gem::Specification.new do |s|
  s.name        = 'rss-reader'
  s.version     = '1.0.0'
  s.summary     = 'RSS Reader!'
  s.description = 'A simple cli RSS Reader'
  s.authors     = ['Mark24']
  s.email       = 'mark.zhangyoung@gmail.com'
  s.files       = ['lib/*.rb']
  s.homepage    =
    'https://github.com/Mark24Code/rss-reader'
  s.license = 'MIT'

  s.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  s.bindir = 'exe'
  s.executables = s.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  s.require_paths = ['lib']
  s.add_dependency 'async', '~> 2.6'
  s.add_dependency 'colorize', '~> 1.1.0'
  s.add_dependency 'nokogiri', '~> 1.15.4'
  s.add_dependency 'rss', '~> 0.3.0'
  s.add_dependency 'tty-link', '~> 0.1.1'
end
