#!/usr/bin/env ruby

require 'date'
require 'oauth'
require 'json'

include ApplicationHelper
include TwitterUserHelper
include FriendsHelper

update_profile_by_name('TheLoki47', false)
update_all_friends( )
update_all_lists( )
