require 'arbre/form/base'
require 'arbre/form/component/path'
require 'arbre/form/component/group'
require 'arbre/form/component/validation'

module Arbre::Form
  class Component < Base
    builder_method :arbre_form

    attr_reader :record, :index, :path

    def build(
      record,
      action = '/',
      errors: record.respond_to?(:errors) ? record.errors : {},
      successes: record.respond_to?(:successes) ? record.successes : {},

      wrappers: Arbre::Form.config.wrappers,
      classes: Arbre::Form.config.classes,
      components: Arbre::Form.config.components,

      **attributes
    )
      @record = record
      class_name = dom_class_name_for(record)
      @path = Path.new(successes: successes, errors: errors) { push(record, class_name) }

      @wrappers = wrappers
      @classes = classes
      @components = components

      attributes[:action] = action
      super attributes
    end

    def field(
      attribute,
      content = nil,

      components: @components,
      as: :input,

      value: nil,
      label: nil,
      wrapper: {},
      field_wrapper: @wrappers.field,

      error_wrapper: @wrappers.error,
      error_class: @classes.error,
      errors_class: @classes.errors,
      success_wrapper: @wrappers.success,
      success_class: @classes.success,
      successes_class: @classes.successes,

      **field_attributes,
      &block
    )
      field_errors = @path.errors.fetch(attribute, [])
      field_successes = @path.successes.fetch(attribute, [])

      config = components[as]
      field_attributes[:type] ||= config.type

      formatter = config.formatter
      value ||= @record.respond_to?(attribute) ? @record.public_send(attribute) : nil
      value = formatter.call(value)

      wrapped = proc do
        if label
          node = label(label)
          node.set_attribute(:for, self.id)
        end

        field = insert_tag(
          config.tag,
          content,
          id: @path.id(attribute),
          name: @path.name(attribute),
          value: value,
          **field_attributes,
          &block
        )

        unless field_errors.empty?
          field.add_class error_class
          errors = insert_tag(error_wrapper, field_errors, class_name: errors_class)
          field.define_singleton_method(:errors) { errors }
        end

        unless field_successes.empty?
          field.add_class success_class
          successes = insert_tag(success_wrapper, field_successes, class_name: successes_class)
          field.define_singleton_method(:successes) { successes }
        end

        field
      end

      insert_tag(field_wrapper, wrapper, &wrapped)
    end

    def field_group(group_name = nil, group_wrapper: @wrappers.group, **attributes, &block)
      wrapper = proc { instance_exec(&block) }
      attributes[:id] ||= @path.id(group_name) if group_name
      attributes[:group_name] = group_name
      insert_tag(group_wrapper, attributes, &wrapper)
    end

    def association(
      association,
      association_wrapper: @wrappers.association,
      record_wrapper: @wrappers.record,
      association_attributes: {},
      **record_attributes,
      &block
    )
      association_attributes[:id] ||= @path.id(association)
      association_attributes[:group_name] = association
      wrapper = insert_tag(association_wrapper, association_attributes)

      loaded_association = record.public_send(association)
      has_many = loaded_association.is_a?(Array)

      collection = Array(loaded_association)
      association_class = @path.id(association)

      wrapped_block = proc { instance_exec(&block) }
      within wrapper do
        collection.each_with_index do |record, index|
          with_record(record, association, has_many ? index : nil) do |id|
            current_attributes = record_attributes.dup
            current_attributes[:id] ||= id

            tag = insert_tag(record_wrapper, current_attributes, &wrapped_block)
            tag.add_class(association_class)
          end
        end
      end
      @index = 0
      wrapper
    end

    def tag_name
      'form'
    end

    private

    def with_record(record, association, index)
      @index = index
      old_record, @record = @record, record
      @path.push(record, association, index)
      yield(@path.id)
      @path.pop
      @record = old_record
    end
  end
end