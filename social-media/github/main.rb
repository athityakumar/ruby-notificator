require_relative 'github_helper'

def github()
  textview=""
  numinpage=100
  require 'fileutils'
  FileUtils::mkdir_p 'social-media/github/data'
  userdetails=[]
  github_login(userdetails)
  uid=userdetails[0]
  pwd=userdetails[1]
  begin
    json = File.read('social-media/github/data/data.json')
    oldnotifications = JSON.parse(json)
  rescue
    oldnotifications={}
  end
  begin
    json = File.read('social-media/github/data/followers.json')
    oldfoll = JSON.parse(json)
  rescue
    oldfoll=[]
  end
  begin
    json = File.read('social-media/github/data/issues.json')
    oldissues = JSON.parse(json)
  rescue
   oldissues=[]
  end
  system("clear")
  puts "\nSigned in as #{userdetails[2]}.\nStarting download, please wait..."
  counthere=1
  repos=[]
  while(1)
    system ("curl -s -u \""+uid+":"+pwd+"\" \"https://api.github.com/user/repos?per_page=#{numinpage}&page=#{counthere}\" -o social-media/github/data/repos.json")
    json = File.read('social-media/github/data/repos.json')
    temprepo=JSON.parse(json)
    break if temprepo==[]
    repos += temprepo
    counthere+=1
  end
    myfile=File.new("social-media/github/data/repos.json","w")
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
  totcount*=4;totcount+=2; countnow=-1
  system("clear")
  countnow+=1
  print "\nDownloading: "
  print countnow*100/totcount
  puts "% complete..."

  counthere=1
  foll=[]
  while(1)
    system ("curl -s -u \""+uid+":"+pwd+"\" \"https://api.github.com/user/followers?per_page=#{numinpage}&page=#{counthere}\" -o social-media/github/data/followers.json")
    json = File.read('social-media/github/data/followers.json')
    tempfoll=JSON.parse(json)
    break if tempfoll==[]
    foll += tempfoll
    counthere+=1
  end
    myfile=File.new("social-media/github/data/followers.json","w")
    myfile.write(JSON.pretty_generate(foll))

  system("clear")
  countnow+=1
  print "\nDownloading: "
  print countnow*100/totcount
  puts "% complete..."

  counthere=1
  issues=[]
  while(1)
    system ("curl -s -u \""+uid+":"+pwd+"\" \"https://api.github.com/issues?per_page=#{numinpage}&page=#{counthere}\" -o social-media/github/data/issues.json")
    json = File.read('social-media/github/data/issues.json')
    tempissues=JSON.parse(json)
    break if tempissues==[]
    issues += tempissues
    counthere+=1
  end
    myfile=File.new("social-media/github/data/issues.json","w")
    myfile.write(JSON.pretty_generate(issues))

  countout=0
  notifications={}
#Repo-wise extraction begins here
  texthtml=textview
  while(1)
    begin
      text=(repoarr[countout].split('/'))[1]
      name=(repoarr[countout].split('/'))[0]
      fullname=name+"/"+text
    rescue
      break
    end
      notifications[fullname]={}
      
      system("clear"); countnow+=1
      print "\nDownloading: "
      print countnow*100/totcount
      puts "% complete..."

      counthere=1
      stars=[]
      while(1)
        system ("curl -s -u \""+uid+":"+pwd+"\" \"https://api.github.com/repos/"+name+"/"+text+"/stargazers?per_page=#{numinpage}&page=#{counthere}\" -o social-media/github/data/data.json")
        json = File.read("social-media/github/data/data.json")
        tempstars=JSON.parse(json)
        break if tempstars==[]
        stars += tempstars
        counthere+=1
      end
      notifications[fullname]["stars"]=[]
      count=0
      while(1)
        begin
          notifications[fullname]["stars"].push(stars[count]['login'])
          count+=1
        rescue
          break
        end
      end


      system("clear"); countnow+=1
      print "\nDownloading: "
      print countnow*100/totcount
      puts "% complete..."

      counthere=1
      forks=[]
      while(1)
        system ("curl -s -u \""+uid+":"+pwd+"\" \"https://api.github.com/repos/"+name+"/"+text+"/forks?per_page=#{numinpage}&page=#{counthere}\" -o social-media/github/data/data.json")
        json = File.read("social-media/github/data/data.json")
        tempforks=JSON.parse(json)
        break if tempforks==[]
        forks += tempforks
        counthere+=1
      end
      myfile.close
      notifications[fullname]["forks"]=[]
      count=0
      while(1)
        begin
          notifications[fullname]["forks"].push(forks[count]['owner']['login'])
          count+=1
        rescue
          break
        end
      end
      system("clear"); countnow+=1
      print "\nDownloading: "
      print countnow*100/totcount
      puts "% complete..."

      counthere=1
      pulls=[]
      while(1)
        system ("curl -s -u \""+uid+":"+pwd+"\" \"https://api.github.com/repos/"+name+"/"+text+"/pulls?per_page=#{numinpage}&page=#{counthere}\" -o social-media/github/data/data.json")
        json = File.read("social-media/github/data/data.json")
        temppulls=JSON.parse(json)
        break if temppulls==[]
        pulls += temppulls
        counthere+=1
      end

      notifications[fullname]["pulls"]=[]
      count=0
      while(1)
        begin
          notifications[fullname]["pulls"].push({"title"=> pulls[count]['title'],"login"=>pulls[count]['user']['login'],"url"=>pulls[count]['html_url'],"no"=>pulls[count]['number'],"updated"=>pulls[count]['updated_at']})
          count+=1
        rescue
          break
        end
      end

      system("clear"); countnow+=1
      print "\nDownloading: "
      print countnow*100/totcount
      puts "% complete..."

      counthere=1
      repissues=[]
      while(1)
        system ("curl -s -u \""+uid+":"+pwd+"\" \"https://api.github.com/repos/"+name+"/"+text+"/issues?per_page=#{numinpage}&page=#{counthere}\" -o social-media/github/data/data.json")
        json = File.read("social-media/github/data/data.json")
        temprepissues=JSON.parse(json)
        break if temprepissues==[]
        repissues += temprepissues
        counthere+=1
      end
      notifications[fullname]["issues"]=[]
      count=0
      while(1)
        begin
          notifications[fullname]["issues"].push({"title"=> repissues[count]['title'],"login"=>repissues[count]['user']['login'],"url"=>repissues[count]['html_url'],"no"=>repissues[count]['number'],"updated"=>repissues[count]['updated_at']})
          count+=1
        rescue
          break
        end
      end
      countout+=1
  end
  
  myfile=File.new("./social-media/github/data/data.json","w")
  myfile.write(JSON.pretty_generate(notifications))

  system('clear')
  if (countnow*100/totcount)<98
    textview+= "Download interrupted. Result may not be accurate.\n\n"
  end

  countout=0
  while(1)
    textview_h=""
    begin
      text=(repoarr[countout].split('/'))[1]
      name=(repoarr[countout].split('/'))[0]
      fullname=name+"/"+text
    rescue
      break
    end
    datanew=notifications[fullname]
    dataold=oldnotifications[fullname]
    if (dataold==nil)
      dataold=  {"stars"=> [],"forks"=> [],"pulls"=> [], "issues"=> []}
    end
    starnew=datanew["stars"] - dataold["stars"]
    starold=dataold["stars"] - datanew["stars"]
    if (starnew!=[])
      textview_h+="You have new stargazers:\n"
      countinside=0
      while(1)
        begin
          textview_h+="- "+starnew[countinside]+"\n"
        rescue
          break
        end
        countinside+=1
      end
    end
    if (starold!=[])
      textview_h+="You have lost some stargazers:\n"
      countinside=0
      while(1)
        begin
          textview_h+="- "+starold[countinside]+"\n"
        rescue
          break
        end
        countinside+=1
      end
    end

    forknew=datanew["forks"] - dataold["forks"]
    forkold=dataold["forks"] - datanew["forks"]
    if (forknew!=[])
      textview_h+="You have new forkers:\n"
      countinside=0
      while(1)
        begin
          textview_h+="- "+forknew[countinside]+"\n"
        rescue
          break
        end
        countinside+=1
      end
    end
    if (forkold!=[])
      textview_h+="You have lost some forkers:\n"
      countinside=0
      while(1)
        begin
          textview_h+="- "+forkold[countinside]+"\n"
        rescue
          break
        end
        countinside+=1
      end
    end

    pullnew=datanew["pulls"] - dataold["pulls"]
    pullold=dataold["pulls"] - datanew["pulls"]
    if (pullnew!=[])
      textview_h="You have new pull requests:\n"
      countinside=0
      while(1)
        begin
          textview_h="- #{pullnew[countinside]['title']} by #{pullnew[countinside]['login']}. (#{pullnew[countinside]['url']})"
          if (dataold["pulls"][countinside]==nil)
            textview_h=" *NEW\n"
          else
            textview_h="\n"
          end
        rescue
          break
        end
        countinside+=1
      end
    end
    if (pullold!=[])
      textview_h+="Some pull requests have been closed:\n"
      countinside=0
      while(1)
        begin
          textview_h+=s"- #{pullold[countinside]['title']} by#{pullold[countinside]['login']}. (#{pullold[countinside]['url']}) \n"
        rescue
          break
        end
        countinside+=1
      end
    end

    issuenew=datanew["issues"] - dataold["issues"]
    issueold=dataold["issues"] - datanew["issues"]
    if (issuenew!=[])
      textview_h+="You have new issues:\n"
      countinside=0
      while(1)
        begin
          textview_h+="- #{issuenew[countinside]['title']} by #{issuenew[countinside]['login']}. (#{issuenew[countinside]['url']})"
          if (dataold["issues"][countinside]==nil)
            textview_h+=" *NEW\n"
          else
            textview_h+="\n"
          end
        rescue
          break
        end
        countinside+=1
      end
    end
    if (issueold!=[])
      textview_h+="Some issues have been closed:\n"
      countinside=0
      while(1)
        begin
          textview_h+=s"- #{issueold[countinside]['title']} by #{issueold[countinside]['login']}. (#{issueold[countinside]['url']}) \n"
        rescue
          break
        end
        countinside+=1
      end
    end
    countout+=1
    if (textview_h!="")
      textview+="\nYou have some updates in #{fullname}:\n\n"+textview_h
      texthtml+="\n<b>You have some updates in <a href=\"www.github.com/#{fullname}\">#{fullname}</a>:</b>\n\n"+textview_h
    end
  end


  textview_n=""
  if (oldfoll & foll != foll)
    textview+= "\nYou have new followers:\n\n"
    texthtml+="\n<b>You have new followers:</b>\n\n"
  end
  newfoll = foll - oldfoll
  count=0
  while(1)
    begin
      textview_n+="- "+newfoll[count]['login']+"\n"
      count+=1
    rescue
      break
    end
  end
  textview+=textview_n; texthtml+=textview_n

  if (oldfoll & foll != oldfoll)
    textview+= "\nYou have lost some followers:\n\n\n"
    texthtml+="\n<b>You have lost some followers:</b>\n\n\n"
  end
  newfoll = oldfoll - foll
  count=0
  while(1)
    begin
      textview_n+= newfoll[count]['login']+"\n"
      count+=1
    rescue
      break
    end
  end
  textview+=textview_n; texthtml+=textview_n

  if (oldissues & issues != issues)
    textview+= "\nNew issues have been assigned to you:\n\n"
    texthtml+="\n<b>New issues have been assigned to you:</b>\n\n"
  end
  newissues = issues - oldissues
  count=0
  while(1)
    begin
      counta=0
      while(1)
        begin
          todisplay="- "
          todisplay+=newissues[count]['assignees'][counta]['login']
           if (counta!=0)
            textview_n+= " and "
          end
          textview_n+= todisplay
          counta+=1
        rescue
          break
        end
      end
      todisplay=(newissues[count]['url'].split('/')) [5]
      if (counta>1)
        textview_n+= " have assigned a new issue at "
      else
        textview_n+= " has assigned a new issue at "
      end
      textview_n+= todisplay
      textview_n+= " by "
      textview_n+= (newissues[count]['url'].split('/')) [4]
      textview_n+= ":\n"
      textview_n+= newissues[count]['title']+"\n"
      count+=1
    rescue
      break
    end
  end
  textview+=textview_n; texthtml+=textview_n


  if (oldissues & issues != oldissues)
    textview+= "\nSome issues have been unassigned from you:\n\n\n"
    texthtml+= "\n<b>Some issues have been unassigned from you:</b>\n\n\n"
  end
  newissues = oldissues - issues
  count=0
  while(1)
    begin
      counta=0
      while(1)
        begin
          todisplay="- "
          todisplay+=newissues[count]['assignees'][counta]['login']
           if (counta!=0)
            textview_n+= " and "
          end
          textview_n+= todisplay
          counta+=1
        rescue
          break
        end
      end
      todisplay=(newissues[count]['url'].split('/')) [5]
      if (counta>1)
        textview_n+= " have unassigned an issue at "
      else
        textview_n+= " has unassigned an issue at "
      end
      textview_n+= todisplay
      textview_n+= " by "
      textview_n+= (newissues[count]['url'].split('/')) [4]
      textview_n+= ":\n"
      textview_n+= newissues[count]['title']+"\n"
      count+=1
    rescue
      break
    end
  end
  textview+=textview_n
  texthtml+=textview_n
  puts textview

  time=Time.new
  timetext=""; line=""; timeline=""
  timetext+=time.day.to_s;timetext+="-";timetext+=time.month.to_s;timetext+="-";timetext+=time.year.to_s
  begin
    system("(ps -e | grep sendmail) > ./social-media/github/data/mail.txt")
    myfile=File.new("social-media/github/data/mail.txt","r")
    line=myfile.readline
    myfile.close
  rescue
  end
    if line!=""
      puts "Would you like to send the message to #{userdetails[3]} using sendmail (you need root previledges)?"
      choice=gets
      if choice[0]=="y" || choice[0]=="Y"
        puts "Please wait..."
        myfile=File.new("social-media/github/data/mail.txt","w")
        begin
          timefile=File.new("social-media/github/data/time.txt","r")
          timeline=timefile.readline
          timefile.close
        rescue
        timeline="epoch"
        end
        mailtext="To: #{userdetails[3]}\nFrom: #{userdetails[3]}\nSubject: Update of Github Notifications\nContent-Type: text/html\n\nDear @#{uid},<br><br>I have some Github Notifications you might be interested to have a look at.  These notifications are from #{timeline} - #{timetext}."
        while(1)
          begin
            texthtml["\n"]="<br>"
          rescue
            break
          end
        end
        if (texthtml=="")
          texthtml="<br> You have no new updates.<br>"
        end
        mailtext+="<br><br>"+texthtml+"<br><br>"
        mailtext+="<br><br>Have an awesome day!<br><br>Yours sincerely,<br><br>GitHub Notifier (<a href=\"https://github.com/athityakumar/ruby-notificator/\">View source code on GitHub</a>)."
        myfile.write(mailtext)
        myfile.close
        system("sudo sendmail -f #{userdetails[3]} #{userdetails[3]} < social-media/github/data/mail.txt")
        puts "Mail sent."
      end
    end
  puts "\nThanx!"
  myfile=File.new("social-media/github/data/time.txt","w")
  myfile.write(timetext)
  myfile.close
end