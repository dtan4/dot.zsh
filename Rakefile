ZDOTDIR = File.join(ENV["HOME"], ".zsh")
ZSHENV = File.join(ENV["HOME"], ".zshenv")

task default: "update"

desc "Install .zsh"
task :install => [
  "sudmodule:init",
  "setup"
] do
end

desc "Update .zsh"
task :update => [
  "submodule:update"
] do
end

desc "Setup .zsh"
task :setup do
  ln_s(Dir.pwd, ZDOTDIR) unless Dir.exists? ZDOTDIR
  sh %(echo 'export ZDOTDIR=#{ZDOTDIR}' >> #{ZSHENV}) unless File.exists?(ZSHENV)
end

namespace :submodule do
  desc "Install submodules"
  task :init do
    sh %(git submodule update --init)
  end

  desc "Update submodules"
  task :update do
    Dir["*/"].map { |dir| File.join(ZDOTDIR, dir[0..-1]) }.each do |dir|
      Dir.chdir(dir)
      sh %(git pull origin master)
    end
  end
end
