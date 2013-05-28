require "codebreaker/version"

module Codebreaker
  class Game
    def initialize(limit, output = $stdout, input = $stdin)
      @output, @input = output, input
      @limit = limit
    end

    def start
      @attempts = 0
      @secret_code = make_secret_code
      @output.puts("Welcome to Codebreaker!")
      @output.puts("Enter first guess:")
    end  

    def guess(number)
      @attempts += 1
      return finish(true) if @secret_code == number
      return finish(false) if @attempts == @limit

      match_array = @secret_code.chars.zip(number.chars)
      match_array.take(number.length).each do |origin, guessed|
        if origin == guessed
          @output.print("+")
        elsif @secret_code.include?(guessed)
          @output.print("-")
        end
      end
    end

    private
    def make_secret_code(n = 4)
      str = ""
      n.times { str << rand(1..6).to_s }
      str
    end

    def finish(win)
      @output.puts(win ? "Congratulations Codebreaker!" : "Game Over")
      @output.puts("Attempts: #{@attempts}")
      @output.puts("Secret code was #{@secret_code}")

      @output.puts("Play again?")
      if (@input.gets == "yes") 
        @attempts = 0
        self.start
      else
        exit
      end
    end
  end
end
