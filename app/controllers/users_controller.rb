# frozen_string_literal: true

class UsersController < PokoRails::Controller
  def show
    render plain: "id=#{params['id']}, q=#{params['q']}\n"
  end
end
