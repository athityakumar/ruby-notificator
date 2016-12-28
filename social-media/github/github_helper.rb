require 'json'
require 'io/console'
require 'fileutils'
def github_login(a)
  system("clear")
  puts "\nGithub Notifier\n"
  while (1)
  flagv=0
  begin
    FileUtils.rm("data/github/auth.json")
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
    system ("curl -u \""+a[0]+":"+a[1]+"\" https://api.github.com/user -o data/github/auth.json")
    begin
      json = File.read('data/github/auth.json')
      auth = JSON.parse(json)
    rescue
        system("clear")
        puts "Unable to connect. Please check your internet connection and try again."
        exit
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
end