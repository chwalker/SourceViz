#!/usr/bin/env ruby

require 'date'
require 'oauth'
require 'json'

include ApplicationHelper
include TwitterUsersHelper

if ARGV[1] == 'save'
  update_profile_by_name(ARGV[0], false)
else
  puts get_profile(ARGV[0]).inspect
end
