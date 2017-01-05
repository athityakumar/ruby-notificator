require 'json'
require 'io/console'
require 'fileutils'
def github_login(a)
  system("clear")
  proxy_str=""
  puts "\nGithub Notifier\n"
  while (1)
  flagv=0
  begin
    FileUtils.rm("social-media/github/data/auth.json")
  rescue
  end
    begin
            credentials=[]; count=0
            File.open('secrets/github.txt', 'r') do |f1|  
            while line = f1.gets
              credentials[count]=line
              count+=1
            end
          end
          flagv=1
    rescue
          credentials=[]
          print "Enter username: "
          credentials[0]=gets
          print "Enter password: "
          credentials[1]=STDIN.noecho(&:gets)      
    end
    a[0]=credentials[0][0,(credentials[0].length)-1]
    a[1]=credentials[1][0,(credentials[1].length)-1]
    puts "\nAuthenticating..."
    system ("curl -s "+proxy_str+" -u \""+a[0]+":"+a[1]+"\" https://api.github.com/user -o social-media/github/data/auth.json")
    begin
      json = File.read('social-media/github/data/auth.json')
      auth = JSON.parse(json)
    rescue
        system("clear")
        puts "Unable to connect. Please check your internet connection and try again.\nWould you like to add IIT-KGP proxy?"
        choicest=gets
        if (choicest[0]=="y" || choicest[0]=="Y")
          proxy_str="--proxy 10.3.100.207:8080"
        end
        next
    end
      if (auth['message']=="Bad credentials")
            begin
              FileUtils.rm("secrets/github.txt")
            rescue
            end
            system("clear")
            puts "Authentication failure. Please try again."
            next
      else
        a[2]=auth["name"]
        a[3]=auth["email"]
        puts "Authentication successful.\nSigned in, as #{a[2]}."
        break
    end
    break
  end

  if (flagv==0)
    print "\nWould you like to save username and password?"
    choice=gets
    if (choice[0]=="y"|| choice[0]=="Y")
      count=0
      FileUtils::mkdir_p 'secrets'
      File.open('secrets/github.txt', 'w') do |f|  
        while count<=1
          f.puts(credentials[count])
          count+=1
        end
      end
    end
  end
  return proxy_str
end