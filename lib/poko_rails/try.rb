# frozen_string_literal: true

class Object
  # try(:method, *args) or try { |obj| ... }
  def try(method_name = nil, *args, &block)
    return yield(self) if block

    return nil if method_name.nil?

    public_send(method_name, *args) if respond_to?(method_name)
  end
end

class NilClass
  def try(*)
    nil
  end
end
