class Arbre::Form::Component < Arbre::Form::Base
  class Template
    def initialize(chain = [])
      @chain = chain
    end

    def method_missing(method, *_)
      Template.new(@chain + [method])
    end

    def inspect
      chain.inspect
    end

    def to_s
      ''
    end
  end
end