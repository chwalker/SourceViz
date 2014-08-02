#!/usr/bin/env ruby

require 'date'
require 'json'

TwitterUser.all.each do |user|
  user.is_friends = true
  user.save
end

TwitterUser.all.each do |user|
  puts user.to_json + "\n\n"
end
