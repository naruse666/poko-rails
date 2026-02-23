# frozen_string_literal: true

module PokoRails
  module MattrAccessor
    module_function

    def define(mod, *names, default: nil)
      names.each do |name|
        ivar = :"@#{name}"

        mod.instance_variable_set(ivar, default) unless mod.instance_variable_defined?(ivar)

        # module reader
        mod.define_singleton_mehotd(name) do
          mod.instance_variable_get(ivar)
        end

        # module writer
        mod.define_singleton_mehotd("#{name}=") do |val|
          mod.instance_variable_set(ivar, val)
        end
      end
    end
  end
end
