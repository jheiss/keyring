# keyring:  System keyring abstraction library
# License: MIT (http://www.opensource.org/licenses/mit-license.php)

# These tests require Gnome Keyring to be installed and are skipped otherwise

require 'test/unit'
require 'mocha/setup'
require 'keyring'

begin
  require 'gir_ffi-gnome_keyring'

  class KeyringBackendGnomeKeyringTests < Test::Unit::TestCase

    def setup
      @backend = Keyring::Backend::GnomeKeyring.new
      @backend.delete_password('service', 'username')
    end

    def teardown
      @backend.delete_password('service', 'username')
    end

    def test_supported
      assert @backend.supported?
    end

    def test_priority
      assert_equal 1, @backend.priority
    end

    def test_no_default_password
      refute @backend.get_password('service', 'username')
    end

    def test_set_password
      @backend.set_password('service', 'username', 'password')
      assert_equal 'password', @backend.get_password('service', 'username')
    end

    def test_delete_nonexistent_password
      refute @backend.delete_password('service', 'username')
    end

    def test_delete_existing_password
      @backend.set_password('service', 'username', 'password')
      @backend.delete_password('service', 'username')
      refute @backend.get_password('service', 'username')
    end

  end


rescue LoadError
  puts "Skipping GnomeKeyring tests because the native bindings could not be loaded."
end
