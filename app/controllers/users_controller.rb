# frozen_string_literal: true

class UsersController < PokoRails::Controller
  def show
    render plain: "users#show\n"
  end
end
