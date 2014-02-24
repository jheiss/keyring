# keyring:  System keyring abstraction library
# License: MIT (http://www.opensource.org/licenses/mit-license.php)

require 'test/unit'
require 'mocha/setup'
require 'keyring'

class KeyringTests < Test::Unit::TestCase
  def setup
    @backend = Keyring::Backend::Memory.new
    @keyring = Keyring.new(@backend)
  end
  
  def test_initialize
    keyring = Keyring.new
    assert_kind_of Keyring::Backend, keyring.instance_variable_get(:@backend)
    
    backend = Keyring::Backend::Memory.new
    keyring = Keyring.new(backend)
    assert_equal backend, keyring.instance_variable_get(:@backend)
  end
  
  def test_get_password
    @backend.expects(:get_password).with('service', 'username').returns('password')
    password = @keyring.get_password('service', 'username')
    assert_equal 'password', password
  end
  def test_set_password
    @backend.expects(:set_password).with('service', 'username', 'password')
    @keyring.set_password('service', 'username', 'password')
  end
  def test_delete_password
    @backend.expects(:delete_password).with('service', 'username')
    @keyring.delete_password('service', 'username')
  end
end
