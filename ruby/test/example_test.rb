require 'test_helper'

# Minispec!
describe "one test" do
  it "should pass" do
    true.must_equal true
  end
end

# Minitest!
class ExampleTest < MiniTest::Unit::TestCase
  def test_an_example
    assert true
  end
end