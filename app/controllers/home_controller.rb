# frozen_string_literal: true

class HomeController < PokoRails::Controller
  def index
    render plain: "home\n"
  end
end
