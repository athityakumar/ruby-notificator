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
   FileUtils::mkdir_p 'data/github' 
  begin
    json = File.read('data/github/followers.json')
    oldfoll = JSON.parse(json)
  rescue
    oldfoll=[]
  end
  begin
    json = File.read('data/github/issues.json')
    oldissues = JSON.parse(json)
  rescue
   oldissues=[]
  end
  system("clear")
  puts "Processing: "
  system ("curl -u \""+uid+":"+pwd+"\" https://api.github.com/user/followers -o data/github/followers.json")
  system ("curl -u \""+uid+":"+pwd+"\" https://api.github.com/issues -o data/github/issues.json")
  json = File.read('data/github/followers.json')
  foll = JSON.parse(json)
  json = File.read('data/github/issues.json')
  issues = JSON.parse(json)


  system('clear')
  if (oldfoll & foll != foll)
    puts "You have new followers:\n\n"
  else
    puts "You have no new followers."
  end
  newfoll = foll - oldfoll | oldfoll - foll
  count=0
  while(1)
    begin
      puts newfoll[count]['login']
      count+=1
    rescue
      break
    end
  end

  if (oldissues & issues != issues)
    puts "\n\nNew issues have been assigned to you:\n\n"
  else
    puts "\n\nNo new issue has been assigned to you."
  end
  newissues = issues - oldissues | oldissues - issues
  count=0
  while(1)
    begin
      counta=0
      while(1)
        begin
          todisplay=newissues[count]['assignees'][counta]['login']
           if (counta!=0)
            print " and "
          end
          print todisplay
          counta+=1
        rescue
          break
        end
      end
      todisplay=(newissues[count]['url'].split('/')) [5]
      if (counta>1)
        print " have assigned a new issue at "
      else
        print " has assigned a new issue at "
      end
      print todisplay
      print " by "
      print (newissues[count]['url'].split('/')) [4]
      puts ":"
      puts newissues[count]['title']
      count+=1
    rescue
      break
    end
  end
end