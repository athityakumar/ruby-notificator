require_relative 'github_helper'

def github()
  github_client = github_login()
  puts "\nGithub Notifier\n"
  puts "\nSigned in, as #{github_client.user.name}\n"
  github_client.auto_paginate = true
end