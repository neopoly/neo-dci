# Neo::DCI [![Build Status](https://secure.travis-ci.org/neopoly/neo-dci.png?branch=master)](http://travis-ci.org/neopoly/neo-dci)

Simple DCI (Data Context Interaction).
Includes Data, Roles and Context.

[Gem](https://rubygems.org/gems/neo-dci) |
[Source](https://github.com/neopoly/neo-dci) |
[Documentation](http://rubydoc.info/github/neopoly/neo-dci/master/file/README.md)

## Installation

Add this line to your application's Gemfile:

    gem 'neo-dci'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install neo-dci

You can generate base classes for your roles and contexts with

    $ rake neo-dci:setup

## Usage

### Data

```ruby
class User < ActiveRecord::Base
  include Neo::DCI::Data

  attr_accessible
end
```

### Context

```ruby
class Context < Neo::DCI::Context
end

class RenameUserContext < Context
  def initialize(user_id, new_name)
    @user     = User.find(user_id)
    @new_name = new_name
  end

  def call(result)
    @user.role_as(Renamer)
    if @user.rename_to(@new_name)
      result.success! :new_name => @new_name
    else
      result.failure! "renaming failed"
    end
  end
end
```

### Interaction (Role)

```ruby
module Renamer
  extend Neo::DCI::Role

  def rename_to(new_name)
    self.name = new_name
    save
  end
end
```

### Rails Controller

```ruby
class UsersController < ApplicationController
  def rename
    result = RenameUserContext.call(current_user.id, params[:name])
    if result.success?
      new_name = result.data.new_name
      redirect_to users_path, :notice => "Renamed successfully to #{new_name}"
    else
      error = result.error
      render :alert => "Renaming failed: #{error}!"
    end
  end
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
