require_relative 'github_helper'

def github()
  while (true)
    begin
      userdetails=["",""]
      github_client = github_login(userdetails)
      uid=userdetails[0]
      pwd=userdetails[1]
      puts "\nGithub Notifier\n"
      puts "\nSigned in, as #{github_client.user.name}.\n"
      github_client.auto_paginate = true
      break
  rescue
      puts "Authentication failure.\nCheck your password and your connection. Please try again..."
      require 'fileutils'
      begin
        FileUtils.remove_dir("secrets")
      rescue
        print ""
      end
    end
  end
  require 'fileutils'
  FileUtils::mkdir_p 'data'
  begin
    json = File.read('data/githubfol.json')
    oldobj = JSON.parse(json)
  rescue
    oldobj=[]
  end
  system ("curl -u \""+uid+":"+pwd+"\" https://api.github.com/user/followers -o data/githubfol.json")

  json = File.read('data/githubfol.json')
  obj = JSON.parse(json)

  system('clear')
  if (oldobj & obj != obj)
    puts "You have new followers:\n\n"
  else
    puts "You have no new followers."
  end
  newobj = obj - oldobj | oldobj - obj
  count=0
  while(1)
    begin
      puts newobj[count]['login']
      count+=1
    rescue
      break
    end
  end
end