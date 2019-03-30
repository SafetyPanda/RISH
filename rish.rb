#!/usr/bin/env ruby #THIS WILL BE REMOVED

# RISH: Ruby Interactive Shell: Unix Shell written in Ruby
# Copyright (c) James Gillman [jronaldgillman@gmail.com], gitlab: @safetypanda
# Released under the GNU General Public License version 3+
# Refer to LICENSE file for license information.

require 'shellwords' #splits words for me cause I'm lazy



##
# Main Shell Code
##
def rish
    loop do
        $stdout.print ENV['USER'],' ', ENV['PROMPT'] 
        line = $stdin.gets.strip 
        command, *args = Shellwords.shellsplit(line)

        if COMMANDS[command]
            COMMANDS[command].call(*args)
        else
            pid = fork{
                exec line
            }
            Process.wait pid
        end
    end
end

##
# Text Before Prompt
##
def firstLoad
    puts("----------------------------------------")
    puts("RISH: Ruby Interactive Shell Version 0.1")
    puts("Created by James Gillman.") 
    puts("Licensed under GPLV3")
    puts("----------------------------------------")
end

##
# Built In Commands. Not ones stored in bin. But ones that can modify the shell
##
COMMANDS = {
    'cd' => lambda { |dir| Dir.chdir(dir)}, #change directory obviously
    'exit' => lambda { |code = 0| exit(code.to_i)}, 
    'exec' => lambda { |*command| exec *command}, #creates it's own process

    'export' => lambda { |args| #just like bash export
    key, path = args.split('=')
    ENV[key] = path
    }
}

ENV['PROMPT'] = '=> '

firstLoad()
rish()