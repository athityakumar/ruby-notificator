require_relative 'github_helper'

def github()
  while (true)
  begin
    github_client = github_login()
    puts "\nGithub Notifier\n"
    puts "\nSigned in, as #{github_client.user.name}.\n"
    github_client.auto_paginate = true
    break
  rescue
    puts "Authentication failure. Please try again..."
    require 'fileutils'
    begin
      FileUtils.remove_dir("secrets")
    rescue
      print ""
    end
  end
  end
tot=github_client.user[:followers]
flist=[]; count=0
File.open('data/github.txt', 'r') do |f1|  
while line = f1.gets
flist[count]=line
count+=1
end
end

count=0
puts "\nNew followers:"
myfile=File.new('data/github.txt',"w")
while(count<tot)
  begin
    usernow=github_client.followers(github_client.user[:login])[count][:login]
    if (flist.include?usernow+"\n")
    else
      puts usernow
    end
    myfile.puts(usernow)
  rescue
    break
  end
  count+=1
end
end