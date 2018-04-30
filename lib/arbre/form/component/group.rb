class Arbre::Form::Component < Arbre::Form::Base
  class Group < Arbre::HTML::Fieldset
    def build(group_name: nil, **attributes)
      super attributes
      legend group_name.to_s.humanize.titleize if group_name
    end

    def tag_name
      'fieldset'
    end
  end
end