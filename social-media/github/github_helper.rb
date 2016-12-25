require 'json'
require 'octokit'
require 'io/console'

def github_login()
  begin
        credentials=[]; count=0
        File.open('secrets/github.txt', 'r') do |f1|  
        while line = f1.gets
        credentials[count]=line
        count+=1
        end
        end
  rescue
        credentials=[]
        print "Enter username: "
        credentials[0]=gets
        print "Enter password: "
        credentials[1]=STDIN.noecho(&:gets)
        print "\n\nWould you like to save username and password?"
        choice=gets
        if (choice[0]=="y"|| choice[0]=="Y")
        count=0
        require 'fileutils'
        FileUtils::mkdir_p 'secrets'
        File.open('secrets/github.txt', 'w') do |f|  
        while count<=1
          f.puts(credentials[count])
          count+=1
        end
        end
        end
  end
  Octokit.configure do |c|
    c.login = credentials[0][0,(credentials[0].length)-1]
    c.password = credentials[1][0,(credentials[1].length)-1]
  end

  return Octokit

end

