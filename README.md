Tobuy
=====
[![Gem Version](https://badge.fury.io/rb/localytics-ruby.svg)](https://badge.fury.io/rb/localytics-ruby)
[![Build Status](https://travis-ci.org/tobuy/localytics-ruby.svg?branch=master)](https://travis-ci.org/tobuy/localytics-ruby)

Ruby wrapper for Localytics API

A lot of inspiration (and code) for how this gem was built come from https://github.com/Mango/mango-ruby


## Description

API to interact with Localytics
https://localytics.com/


## Installation

As usual, you can install it using rubygems.

```
$ gem install localytics-ruby
```

## Usage

```
require 'localytics-ruby'

Localytics.api_key = ENV['LOCALYTICS_API_KEY']
Localytics.api_secret = ENV['LOCALYTICS_API_SECRET']

customerId = 1

begin
  profile = Localytics::Profile.show 1
rescue Localytics::Error => e
  e.each {|code, message| ... }
end
```