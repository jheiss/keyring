# keyring:  System keyring abstraction library
# License: MIT (http://www.opensource.org/licenses/mit-license.php)

require File.expand_path('keyring_tests', File.dirname(__FILE__))
require 'test/unit'
require 'mocha/setup'
require 'keyring'

class KeyringBackendMacosxKeychainTests < Test::Unit::TestCase
  include KeyringTestConstants
  
  def setup
    @backend = Keyring::Backend::MacosxKeychain.new
  end
  
  def test_supported
    @backend.security = File.join(TESTCMDDIR, 'macosx/security-wronghelp')
    refute @backend.supported?
    @backend.security = File.join(TESTCMDDIR, 'macosx/bogus')
    refute @backend.supported?
    @backend.security = File.join(TESTCMDDIR, 'macosx/security-righthelp')
    assert @backend.supported?
  end
  def test_priority
    assert_equal 1, @backend.priority
  end
  
  def test_security_command
    assert_equal 'add-generic-password', @backend.security_command('add')
    assert_equal 'find-generic-password', @backend.security_command('find')
    assert_equal 'delete-generic-password', @backend.security_command('delete')
  end
  
  def test_set_password
    @backend.expects(:system).with(
      '/usr/bin/security', 'add-generic-password', '-s', 'service', '-a', 'username', '-w', 'password', '-U')
    # We need to set $? to make up for the fact that system was not actually run
    # FIXME: surely there's a better way?
    `true`
    @backend.set_password('service', 'username', 'password')
  end
  
  def test_get_password
    @backend.security = File.join(TESTCMDDIR, 'macosx/security-find')
    assert_equal 'password', @backend.get_password('service', 'username')
  end
  def test_get_password_hex
    @backend.security = File.join(TESTCMDDIR, 'macosx/security-findhex')
    assert_equal "\0100\0101\0100\0101\0100\0101\0100\0101", @backend.get_password('service', 'hexuser')
  end
  def test_get_password_empty
    @backend.security = File.join(TESTCMDDIR, 'macosx/security-findempty')
    assert_equal '', @backend.get_password('service', 'emptyuser')
  end
  def test_get_password_notfound
    @backend.security = File.join(TESTCMDDIR, 'macosx/security-notfound')
    assert_nil @backend.get_password('bogus', 'bogus')
  end
  
  def test_delete_password_options
    Open3.expects(:popen3).with(
      '/usr/bin/security', 'delete-generic-password', '-s', 'service', '-a', 'username')
    @backend.delete_password('service', 'username')
  end
  def test_delete_password_output
    @backend.security = File.join(TESTCMDDIR, 'macosx/security-delete')
    assert @backend.delete_password('service', 'gooduser')
  end
  def test_delete_password_errors
    @backend.security = File.join(TESTCMDDIR, 'macosx/security-notfound')
    refute @backend.delete_password('bogus', 'bogus')
  end
end
