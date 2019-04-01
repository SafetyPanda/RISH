#!/usr/bin/env ruby #THIS WILL BE REMOVED

# RISH: Ruby Interactive Shell: Unix Shell written in Ruby
# Copyright (c) James Gillman [jronaldgillman@gmail.com], gitlab: @safetypanda
# Released under the GNU General Public License version 3+
# Refer to LICENSE file for license information.

require 'shellwords' #splits words for me cause I'm lazy
require 'readline' #needed for tab completion

Readline.completion_proc = proc do |input|
    TABCOMPLETE.select { |name| name.start_with?(input) }
end

##
# Colorization, without colorization
##
class String
    def black;          "\e[30m#{self}\e[0m" end
    def red;            "\e[31m#{self}\e[0m" end
    def green;          "\e[32m#{self}\e[0m" end
    def brown;          "\e[33m#{self}\e[0m" end
    def blue;           "\e[34m#{self}\e[0m" end
    def magenta;        "\e[35m#{self}\e[0m" end
    def cyan;           "\e[36m#{self}\e[0m" end
    def gray;           "\e[37m#{self}\e[0m" end
    
    def bgBlack;       "\e[40m#{self}\e[0m" end
    def bgRed;         "\e[41m#{self}\e[0m" end
    def bgGreen;       "\e[42m#{self}\e[0m" end
    def bgBrown;       "\e[43m#{self}\e[0m" end
    def bgBlue;        "\e[44m#{self}\e[0m" end
    def bgMagenta;     "\e[45m#{self}\e[0m" end
    def bgCyan;        "\e[46m#{self}\e[0m" end
    def bgGray;        "\e[47m#{self}\e[0m" end
    
    def bold;           "\e[1m#{self}\e[22m" end
    def italic;         "\e[3m#{self}\e[23m" end
    def underline;      "\e[4m#{self}\e[24m" end
    def blink;          "\e[5m#{self}\e[25m" end
    def reverseColor;  "\e[7m#{self}\e[27m" end
end


##
# Main Shell Code
##
def rish
    loop do
        $stdout.print (ENV['USER']).green
        input = Readline.readline(" =>".green, false)

        command, *args = Shellwords.shellsplit(input)  
        
        if COMMANDS[command]
            COMMANDS[command].call(*args)
        else
            pid = fork{
                exec command, *args
            }
            Process.wait pid
        end
    end
end

##
# Work In Progress, Will have to write the AUX args into this.
##
def ps
    pids = Dir.glob("/proc/[0-9]*")
    puts "PID\tCMD"
    puts "-" * 15
    pids.each do |pid|
        cmd = File.read(pid + "/comm")
        pid = pid.scan(/\d+/).first
        puts "#{pid}\t#{cmd}"
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
    'cd' => lambda { |directory| Dir.chdir(directory)},
    'exit' => lambda { |code = 0| exit(code.to_i)}, 
    'exec' => lambda { |*command| exec *command},
    'echo' => lambda { |*words| puts(*words)},
    'kill' => lambda { |*program| Process.kill(*program, pid)},
    'ps' => lambda { ps() },
 


    'export' => lambda { |args| #just like bash export
    key, path = args.split('=')
    ENV[key] = path
    }
}

##
# List of built in commands
##
TABCOMPLETE = [
    'cd',
    'exit',
    'exec',
    'export',
    'echo'
].freeze

firstLoad()
rish()