require 'json'
require 'octokit'

def github_login()
  
  credentials = JSON.parse(File.read("#{Dir.pwd}/secrets/github.json"))
  Octokit.configure do |c|
    c.login = credentials[0]["Username"]
    c.password = credentials[0]["Password"]
  end

  return Octokit

end

