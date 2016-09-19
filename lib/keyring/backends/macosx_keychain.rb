# keyring:  System keyring abstraction library
# License: MIT (http://www.opensource.org/licenses/mit-license.php)

# This is a keyring backend for the Apple Keychain
# http://en.wikipedia.org/wiki/Keychain_(Apple)

class Keyring::Backend::MacosxKeychain < Keyring::Backend

  register_implementation(self)

  def initialize
    require 'keychain'
  rescue LoadError
  end

  def supported?
    defined?(::Keychain) && true
  end

  def priority
    1
  end

  # NB: Uses default keychain for everything.
  # This is consistent with the GnomeKeyring implementation
  # No mechanism is provided in the API to support alternative
  # keyring files.
  
  def set_password(service, username, password)

    Keychain.generic_passwords.create(
      :service  => service,
      :password => password,
      :account  => username,
    )

    return true

  rescue Keychain::Error
    return false
  rescue KeychainDuplicateItemError
    return true
  end

  def get_password(service, username)

    scope = Keychain.generic_passwords.where( 
      :service  => service, 
      :account  => username,
    )

    return false if scope.nil?
    return false if scope.first.nil?

    scope.first.password

  end

  def delete_password(service, username)

    scope = Keychain.generic_passwords.where(
      :service  => service,
      :account  => username,
    )

    return false if scope.nil?
    return false if scope.first.nil?

    scope.first.delete

  end

end
