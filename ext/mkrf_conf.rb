# http://en.wikibooks.org/wiki/Ruby_Programming/RubyGems#How_to_install_different_versions_of_gems_depending_on_which_version_of_ruby_the_installee_is_using

require 'rubygems'
require 'rubygems/command.rb'
require 'rubygems/dependency_installer.rb' 
begin
  Gem::Command.build_args = ARGV
rescue NoMethodError
end 
inst = Gem::DependencyInstaller.new
begin

  if RUBY_PLATFORM =~ /linux/
    warn "*linux: installing gir_ffi-gnome_keyring..."
    inst.install "gir_ffi-gnome_keyring", '~> 0.0.3'
  end

  if RUBY_PLATFORM =~ /darwin10/
    warn '*osx: installing ruby-keychain'
    inst.install 'ruby-keychain', '~> 0.3.2'
  end

rescue
  exit(1)
end 

# create dummy Rakefile to indicate success
f = File.open(File.join(File.dirname(__FILE__), "Rakefile"), "w")
f.write("task :default\n")
f.close
