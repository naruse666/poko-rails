# frozen_string_literal: true

module PokoRails
  module Inflector
    module_function

    def controller_path(klass_or_name)
      name = klass_or_name.is_a?(Class) ? klass_or_name.name : klass_or_name.to_s
      # "Admin::UsersController" -> "admin/users_controller"
      underscored = underscore(name)
      underscored.sub(/_controller\z/, '')
    end

    def controller_name(klass_or_name)
      controller_path(klass_or_name).split('/').last
    end

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

    def irregulars
      @irregulars ||= {
        'person' => 'people',
        'child' => 'children'
      }
    end

    def pluralize(word)
      w = word.to_s
      return irregulars[w] if irregulars.key?(w)

      inv = irregulars.invert
      return inv[w] if inv.key?(w) # 複数形が渡された時の逆引き

      return w if w.end_with?('s') # 最小実装 すでに複数ぽいならそのまま
      return w.sub(/y\z/, 'ies') if w.match?(/[^aeiou]y\z/)

      "#{w}s"
    end

    def singularize(word)
      w = word.to_s
      inv = irregulars.invert
      return inv[w] if inv.key?(w)
      return irregulars.key(w) if irregulars.value?(w)

      return w.sub(/ies\z/, 'y') if w.end_with?('ies')
      return w.sub(/s\z/, '') if w.end_with?('s') && w.size > 1

      w
    end
  end
end
