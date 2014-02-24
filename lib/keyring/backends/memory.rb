# keyring:  System keyring abstraction library
# License: MIT (http://www.opensource.org/licenses/mit-license.php)

# Stores the keyring in-memory. Useful when you don't need permanant storage.

class Keyring::Backend::Memory < Keyring::Backend
  register_implementation(self)
  
  def initialize
    @keyring = {}
  end
  def supported?
    true
  end
  def priority
    0.1
  end
  
  def get_password(service, username)
    @keyring[service] && @keyring[service][username]
  end
  def set_password(service, username, password)
    @keyring[service] ||= {}
    @keyring[service][username] = password
  end
  def delete_password(service, username)
    @keyring[service] && @keyring[service].delete(username)
  end
end
