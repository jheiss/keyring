# keyring:  System keyring abstraction library
# License: MIT (http://www.opensource.org/licenses/mit-license.php)

# This is a keyring backend for the Apple Keychain
# http://en.wikipedia.org/wiki/Keychain_(Apple)

# Consider switching to ruby-keychain gem to avoid password in command line
# https://rubygems.org/gems/ruby-keychain
# https://github.com/fcheung/keychain

require 'open3'

class Keyring::Backend::MacosxKeychain < Keyring::Backend
  register_implementation(self)
  
  attr_accessor :security
  def initialize
    @security = '/usr/bin/security'
  end
  def supported?
    File.exist?(@security) && `#{@security} -h`.include?('find-generic-password')
  end
  def priority
    1
  end
  
  def security_command(operation)
    "#{operation}-generic-password"
  end
  
  def set_password(service, username, password)
    cmd = [
      @security,
      security_command('add'),
      '-s', service,
      '-a', username,
      # FIXME: password in command line, sad panda!
      '-w', password,
      '-U',
    ]
    system(*cmd)
    if !$?.success?
      raise
    end
  end
  def get_password(service, username)
    password = nil
    cmd = [
      @security,
      security_command('find'),
      '-s', service,
      '-a', username,
      '-g',
      # '-w',
    ]
    Open3.popen3(*cmd) do |stdin, stdout, stderr, wait_thr|
      stderr.each do |line|
        if line =~ /\Apassword: (.*)/
          pw = $1
          if pw == ''
            password = pw
          elsif pw =~ /\A"(.*)"\z/
            password = $1
          elsif pw =~ /\A0x(\h+)/
            password = [$1].pack("H*")
          end
        end
      end
      # security exits with 44 if the entry does not exist.  We just want to return
      # nil rather than raise an exception in that case.
      if ![0,44].include?(wait_thr.value.exitstatus)
        raise
      end
    end
    password
  end
  def delete_password(service, username)
    cmd = [
      @security,
      security_command('delete'),
      '-s', service,
      '-a', username,
    ]
    Open3.popen3(*cmd) do |stdin, stdout, stderr, wait_thr|
      case wait_thr.value.exitstatus
      when 0
        return true
      when 44
        return false
      else
        raise
      end
    end
  end
end
