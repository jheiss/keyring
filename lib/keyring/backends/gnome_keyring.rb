# keyring:  System keyring abstraction library
# License: MIT (http://www.opensource.org/licenses/mit-license.php)

# This is a keyring backend for the Gnome Keyring

class Keyring::Backend::GnomeKeyring < Keyring::Backend
  register_implementation(self)

  def initialize
    require 'gir_ffi-gnome_keyring'
  rescue LoadError
  end
  def supported?
    defined?(::GnomeKeyring) && true
  end
  def priority
    1
  end

  def set_password(service, username, password)
    attrs = get_attrs_for(service, username)
    name = "#{service} (#{username})"
    status, item_id = ::GnomeKeyring.item_create_sync nil, :generic_secret, name, attrs, password, true
    item_id if status == :ok
  end
  def get_password(service, username)
    if item = find_first(service, username)
      item.secret
    else
      false
    end
  end
  def delete_password(service, username)
    if item = find_first(service, username)
      status, info = ::GnomeKeyring.item_delete_sync nil, item.item_id
      status == :ok
    else
      false
    end
  end

  protected

  def find_first(service, username)
    if list = find(service, username)
      list.first
    end
  end

  def find(service, username)
    attrs = get_attrs_for(service, username)
    status, keys = ::GnomeKeyring.find_items_sync :generic_secret, attrs
    keys if status == :ok
  end

  def get_attrs_for(service, username)
    attrs = ::GnomeKeyring::AttributeList.new
    attrs.append_string 'service', service.to_s
    attrs.append_string 'username', username.to_s
    attrs
  end
end
