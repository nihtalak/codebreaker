require "codebreaker/version"

module Codebreaker
  class Game
    def initialize(output = $stdout)
      @output = output   
      @secret_code = make_secret_code
      @attempts = 0
    end

    def start
      @output.puts("Welcome to Codebreaker!")
      @output.puts("Enter first guess:")
    end  

    def guess(number)
      @attempts += 1
      return finish if @secret_code == number

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

    def finish
      @output.puts("Congratulations Codebreaker!")
      @output.puts("Attempts: #{@attempts}")
      @output.puts("Secret code was #{@secret_code}")
    end
  end
end
