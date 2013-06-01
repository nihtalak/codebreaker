module Codebreaker
  class Game
    def initialize(limit, output = $stdout, input = $stdin)
      @output, @input = output, input
      @limit = limit
    end

    def start
      init
      loop do 
        case a = @input.gets.chomp
        when "hint" then @output.puts(hint)
        else guess(a)
        end 
      end
    end

    def init
      @attempts = 0
      @secret_code = make_secret_code
      @output.puts("Welcome to Codebreaker!")
      @output.puts("Enter first guess:")
    end  

    def guess(number)
      return @output.puts("Wrong input data") unless valid?(number)
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
      @output.puts
      @output.puts("Enter next guess: ")
    end

    def hint
      @secret_code[rand(0..3)]
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

      @output.print("Enter your name: ")
      save_to_file(@input.gets.chomp)
      @output.puts("\n" + get_statistics)

      @output.puts("Play again?")
      @input.gets.chomp == "yes" ? self.init : exit
    end

    def save_to_file(name)
      File.open("gamestat.txt", "a+") do |f|
        f.puts("#{name} - #{@attempts} attempts (code: #{@secret_code})")
      end
    end

    def get_statistics
      IO.read("gamestat.txt") || "No games yet"
    end

    def valid?(code)
      code.match /^[1-6]{4}$/
    end
  end
end