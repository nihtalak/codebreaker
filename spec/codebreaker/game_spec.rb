require 'spec_helper'

module Codebreaker
  describe Game do
    let (:output) { mock('output').as_null_object }
    let (:game) { Game.new(2, output) }

    describe "#start" do
      it "sends welcome message" do
        output.should_receive(:puts).with('Welcome to Codebreaker!')
        game.start
      end

      it "prompts the first guess" do
        output.should_receive(:puts).with('Welcome to Codebreaker!')
        game.start
      end
    end

    describe "#guess" do
      let (:input) { mock("input").as_null_object }
      let (:game) { Game.new(2, output, input) }

      before(:each) do
        game.start
        game.instance_variable_set(:@secret_code, "1234")
        input.stub(:gets).and_return("yes")
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
          input.stub(:gets).and_return("yes")
          output.should_receive(:puts).with('Welcome to Codebreaker!')
        end
      end


      context "In progress" do
        it "sends '+' if number is exactly guessed" do
          output.should_receive(:print).with("+").once
          game.guess("1")
        end

        it "sends '-' if number is guessed but in different position" do
          output.should_receive(:print).with("-").once
          game.guess("3")
        end

        it "sends nothing if secret code does not include that number" do
          output.should_not_receive(:print)
          game.guess("5")
        end

        it "sends '+-+' if 2 numbers exactly guessed and 1 include in secret code" do
          output.should_receive(:print).with("+").twice
          output.should_receive(:print).with("-").once
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
          input.stub(:gets).and_return("no")
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
  end
end