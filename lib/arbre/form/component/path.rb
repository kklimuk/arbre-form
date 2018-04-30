class Arbre::Form::Component < Arbre::Form::Base
  class Path
    Member = Struct.new(:record, :name, :index)

    def initialize(errors: [], successes: [], &block)
      @members = []
      @errors = errors
      @successes = successes
      instance_exec(&block)
    end

    def push(member, name, index = nil)
      @members << Member.new(member, name, index)
    end

    def pop
      @members.pop
    end

    def peek
      @members.last
    end

    def name(*attributes)
      name_components = []
      (components + attributes.compact).each_with_index do |(name, member_index), index|
        next name_components << name if index == 0
        name_components << "[#{name}]"
        name_components << '[]' if member_index
      end
      name_components.join('')
    end

    def id(*attributes)
      (components + attributes.compact).join('_')
    end

    def components
      @members.map do |member|
        if member.index
          [member.name, member.index]
        else
          [member.name]
        end
      end
    end

    def errors
      current_validations(@errors)
    end

    def successes
      current_validations(@successes)
    end

    private

    def current_validations(validations)
      current_validations = validations
      @members.each_with_index do |member, index|
        next if index == 0
        current_validations = current_validations.fetch(member.name, member.index ? [] : {})
        current_validations = current_validations[member.index] || {} if member.index
      end
      current_validations
    end
  end
end