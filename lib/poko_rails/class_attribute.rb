# frozen_string_literal: true

module PokoRails
  module ClassAttribute
    module_function

    def define(klass, *names, default: nil)
      names.each do |name|
        ivar = :"@#{name}"

        # class reader
        klass.define_singleton_method(name) do
          if instance_variable_defined?(ivar)
            instance_variable_get(ivar)
          elsif superclass.respond_to?(name)
            superclass.public_send(name)
          else
            default
          end
        end

        # class writer
        klass.define_singleton_method("#{name}=") do |val|
          instance_variable_set(ivar, val)
        end

        # instance reader (minimum)
        klass.define_method(name) do
          self.class.public_send(name)
        end
      end
    end
  end
end
