# keyring:  System keyring abstraction library
# License: MIT (http://www.opensource.org/licenses/mit-license.php)

class Keyring::Backend
  @implementations = []
  class << self
    attr_accessor :implementations
  end
  def self.register_implementation(impl)
    Keyring::Backend.implementations << impl
  end
  Dir.glob(File.expand_path('backends/*.rb', File.dirname(__FILE__))).each {|b| require b}
  def self.create
    supported = implementations.collect{|i| b = i.new; b.supported? ? b : nil}.compact
    if supported.empty?
      raise(NotImplementedError)
    end
    supported.max{|b| b.priority}
  end
  
  #
  # Backend classes must implement these methods
  #
  
  def supported?
    false
  end
  # Returns a number between 0 and 1 (inclusive) indicating the relative
  # preference for this backend.
  def priority
    0
  end
  def set_password(service, username, password)
    raise NotImplementedError
  end
  def get_password(service, username)
    raise NotImplementedError
  end
  def delete_password(service, username)
    raise NotImplementedError
  end
end
