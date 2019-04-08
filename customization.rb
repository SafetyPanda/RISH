#!/usr/bin/env ruby #THIS WILL BE REMOVED

##
# Colorization, without colorization
##

class String

    #Change font color
    def black;          "\e[30m#{self}\e[0m" end
    def red;            "\e[31m#{self}\e[0m" end
    def green;          "\e[32m#{self}\e[0m" end
    def brown;          "\e[33m#{self}\e[0m" end
    def blue;           "\e[34m#{self}\e[0m" end
    def magenta;        "\e[35m#{self}\e[0m" end
    def cyan;           "\e[36m#{self}\e[0m" end
    def gray;           "\e[37m#{self}\e[0m" end
    
    #Change Background
    def bg_Black;       "\e[40m#{self}\e[0m" end
    def bg_Red;         "\e[41m#{self}\e[0m" end
    def bg_Green;       "\e[42m#{self}\e[0m" end
    def bg_Brown;       "\e[43m#{self}\e[0m" end
    def bg_Blue;        "\e[44m#{self}\e[0m" end
    def bg_Magenta;     "\e[45m#{self}\e[0m" end
    def bg_Cyan;        "\e[46m#{self}\e[0m" end
    def bg_Gray;        "\e[47m#{self}\e[0m" end
    
    # Formatting
    def bold;           "\e[1m#{self}\e[22m" end
    def italic;         "\e[3m#{self}\e[23m" end
    def underline;      "\e[4m#{self}\e[24m" end
    def reversecolor;  "\e[7m#{self}\e[27m" end
end

def set_config()
    File.readlines('rish.conf').each do |line|
        if !line.include? '#'
            puts(line)
        end
    end
end