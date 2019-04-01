#!/usr/bin/env ruby #THIS WILL BE REMOVED

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
