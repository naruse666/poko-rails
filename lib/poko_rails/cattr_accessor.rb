# # frozen_string_literal: true

module PokoRails
  module CattrAccessor
    module_function

    def define(klass, *names, default: nil)
      names.each do |name|
        cvar = :"@@#{name}"

        # 初期値
        klass.class_variable_set(cvar, default) unless klass.class_variable_define?(cvar)

        # class reader
        klass.define_singleton_method(name) do
          klass.class_variable_get(cvar)
        end

        # class writer
        klass.define_singleton_method("#{name}=") do |val|
          klass.class_variable_set(cvar, val)
        end

        # instance reader
        klass.define_method(name) do
          self.class.public_send(name)
        end

        # instance writer
        klass.define_method("#{name}=") do |val|
          self.class.public_send("#{name}=", val)
        end
      end
    end
  end
end
