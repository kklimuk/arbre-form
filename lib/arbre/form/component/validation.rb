module Arbre::Form::Field
  class Validation < Arbre::HTML::Div
    def build(validations, class_name:, **attributes)
      content = validations.join("\n")
      add_class class_name if class_name
      super content, attributes
    end

    def tag_name
      'div'
    end
  end
end