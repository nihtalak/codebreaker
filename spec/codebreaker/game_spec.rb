require 'spec_helper'

module Codebreaker
  describe Game do
    let (:output) { mock('output').as_null_object }
    let (:game) { Game.new(output) }

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
      before(:each) { game.instance_variable_set(:@secret_code, "1234") }

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
        it "sends congratulations when codebreaker break the code" do
          output.should_receive(:puts).with("Congratulations Codebreaker!")
          game.guess("1234")
        end

        it "sends number of attempts when codebreaker wins" do
          output.should_receive(:puts).with("Attempts: 2")
          game.guess("1423")
          game.guess("1234")
        end

        it "sends secret code after end of the game" do
          output.should_receive(:puts).with("Secret code was 1234")
          game.guess("1234")
        end
      end
    end
  end
end