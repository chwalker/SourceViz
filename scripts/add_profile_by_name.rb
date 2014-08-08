#!/usr/bin/env ruby

require 'date'
require 'oauth'
require 'json'

include ApplicationHelper
include TwitterUsersHelper

# Exchange our oauth_token and oauth_token secret for the AccessToken instance.
profile = get_profile(ARGV[0])
if ARGV[1] == 'save'
  refresh_user_profile(profile, false)
else
  puts profile.inspect
end
