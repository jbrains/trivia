require 'spec_helper'
require 'ugly_trivia/game_runner'

module UglyTrivia
  class FakeFileInput
    def initialize
      reference_path = File.join(File.dirname(__FILE__), '..', '..', 'reference', 'randomSeq.txt')
      lines = File.readlines(reference_path)

      @responses = parse_line(lines[1])
      @dice_rolls = parse_line(lines[4])
    end

    def die
      @dice_rolls.shift
    end

    def response_correct?
      @responses.shift != 7
    end

    private

    def parse_line(line)
      line.strip.split(',').map(&:to_i).reject(&:zero?)
    end
  end


  class FakeOutput
    def initialize
      @messages = []
    end

    def write(message)
      @messages << message
    end

    def actual_messages
      @messages.join("\n")
    end

    def self.expected_messages
      reference_path = File.join(File.dirname(__FILE__), '..', '..', 'reference', 'result.txt')
      File.read(reference_path).strip
    end
  end


  describe GameRunner do
    it 'should reproduce reference output' do
      fake_output = FakeOutput.new
      
      GameRunner.new(
        FakeFileInput.new,
        fake_output
      ).run
      
      expect(fake_output.actual_messages).to eq(FakeOutput.expected_messages)
    end
  end
end