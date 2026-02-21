# frozen_string_literal: true

module PokoRails
  module Inflector
    module_function

    # "home" -> "Home"
    # "admin/users" -> "Admin::Users"
    def camelize(pathish)
      pathish
        # 'admin/users' -> ['admin', 'users']
        .split('/')
        # 'user_profile' -> ['user', 'profile'] -> ['User', 'Profile'] -> "UserProfile"
        .map { |part| part.split('_').map(&:capitalize).join }
        # ['Admin', 'Users'] -> 'Admin::Users'
        .join('::')
    end

    # 文字列の定数名を実際の定数へ変換する
    # 'Admin::UserController' -> Admin::UserController
    def constantize(name)
      name.split('::').inject(Object) { |mod, const| mod.const_get(const) }
    end

    def safe_constantize(name)
      constantize(name)
    rescue NameError
      nil
    end

    def underscore(camel_cased_word)
      word = camel_cased_word.to_s.dup

      # "Admin::UsersController" -> "Admin/UsersController"
      word.gsub!('::', '/')

      # "UsersController" -> "Users_Controller"
      word.gsub!(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2')

      # "UsersController" -> "Users_Controller" 追加分割: "sC"等
      word.gsub!(/([a-z\d])([A-Z])/, '\1_\2')

      word.tr!('-', '_')
      word.downcase!
      word
    end

    def demodulize(const_name)
      const_name.to_s.split('::').last
    end

    def deconstantize(const_name)
      parts = const_name.to_s.split('::')
      return '' if parts.length <= 1

      parts[0...-1].join('::')
    end
  end
end
