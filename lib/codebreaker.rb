require "codebreaker/version"

module Codebreaker
  class Game
    def initialize(output = $stdout)
      @output = output   
    end

    def start
      @output.puts("Welcome to Codebreaker!")
      @output.puts("Enter first guess:")
    end  
  end
end
