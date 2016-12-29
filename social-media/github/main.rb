require_relative 'github_helper'

def github()
  textview=""
  numinpage=100
  require 'fileutils'
  FileUtils::mkdir_p 'data'
  FileUtils::mkdir_p 'data/github' 
  FileUtils::mkdir_p 'data/github/stars'
  FileUtils::mkdir_p 'data/github/forks'
  FileUtils::mkdir_p 'data/github/pulls'
  userdetails=[]
  github_login(userdetails)
  uid=userdetails[0]
  pwd=userdetails[1]
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
  puts "\nSigned in as #{userdetails[2]}.\nStarting download, please wait..."
  counthere=1
  repos=[]
  while(1)
    system ("curl -s -u \""+uid+":"+pwd+"\" \"https://api.github.com/user/repos?per_page=#{numinpage}&page=#{counthere}\" -o data/github/repos.json")
    json = File.read('data/github/repos.json')
    temprepo=JSON.parse(json)
    break if temprepo==[]
    repos += temprepo
    counthere+=1
  end
    myfile=File.new("data/github/repos.json","w")
    myfile.write(JSON.pretty_generate(repos))

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
  totcount*=3;totcount+=2; countnow=-1
  system("clear")
  countnow+=1
  print "\nDownloading: "
  print countnow*100/totcount
  puts "% complete..."

  counthere=1
  foll=[]
  while(1)
    system ("curl -s -u \""+uid+":"+pwd+"\" \"https://api.github.com/user/followers?per_page=#{numinpage}&page=#{counthere}\" -o data/github/followers.json")
    json = File.read('data/github/followers.json')
    tempfoll=JSON.parse(json)
    break if tempfoll==[]
    foll += tempfoll
    counthere+=1
  end
    myfile=File.new("data/github/followers.json","w")
    myfile.write(JSON.pretty_generate(foll))

  system("clear")
  countnow+=1
  print "\nDownloading: "
  print countnow*100/totcount
  puts "% complete..."

  counthere=1
  issues=[]
  while(1)
    system ("curl -s -u \""+uid+":"+pwd+"\" \"https://api.github.com/issues?per_page=#{numinpage}&page=#{counthere}\" -o data/github/issues.json")
    json = File.read('data/github/issues.json')
    tempissues=JSON.parse(json)
    break if tempissues==[]
    issues += tempissues
    counthere+=1
  end
    myfile=File.new("data/github/issues.json","w")
    myfile.write(JSON.pretty_generate(issues))

  disp_stars=""; disp_forks=""; disp_pulls=""
  disp_stars_r=""; disp_forks_r=""; disp_pulls_r=""
  countout=0
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
      print "\nDownloading: "
      print countnow*100/totcount
      puts "% complete..."

      counthere=1
      stars=[]
      while(1)
        system ("curl -s -u \""+uid+":"+pwd+"\" \"https://api.github.com/repos/"+name+"/"+text+"/stargazers?per_page=#{numinpage}&page=#{counthere}\" -o data/github/stars/"+name+"-"+text+".json")
        json = File.read("data/github/stars/"+name+"-"+text+".json")
        tempstars=JSON.parse(json)
        break if tempstars==[]
        stars += tempstars
        counthere+=1
      end
        myfile=File.new("data/github/stars/"+name+"-"+text+".json","w")
        myfile.write(JSON.pretty_generate(stars))

      system("clear"); countnow+=1
      print "\nDownloading: "
      print countnow*100/totcount
      puts "% complete..."

      counthere=1
       forks=[]
      while(1)
        system ("curl -s -u \""+uid+":"+pwd+"\" \"https://api.github.com/repos/"+name+"/"+text+"/forks?per_page=#{numinpage}&page=#{counthere}\" -o data/github/forks/"+name+"-"+text+".json")
        json = File.read("data/github/forks/"+name+"-"+text+".json")
        tempforks=JSON.parse(json)
        break if tempforks==[]
        forks += tempforks
        counthere+=1
      end
        myfile=File.new("data/github/forks/"+name+"-"+text+".json","w")
        myfile.write(JSON.pretty_generate(forks))



      system("clear"); countnow+=1
      print "\nDownloading: "
      print countnow*100/totcount
      puts "% complete..."

      counthere=1
      pulls=[]
      while(1)
        system ("curl -s -u \""+uid+":"+pwd+"\" \"https://api.github.com/repos/"+name+"/"+text+"/pulls?per_page=#{numinpage}&page=#{counthere}\" -o data/github/pulls/"+name+"-"+text+".json")
        json = File.read("data/github/pulls/"+name+"-"+text+".json")
        temppulls=JSON.parse(json)
        break if temppulls==[]
        pulls += temppulls
        counthere+=1
      end
        myfile=File.new("data/github/pulls/"+name+"-"+text+".json","w")
        myfile.write(JSON.pretty_generate(pulls))

      newpulls= pulls-oldpulls
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
      newpulls= oldpulls - pulls
      count=0
      while(1)
        begin
          disp_pulls_r=disp_pulls_r+newpulls[count]['title']+" at "+text+" by "+name+" created by "+newpulls[count]['user']['login']+"\n"
          count+=1
        rescue
          break
        end
      end


      newstars=stars-oldstars
      count=0
      while(1)
        begin
          disp_stars=disp_stars+newstars[count]['login']+" at "+text+" by "+name+"\n"
          count+=1
        rescue
          break
        end
      end

      newstars=oldstars-stars
      count=0
      while(1)
        begin
          disp_stars_r=disp_stars_r+newstars[count]['login']+" at "+text+" by "+name+"\n"
          count+=1
        rescue
          break
        end
      end


      newforks = forks - oldforks
      count=0
      while(1)
        begin
          disp_forks=disp_forks+newforks[count]['full_name']+" at "+text+" by "+name+"\n"
          count+=1
        rescue
          break
        end
      end

      newforks = oldforks-forks
      count=0
      while(1)
        begin
          disp_forks_r=disp_forks_r+newforks[count]['full_name']+" at "+text+" by "+name+"\n"
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
  if (countnow*100/totcount)<98
    textview+= "Download interrupted. Result may not be accurate.\n\n"
  end
  if (disp_pulls=="")
    textview+= "You have no new updates in your pull requests.\n"
  else
    textview+= "\nYou have new updates in your pull requests: \n"
    textview+= "\n"+disp_pulls+"\n"
  end
  if (disp_pulls_r!="")
    textview+= "\nSome pull requests have been closed: \n"
    textview+= "\n"+disp_pulls_r+"\n"
  end

  if (disp_forks=="")
    textview+= "You have no new forkers.\n"
  else
    textview+= "\nYou have new forkers: \n"
    textview+= "\n"+disp_forks+"\n"
  end

  if (disp_forks_r!="")
    textview+= "\nYou have lost some forkers: \n"
    textview+= "\n"+disp_forks+"\n"
  end

  if (disp_stars=="")
    textview+= "You have no new stargazers.\n"
  else
    textview+= "\nYou have new stargazers: \n"
    textview+= "\n"+disp_stars+"\n"
  end
  if (disp_stars_r!="")
    textview+= "\nYou have lost some stargazers: \n"
    textview+= "\n"+disp_stars+"\n"
  end



  if (oldfoll & foll != foll)
    textview+= "\nYou have new followers:\n\n"
  else
    textview+= "You have no new followers.\n"
  end
  newfoll = foll - oldfoll
  count=0
  while(1)
    begin
      textview+= newfoll[count]['login']+"\n"
      count+=1
    rescue
      break
    end
  end

  if (oldfoll & foll != oldfoll)
    textview+= "You have lost some followers:\n\n\n"
  end
  newfoll = oldfoll - foll
  count=0
  while(1)
    begin
      textview+= newfoll[count]['login']+"\n"
      count+=1
    rescue
      break
    end
  end

  if (oldissues & issues != issues)
    textview+= "\nNew issues have been assigned to you:\n\n"
  else
    textview+= "No new issue has been assigned to you.\n"
  end
  newissues = issues - oldissues
  count=0
  while(1)
    begin
      counta=0
      while(1)
        begin
          todisplay=newissues[count]['assignees'][counta]['login']
           if (counta!=0)
            textview+= " and "
          end
          textview+= todisplay
          counta+=1
        rescue
          break
        end
      end
      todisplay=(newissues[count]['url'].split('/')) [5]
      if (counta>1)
        textview+= " have assigned a new issue at "
      else
        textview+= " has assigned a new issue at "
      end
      textview+= todisplay
      textview+= " by "
      textview+= (newissues[count]['url'].split('/')) [4]
      textview+= ":\n"
      textview+= newissues[count]['title']+"\n"
      count+=1
    rescue
      break
    end
  end

  if (oldissues & issues != oldissues)
    textview+= "\nSome issues have been unassigned from you:\n\n\n"
  end
  newissues = oldissues - issues
  count=0
  while(1)
    begin
      counta=0
      while(1)
        begin
          todisplay=newissues[count]['assignees'][counta]['login']
           if (counta!=0)
            textview+= " and "
          end
          textview+= todisplay
          counta+=1
        rescue
          break
        end
      end
      todisplay=(newissues[count]['url'].split('/')) [5]
      if (counta>1)
        textview+= " have unassigned an issue at "
      else
        textview+= " has unassigned an issue at "
      end
      textview+= todisplay
      textview+= " by "
      textview+= (newissues[count]['url'].split('/')) [4]
      textview+= ":\n"
      textview+= newissues[count]['title']+"\n"
      count+=1
    rescue
      break
    end
  end
  puts textview
  time=Time.new
  timetext=""; line=""; timeline=""
  timetext+=time.day.to_s;timetext+="-";timetext+=time.month.to_s;timetext+="-";timetext+=time.year.to_s
  begin
    system("(ps -e | grep sendmail) > ./data/github/mail.txt")
    myfile=File.new("data/github/mail.txt","r")
    line=myfile.readline
    myfile.close
  rescue
  end
    if line!=""
      puts "Would you like to send the message to #{userdetails[3]} using sendmail (you need root previledges)?"
      choice=gets
      if choice[0]=="y" || choice[0]=="Y"
        puts "Please wait..."
        myfile=File.new("data/github/mail.txt","w")
        begin
          timefile=File.new("data/github/time.txt","r")
          timeline=timefile.readline
          timefile.close
        rescue
        end
        mailtext="To: #{userdetails[3]}\nFrom: #{userdetails[3]}\nSubject: Update of Github Notifications\nContent-Type: text/html\n\nDear @#{uid},\n\nI have some Github Notifications you might be interested to have a look at.  These notifications are from #{timeline} - #{timetext}."
        mailtext+="\n\n"+textview+"\n\n"
        mailtext+="\n\nHave an awesome day!\n\nYours sincerely,\n\nGitHub Notifier <a href=\"https://github.com/athityakumar/ruby-notificator/\">(View source code on GitHub)</a>."
        myfile.write(mailtext)
        myfile.close
        system("sudo sendmail -f #{userdetails[3]} #{userdetails[3]} < data/github/mail.txt")
        puts "Mail sent."
      end
    end
  puts "\nThanx!"
  myfile=File.new("data/github/time.txt","w")
  myfile.write(timetext)
  myfile.close
end