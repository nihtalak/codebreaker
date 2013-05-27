require 'spec_helper'

module Codebreaker
  describe Game do
    describe "#start" do
      let (:output) { mock('output').as_null_object }
      let (:game) { Game.new(output) }

      it "sends welcome message" do
        output.should_receive(:puts).with('Welcome to Codebreaker!')
        game.start
      end

      it "prompts the first guess" do
        output.should_receive(:puts).with('Welcome to Codebreaker!')
        game.start
      end
    end
  end
end