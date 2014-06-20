ZDOTDIR = File.join(ENV["HOME"], ".zsh")
ZSHENV = File.join(ENV["HOME"], ".zshenv")

task default: "update"

desc "Install .zsh"
task :install => [
                  :init_submodules,
                  :setup
                 ] do
end

desc "Update .zsh"
task :update => [
                 :update_submodules
                ] do
end

desc "Setup .zsh"
task :setup do
  ln_s(Dir.pwd, ZDOTDIR) unless Dir.exists? ZDOTDIR
  sh %(echo 'export ZDOTDIR=#{ZDOTDIR}' >> #{ZSHENV}) unless File.exists?(ZSHENV)
end

desc "Install submodules"
task :init_submodules do
  sh %(git submodule update --init)
end

desc "Update submodules"
task :update_submodules do
  sh %(git submodule update)
end
