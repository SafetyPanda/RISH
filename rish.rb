#!/usr/bin/env ruby #THIS WILL BE REMOVED

# RISH: Ruby Interactive Shell: Unix Shell written in Ruby
# Copyright (c) James Gillman [jronaldgillman@gmail.com], gitlab: @safetypanda
# Released under the GNU General Public License version 3+
# Refer to LICENSE file for license information.

require 'shellwords' #splits words for me cause I'm lazy
require 'readline' #needed for tab completion
require './customization.rb' #colors
require 'socket' #interact with sockets, get hostname

Readline.completion_proc = proc do |input|
    TAB_COMPLETE.select { |name| name.start_with?(input) }
end


##
# Pipes
##
def split_on_pipes(input)
    input.scan( /([^"'|]+)|["']([^"']+)["']/ ).flatten.compact
end

##
# spawn_program
##
def spawn_program(program, *args, child_out, child_in)
    fork{
        unless child_out == $stdout
            $stdout.reopen(child_out)
            child_out.close
        end

        unless child_in == $stdout
            $stdin.reopen(child_in)
            child_in.close
        end
        exec program, *args
    }
end

##
# Main Shell Code
## 
def rish
    host = Socket.gethostname
    loop do
        $stdout.print(ENV['USER'].bold, "@".bold, host.bold)
        input = Readline.readline("~>".bold, false)

        commands = split_on_pipes(input)
        
        child_in = $stdin
        child_out = $stdout
        pipe = []

        commands.each_with_index do |command, index|
            program, *args = Shellwords.shellsplit(command)

            if COMMANDS[program]
                COMMANDS[program].call(*args)
            else
                if index+1 < commands.size
                    pipe = IO.pipe
                    child_out = pipe.last
                else
                    child_out = $stdout
                end
                spawn_program(program, *args, child_out, child_in)

                child_out.close unless child_out == $stdout
                child_in.close unless child_in == $stdin
                child_in = pipe.first
            end
        end

        Process.waitall            
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
    puts("RISH: Ruby Interactive Shell Version 0.2")
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
    'echo' => lambda { |*words| printf("%s",*words)
        puts()
    },
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
TAB_COMPLETE = [
    'cd',
    'exit',
    'exec',
    'export',
    'echo'
].freeze

firstLoad()
rish()