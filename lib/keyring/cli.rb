# keyring:  System keyring abstraction library
# License: MIT (http://www.opensource.org/licenses/mit-license.php)

require 'slop'
require 'keyring'

class Keyring::CLI
  def initialize(options={})
    @options = options
    
    @method = @arg = nil
    @opts = Slop.parse(:help => true) do
      banner 'Usage: keyring get|set|delete <service> <username> [password (for set)]'
      
      on :v, :version, 'Print the version' do
        puts Keyring::VERSION
        exit
      end
      
      command 'set' do
        # FIXME: option to prompt for password
        run do |opts, args|
          @method = :set
          @arg = args
        end
      end
      command 'get' do
        run do |opts, args|
          @method = :get
          @arg = args
        end
      end
      command 'delete' do
        run do |opts, args|
          @method = :delete
          @arg = args
        end
      end
    end
  end
  
  def main
    if @method && respond_to?(@method)
      send(@method, @arg)
    else
      puts @opts
      exit 1
    end
  end
  
  def set(args)
    ensure_arg_presence(args, 3)
    keyring = Keyring.new
    keyring.set_password(args[0], args[1], args[2])
  end
  def get(args)
    ensure_arg_presence(args, 2)
    keyring = Keyring.new
    puts keyring.get_password(args[0], args[1])
  end
  def delete(args)
    ensure_arg_presence(args, 2)
    keyring = Keyring.new
    keyring.delete_password(args[0], args[1])
  end
  
  def ensure_arg_presence(args, count)
    0.upto(count-1) do |i|
      if !args[i] || args[i].empty?
        if !@options[:testing]
          puts @opts
          exit 1
        else
          raise ArgumentError
        end
      end
    end
  end
end