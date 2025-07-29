module UglyTrivia
  class RandomInput
    def die
      rand(6) + 1
    end

    def response_correct?
      rand(10) != 7
    end
  end
end