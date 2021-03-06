require 'spec_helper'

module Codebreaker
  describe Game do
    let(:output) { mock('output').as_null_object }
    let(:input) { mock("input").as_null_object }
    let(:game) { Game.new(2, output, input) }
    before(:all) { File.delete("gamestat.txt") if File.exist?("gamestat.txt") }
    after(:all) { File.delete("gamestat.txt") }

    describe "#init" do
      it "sends welcome message" do
        output.should_receive(:puts).with('Welcome to Codebreaker!')
        game.init
      end

      it "prompts the first guess" do
        output.should_receive(:puts).with('Enter first guess:')
        game.init
      end
    end

    describe "#guess" do
      before(:each) do
        game.init
        game.instance_variable_set(:@secret_code, "1234")
        input.stub(:gets).and_return("vasya", "yes")
      end

      shared_examples "Game Over" do
        it "sends number of attempts when codebreaker wins" do
          output.should_receive(:puts).with("Attempts: 2")
        end

        it "sends secret code after end of the game" do
          output.should_receive(:puts).with("Secret code was 1234")
        end

        it "sends 'Play again?' after game is over" do
          output.should_receive(:puts).with("Play again?")
        end

        it "start game if codebreaker answer was yes" do
          output.should_receive(:puts).with('Welcome to Codebreaker!')
        end

        it "sends 'Enter your name: ' when game is over" do
          output.should_receive(:print).with("Enter your name: ")
        end

        it "sends statistic when codebreaker enter his name" do
          file = mock("file")
          File.should_receive(:open).with("gamestat.txt", "a+").and_yield(file)
          file.should_receive(:puts).with("vasya - 2 attempts (code: 1234)")
          IO.should_receive(:read).with("gamestat.txt")
        end
      end


      context "In progress" do
        context "Invalid data" do
          before(:each) { output.should_receive(:puts).with("Wrong input data") }

          context "sends warning message when string" do
            it "is too short" do
              game.guess("123")
            end

            it "is too long" do
              game.guess("12345")
            end

            it "includes wrong chars" do
              game.guess(" a93")
            end
          end

          it "doesnt count wrong input as guess" do
            game.guess("12345")
            game.guess(" a93")
          end
        end

        it "sends '+' if number is exactly guessed" do
          output.should_receive(:print).with("+").once
          game.guess("1111")
        end

        it "sends '-' if number is guessed but in different position" do
          output.should_receive(:print).with("-").once
          game.guess("1334")
        end

        it "sends nothing if secret code does not include that number" do
          output.should_not_receive(:print)
          game.guess("5656")
        end

        it "sends '+-+' if 2 numbers exactly guessed and 1 include in secret code" do
          output.should_receive(:print).with("+").twice
          output.should_receive(:print).with("-").once
          game.guess("1644")
        end

        it "sends 'Enter next guess: ' after codebreakers input" do
          output.should_receive(:puts).with("Enter next guess: ").once
          game.guess("1644")
        end
      end

      context "Win" do
        after(:each) do
          begin
            game.guess("1321")
            game.guess("1234")
          rescue SystemExit
            # its ok
          end
        end

        it "sends congratulations when codebreaker break the code" do
          output.should_receive(:puts).with("Congratulations Codebreaker!")
        end

        it_behaves_like "Game Over"

        it "exit if codebreaker's answer was no" do 
          input.stub(:gets).and_return("vasya", "no")
          lambda {
            game.guess("1321")
            game.guess("1234")
          }.should raise_error(SystemExit)
        end
      end

      context "Lose" do
        after(:each) { 2.times { game.guess("1321") } }
        it "sends game over when number of attemps is more than limit" do
          output.should_receive(:puts).with("Game Over")
        end

        it_behaves_like "Game Over"

        it "exit if codebreaker's answer was no" do 
          input.stub(:gets).and_return("no")
          lambda {
            game.guess("1321")
            game.guess("1321")
          }.should raise_error(SystemExit)
        end
      end
    end

    describe "#hint" do
      before(:each) { game.instance_variable_set(:@secret_code, "1234") }
      it "should return number included in string" do
        num = game.hint
        "1234".should include(num)
      end
    end
  end
end