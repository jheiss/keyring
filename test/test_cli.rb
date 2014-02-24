# keyring:  System keyring abstraction library
# License: MIT (http://www.opensource.org/licenses/mit-license.php)

require 'keyring/cli'
require 'test/unit'
require 'mocha/setup'

class KeyringCLITests < Test::Unit::TestCase
  def setup
    @cli = Keyring::CLI.new(testing: true)
  end
  
  EXE = File.expand_path('../bin/keyring', File.dirname(__FILE__))
  def test_help_option
    assert_match /\AUsage:/, `#{EXE} --help`
    assert $?.success?
  end
  def test_version_option
    assert_equal "#{Keyring::VERSION}\n", `#{EXE} --version`
    assert $?.success?
  end
  
  def test_set
    assert_raise(ArgumentError) {@cli.set([])}
    assert_raise(ArgumentError) {@cli.set(['service'])}
    assert_raise(ArgumentError) {@cli.set(['service', 'username'])}
    
    Keyring.any_instance.expects(:set_password).with('service', 'username', 'password')
    @cli.set(['service', 'username', 'password'])
  end
  def test_get
    assert_raise(ArgumentError) {@cli.get([])}
    assert_raise(ArgumentError) {@cli.get(['service'])}
    
    Keyring.any_instance.expects(:get_password).with('service', 'username').returns('password')
    $stdout = output = StringIO.new
    @cli.get(['service', 'username'])
    $stdout = STDOUT
    assert_equal "password\n", output.string
  end
  def test_delete
    assert_raise(ArgumentError) {@cli.delete([])}
    assert_raise(ArgumentError) {@cli.delete(['service'])}
    
    Keyring.any_instance.expects(:delete_password).with('service', 'username')
    @cli.delete(['service', 'username'])
  end
  
  def test_ensure_arg_presence
    assert_nothing_raised      {@cli.ensure_arg_presence([], 0)}
    assert_raise(ArgumentError) {@cli.ensure_arg_presence([], 1)}
    assert_raise(ArgumentError) {@cli.ensure_arg_presence([''], 1)}
    
    assert_nothing_raised      {@cli.ensure_arg_presence(['a'], 1)}
    assert_raise(ArgumentError) {@cli.ensure_arg_presence(['a'], 2)}
    assert_raise(ArgumentError) {@cli.ensure_arg_presence(['a', ''], 2)}
  end
end
