module Arbre::Form
  def self.config(&block)
    @config = Config.new(&block) if block
    @config ||= Config.new
  end

  class Config
    attr_accessor :wrappers, :classes, :components

    class Component
      attr_accessor :tag, :type, :formatter
      
      def initialize(tag:, type: nil, formatter: proc { |val| val })
        @tag = tag
        @type = type
        @formatter = formatter
      end
    end

    def initialize(&block)
      self.wrappers = OpenStruct.new(
        field: Arbre::HTML::Div,
        group: Arbre::Form::Component::Group,
        association: Arbre::Form::Component::Group,
        record: Arbre::HTML::Fieldset,
        error: Arbre::Form::Field::Validation,
        success: Arbre::Form::Field::Validation,
      )

      self.classes = OpenStruct.new(
        error: 'is-invalid',
        errors: 'invalid-feedback',
        success: 'is-valid',
        successes: 'valid-feedback'
      )

      self.components = OpenStruct.new(
        input: Component.new(
          tag: Arbre::HTML::Input
        ),

        checkbox: Component.new(
          tag: Arbre::HTML::Input,
          type: 'checkbox',
          formatter: proc { |value| value ? '1' : '0' },
        ),

        date: Component.new(tag: Arbre::HTML::Input,
          type: 'date',
          formatter: proc { |date| date.strftime('%Y-%m-%d') if date },
        ),

        datetime: Component.new(
          tag: Arbre::HTML::Input,
          type: 'datetime-local',
          formatter: proc { |time| time.strftime('%Y-%m-%dT%H:%M') if time }
        ),

        email: Component.new(
          tag: Arbre::HTML::Input,
          type: 'email'
        ),

        file: Component.new(
          tag: Arbre::HTML::Input,
          type: 'file'
        ),

        hidden: Component.new(
          tag: Arbre::HTML::Input,
          type: 'hidden'
        ),

        image: Component.new(
          tag: Arbre::HTML::Input,
          type: 'image'
        ),

        month: Component.new(
          tag: Arbre::HTML::Input,
          type: 'month'
        ),

        number: Component.new(
          tag: Arbre::HTML::Input,
          type: 'number'
        ),

        password: Component.new(
          tag: Arbre::HTML::Input,
          type: 'password'
        ),

        radio: Component.new(
          tag: Arbre::HTML::Input,
          type: 'radio'
        ),

        range: Component.new(
          tag: Arbre::HTML::Input,
          type: 'range'
        ),

        search: Component.new(
          tag: Arbre::HTML::Input,
          type: 'search'
        ),

        tel: Component.new(
          tag: Arbre::HTML::Input,
          type: 'tel'
        ),

        text: Component.new(
          tag: Arbre::HTML::Input,
          type: 'text'
        ),

        time: Component.new(
          tag: Arbre::HTML::Input,
          type: 'time'
        ),

        url: Component.new(
          tag: Arbre::HTML::Input,
          type: 'url'
        ),

        week: Component.new(
          tag: Arbre::HTML::Input,
          type: 'week'
        ),

        select: Component.new(
          tag: Arbre::HTML::Select
        ),

        textarea: Component.new(
          tag: Arbre::HTML::Textarea
        )
      )

      instance_exec(&block) if block
    end
  end
end