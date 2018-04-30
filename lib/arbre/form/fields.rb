require 'arbre/form/fields/validation'

module Arbre::Form
  module Field
    attr_accessor :errors, :successes

    def build(
      content = nil,
      *args,
      label: nil,
      **attributes
    )
      super content, *args, attributes

      if label
        within(parent) do
          node = label(label)
          node.set_attribute(:for, self.id)
        end
      end
    end
  end

  [Arbre::HTML::Textarea, Arbre::HTML::Select, Arbre::HTML::Input].each do |tag|
    tag.class_eval { include(Arbre::Form::Field) }
  end
end