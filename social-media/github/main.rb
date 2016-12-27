require_relative 'github_helper'

def github()
  while (true)
    begin
      userdetails=["",""]
      github_client = github_login(userdetails)
      uid=userdetails[0]
      pwd=userdetails[1]
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
  FileUtils::mkdir_p 'data/github/stars'
  FileUtils::mkdir_p 'data/github/forks'
  FileUtils::mkdir_p 'data/github/pulls'
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
  puts "\nGithub Notifier\n\nSigned in, as #{github_client.user.name}.\n\nProcessing: 0% complete"
  system ("curl -u \""+uid+":"+pwd+"\" https://api.github.com/user/repos -o data/github/repos.json")
  system("clear")
  puts "\nGithub Notifier\n\nSigned in, as #{github_client.user.name}.\n\nProcessing: 0% complete"
  system ("curl -u \""+uid+":"+pwd+"\" https://api.github.com/user/followers -o data/github/followers.json")
  system("clear")
  puts "\nGithub Notifier\n\nSigned in, as #{github_client.user.name}.\n\nProcessing: 0% complete"
  system ("curl -u \""+uid+":"+pwd+"\" https://api.github.com/issues -o data/github/issues.json")
  json = File.read('data/github/followers.json')
  foll = JSON.parse(json)
  json = File.read('data/github/issues.json')
  issues = JSON.parse(json)
  json = File.read('data/github/repos.json')
  repos = JSON.parse(json)

  totcount=0
  repoarr=[]
  while(1)
    begin
      repoarr[totcount]=repos[totcount]['full_name']
      totcount+=1
    rescue
      break
    end
  end
  totcount*=3
  disp_stars=""; disp_forks=""; disp_pulls=""

  countnow=-1;  countout=0
  while(1)
    begin
      text=(repoarr[countout].split('/'))[1]
      name=(repoarr[countout].split('/'))[0]
      begin
        json = File.read("data/github/pulls/"+name+"-"+text+".json")
        oldpulls = JSON.parse(json)
      rescue
        oldpulls=[]
      end
      begin
        json = File.read("data/github/stars/"+name+"-"+text+".json")
        oldstars = JSON.parse(json)
      rescue
        oldstars=[]
      end
      begin
        json = File.read("data/github/forks/"+name+"-"+text+".json")
        oldforks = JSON.parse(json)
      rescue
        oldforks=[]
      end
      system("clear"); countnow+=1
      print "\nGithub Notifier\n\nSigned in, as #{github_client.user.name}.\n\nProcessing: "
      print countnow*100/totcount
      puts "% complete..."
      system ("curl -u \""+uid+":"+pwd+"\" https://api.github.com/repos/"+name+"/"+text+"/stargazers -o data/github/stars/"+name+"-"+text+".json")
      system("clear"); countnow+=1
      print "\nGithub Notifier\n\nSigned in, as #{github_client.user.name}.\n\nProcessing: "
      print countnow*100/totcount
      puts "% complete..."
      system ("curl -u \""+uid+":"+pwd+"\" https://api.github.com/repos/"+name+"/"+text+"/forks -o data/github/forks/"+name+"-"+text+".json")
      system("clear"); countnow+=1
      print "\nGithub Notifier\n\nSigned in, as #{github_client.user.name}.\n\nProcessing: "
      print countnow*100/totcount
      puts "% complete..."
      system ("curl -u \""+uid+":"+pwd+"\" https://api.github.com/repos/"+name+"/"+text+"/pulls -o data/github/pulls/"+name+"-"+text+".json")      
      json = File.read('data/github/pulls/'+name+"-"+text+'.json')
      pulls = JSON.parse(json)      
      json = File.read('data/github/stars/'+name+"-"+text+'.json')
      stars = JSON.parse(json)
      json = File.read('data/github/forks/'+name+"-"+text+'.json')
      forks = JSON.parse(json)

      newpulls= oldpulls - pulls | pulls-oldpulls
      count=0
      while(1)
        begin
          disp_pulls=disp_pulls+newpulls[count]['title']+" at "+text+" by "+name+" created by "+newpulls[count]['user']['login']
          if (oldpulls == [])
            disp_pulls=disp_pulls+" *NEW\n"
          else
            disp_pulls=disp_pulls+"\n"
          end
          count+=1
        rescue
          break
        end
      end


      newstars=oldstars - stars | stars-oldstars
      count=0
      while(1)
        begin
          disp_stars=disp_stars+newstars[count]['login']+" at "+text+" by "+name+"\n"
          count+=1
        rescue
          break
        end
      end

      newforks = forks - oldforks | oldforks - forks
      count=0
      while(1)
        begin
          disp_forks=disp_forks+newforks[count]['full_name']+" at "+text+" by "+name+"\n"
          count+=1
        rescue
          break
        end
      end
      countout+=1
    rescue
      break
    end
  end

  system('clear')
  if (disp_pulls=="")
    puts "You have no new updates pull requests."
  else
    puts "\nYou have new updates in your pull requests: "
    puts "\n"+disp_pulls
  end

  if (disp_forks=="")
    puts "You have no new forkers."
  else
    puts "\nYou have new forkers: "
    puts "\n"+disp_forks
  end

    if (disp_stars=="")
    puts "You have no new stargazers."
  else
    puts "\nYou have new stargazers: "
    puts "\n"+disp_stars
  end

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
    puts "\nNo new issue has been assigned to you."
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