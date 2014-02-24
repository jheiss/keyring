# keyring:  System keyring abstraction library
# License: MIT (http://www.opensource.org/licenses/mit-license.php)

require "keyring/version"

class Keyring
  require 'keyring/backend'
  
  # If you want a particular backend then use, for example,
  # Keyring.new(Keyring::Backend::Memory.new)
  def initialize(backend=nil)
    @backend = backend || Keyring::Backend.create
  end
  
  def get_password(service, username)
    @backend.get_password(service, username)
  end
  def set_password(service, username, password)
    @backend.set_password(service, username, password)
  end
  def delete_password(service, username)
    @backend.delete_password(service, username)
  end
end
