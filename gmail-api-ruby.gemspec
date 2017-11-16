# -*- encoding: utf-8 -*-

$:.push File.expand_path('../lib', __FILE__)
require 'gmail/version'

Gem::Specification.new do |s|
  s.name = "gmail-api-ruby"
  s.summary = "A Ruby interface to Gmail API (NO IMAP, NO SMTP), with all the tools you will need."
  s.description = "A Ruby interface to Gmail API (NO IMAP, NO SMTP).
  Search, read and send multipart emails; archive, mark as read/unread,
  delete emails; and manage labels. Everything is done through the Gmail API without going through IMAP or SMTP Protocol
  This is pretty much in alpha right now, though it's vaguely functional. All help gratefully received."
  s.version      = Gmail::VERSION
  s.platform     = Gem::Platform::RUBY
  s.authors      = ["Keiran Betteley", "Julien Hobeika"]
  s.homepage     = "http://github.com/carpela/gmail-api-ruby"
  s.licenses     = ['MIT']
  s.files        = Dir.glob("lib/**/*") + %w(CHANGELOG.md LICENSE README.md Rakefile)
  s.test_files   = Dir.glob("{test,spec,features}/**/*")
  s.require_path = 'lib'

  s.required_ruby_version = '>= 1.9.3'
  s.add_dependency "mime", ">= 0.1"
  s.add_dependency "mail", ">= 2.2.1"
  s.add_dependency "activesupport", "~> 4"
  s.add_dependency('google-api-client', ['>= 0.10.0', '< 0.11.0'])
  s.add_dependency('googleauth', ['>= 0.5.0', '< 1.0.0'])
  s.add_dependency "hooks", ">= 0.4.0"
  s.add_dependency "hashie", ">= 3.3.2"
  s.add_dependency 'stringex', '>= 1.0'

  s.add_development_dependency "rake"
  s.add_development_dependency "test-unit"
  s.add_development_dependency('mocha', '~> 1.0.0')
  s.add_development_dependency('shoulda', '~> 3.5.0')
  s.add_development_dependency "gem-release"
end
