module Arbre::Form
  class Base < Arbre::HTML::Tag
    builder_method :form

    ALLOWED_METHODS = %i(get post patch put delete)
    FORM_METHODS = %i(get post)

    def build(
      content = nil,
      *args,
      action: '/',
      method: :post,
      multipart: false,
      authenticity_token: default_auth_token(action, method),
      token_name: default_token_name,
      **attributes
    )
      raise ArgumentError, "`#{method}` is not a valid HTTP method" unless ALLOWED_METHODS.include?(method)

      set_attribute :action, action
      set_attribute :enctype, 'multipart/form-data' if multipart

      form_method = FORM_METHODS.include?(method) ? method : :post
      set_attribute :method, form_method.to_s.upcase

      super content, *args, attributes

      within(self) { input(type: 'hidden', name: 'utf8', value: '✓') }
      within(self) { input(type: :hidden, name: token_name, value: authenticity_token) } if authenticity_token
      within(self) { input(type: :hidden, name: :'_method', value: method.to_s.upcase) } if method != form_method
    end

    def tag_name
      'form'
    end

    private

    def default_auth_token(action, method)
      form_authenticity_token(form_options: { method: method.to_s, action: action }) if defined?(Rails)
    end

    def default_token_name
      token = defined?(Rails) ? request_forgery_protection_token : 'authenticity_token'
    end
  end
end