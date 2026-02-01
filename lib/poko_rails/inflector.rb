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
  end
end
