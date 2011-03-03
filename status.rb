#!/usr/bin/env ruby

$:.unshift(File.join(File.dirname(__FILE__),'..','lib','ruby'))

# include current directory in rubylib
$:.unshift(".")

require 'status_application'

sa = StatusApplication.new

action = ARGV.shift
action = "list" unless action
args = ARGV

sa.do_action(action, args)
sa.do_action("list") unless action =~ /^l/ or action =~ /^p/

sa.quit
