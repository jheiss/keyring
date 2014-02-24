# keyring:  System keyring abstraction library
# License: MIT (http://www.opensource.org/licenses/mit-license.php)

require 'test/unit'
require 'keyring'

class KeyringBackendTests < Test::Unit::TestCase
  def setup
    @backend = Keyring::Backend.new
  end
  
  class Keyring::Backend::Test < Keyring::Backend; end
  def test_register_implementation
    Keyring::Backend.register_implementation(Keyring::Backend::Test)
    assert Keyring::Backend.implementations.include?(Keyring::Backend::Test)
    Keyring::Backend.implementations.delete(Keyring::Backend::Test)
  end
  def test_create
    # This should be a bit more thorough
    assert_kind_of Keyring::Backend, Keyring::Backend.create
  end
  
  def test_supported
    refute @backend.supported?
  end
  def test_priority
    assert_equal 0, @backend.priority
  end
  def test_set_password
    assert_raises(NotImplementedError) {@backend.set_password('service', 'username', 'password')}
  end
  def test_get_password
    assert_raises(NotImplementedError) {@backend.get_password('service', 'username')}
  end
  def test_delete_password
    assert_raises(NotImplementedError) {@backend.delete_password('service', 'username')}
  end
end
