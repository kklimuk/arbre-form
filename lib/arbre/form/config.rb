module Arbre::Form
  def self.config(&block)
    @config = Config.new(&block) if block
    @config ||= Config.new
  end

  class Config
    attr_accessor :wrappers, :classes, :components

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
        success: 'is-valid'
      )

      self.components = {
        input: {
          component: Arbre::HTML::Input
        },

        checkbox: {
          component: Arbre::HTML::Input,
          type: 'checkbox'
        },

        date: {
          component: Arbre::HTML::Input,
          type: 'date',
          formatter: proc { |date| date.strftime('%Y-%m-%d') if date },
        },

        datetime: {
          component: Arbre::HTML::Input,
          type: 'datetime-local',
          formatter: proc { |time| time.strftime('%Y-%m-%dT%H:%M') if time }
        },

        email: {
          component: Arbre::HTML::Input,
          type: 'email'
        },

        file: {
          component: Arbre::HTML::Input,
          type: 'file'
        },

        hidden: {
          component: Arbre::HTML::Input,
          type: 'hidden'
        },

        image: {
          component: Arbre::HTML::Input,
          type: 'image'
        },

        month: {
          component: Arbre::HTML::Input,
          type: 'month'
        },

        number: {
          component: Arbre::HTML::Input,
          type: 'number'
        },

        password: {
          component: Arbre::HTML::Input,
          type: 'password'
        },

        radio: {
          component: Arbre::HTML::Input,
          type: 'radio'
        },

        range: {
          component: Arbre::HTML::Input,
          type: 'range'
        },

        search: {
          component: Arbre::HTML::Input,
          type: 'search'
        },

        tel: {
          component: Arbre::HTML::Input,
          type: 'tel'
        },

        text: {
          component: Arbre::HTML::Input,
          type: 'text'
        },

        time: {
          component: Arbre::HTML::Input,
          type: 'time'
        },

        url: {
          component: Arbre::HTML::Input,
          type: 'url'
        },

        week: {
          component: Arbre::HTML::Input,
          type: 'week'
        },

        select: {
          component: Arbre::HTML::Select
        },

        textarea: {
          component: Arbre::HTML::Textarea
        },
      }

      instance_exec(&block) if block
    end
  end
end