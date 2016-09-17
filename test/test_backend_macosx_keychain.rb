# keyring:  System keyring abstraction library
# License: MIT (http://www.opensource.org/licenses/mit-license.php)

# These tests require Gnome Keyring to be installed and are skipped otherwise

require 'test/unit'
require 'mocha/setup'
require 'keyring'

begin
  require 'keychain'

  class KeyringBackendMacosxKeychainTests < Test::Unit::TestCase  

    def setup
      @backend = Keyring::Backend::MacosxKeychain.new
      @backend.delete_password('KeyringBackendMacosxKeychainTests', 'username')
    end

    def teardown
      @backend.delete_password('KeyringBackendMacosxKeychainTests', 'username')
    end

    def test_supported
      assert @backend.supported?
    end

    def test_priority
      assert_equal 1, @backend.priority
    end

    def test_no_default_password
      refute @backend.get_password('KeyringBackendMacosxKeychainTests', 'username')
    end

    def test_set_password
      @backend.set_password('KeyringBackendMacosxKeychainTests', 'username', 'password')
      assert_equal 'password', @backend.get_password('KeyringBackendMacosxKeychainTests', 'username')
    end

    def test_delete_nonexistent_password
      refute @backend.delete_password('KeyringBackendMacosxKeychainTests', 'username')
    end

    def test_delete_existing_password
      @backend.set_password('KeyringBackendMacosxKeychainTests', 'username', 'password')
      @backend.delete_password('KeyringBackendMacosxKeychainTests', 'username')
      refute @backend.get_password('KeyringBackendMacosxKeychainTests', 'username')
    end

  end


rescue LoadError
  puts "Skipping MacosxKeychain tests because the native bindings could not be loaded."
end
