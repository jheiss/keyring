# keyring:  System keyring abstraction library
# License: MIT (http://www.opensource.org/licenses/mit-license.php)

require 'test/unit'
require 'keyring'

class KeyringBackendMemoryTests < Test::Unit::TestCase
  def setup
    @backend = Keyring::Backend::Memory.new
  end
  
  def test_supported
    assert @backend.supported?
  end
  def test_priority
    assert_equal 0.1, @backend.priority
  end
  
  def test_set_password
    @backend.set_password('service', 'username', 'password')
    assert_equal 'password', @backend.instance_variable_get('@keyring')['service']['username']
  end
  def test_get_password
    @backend.set_password('service', 'username', 'password')
    assert_equal 'password', @backend.get_password('service', 'username')
    
    # Ensure that get_password behaves properly when asked for things that
    # have not been set
    assert_nil @backend.get_password('service', 'bogus')
    assert_nil @backend.get_password('bogus', 'bogus')
  end
  def test_delete_password
    @backend.set_password('service', 'username', 'password')
    @backend.delete_password('service', 'username')
    assert_nil @backend.instance_variable_get('@keyring')['service']['username']
    assert_nil @backend.get_password('service', 'username')
    
    # Ensure that delete_password behaves properly when asked to delete
    # things that have not been set
    @backend.delete_password('service', 'bogus')
    @backend.delete_password('bogus', 'bogus')
  end
end
