module Arbre::Form::Field
  class Validation < Arbre::HTML::Div
    def build(validations, validation_type:, class_name: default_name(validation_type), **attributes)
      content = validations.join("\n")
      add_class class_name if class_name
      super content, attributes
    end

    def default_name(validation_type)
      if validation_type == :error
        'invalid-feedback'
      elsif validation_type == :success
        'valid-feedback'
      end
    end

    def tag_name
      'div'
    end
  end
end