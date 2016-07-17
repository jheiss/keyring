# Keyring

Store and access your passwords safely

This library provides a easy way to access the system keyring service from ruby.
It can be used in any application that needs safe password storage.

The keyring services supported by this library:
* Mac OS X Keychain: the Apple Keychain service in Mac OS X
* GNOME 2 Keyring
* In-memory keychain

Additional keyring services we'd like to support:
* KDE KWallet
* SecretServiceKeyring: for newer GNOME and KDE environments
* Windows Credential Manager
* Windows Credential Manager, aka Windows Vault

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'keyring'
```

And then execute:

```shell
$ bundle
```

Or install it yourself as:

```shell
$ gem install keyring
```

## Usage

The basic usage of keyring is simple: just call Keyring#set_password and
Keyring#get_password:

```ruby
require 'keyring'
keyring = Keyring.new
keyring.set_password('service', 'username', 'password')
password = keyring.get_password('service', 'username')
keyring.delete_password('service', 'username')
```

'service' is an arbitrary string identifying your application.

By default keyring will attempt to pick the best backend supported on your system.  You can specify a particular backend:

```ruby
require 'keyring'
keyring = Keyring.new(Keyring::Backend::Memory.new)
```

## Platform notes

Gnome Keyring uses the [GirFFI](https://github.com/mvz/gir_ffi) bindings, which
requires the introspection bindings to be installed (as well as gnome-keyring).
`apt-get install gnome-keyring libgirepository1.0-dev` for Debian/Ubuntu.

## Credits

Copyright 2013-2014, Jason Heiss, wvengen

Inspired by the keyring library for Python:
https://bitbucket.org/kang/python-keyring-lib

## License

MIT

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
