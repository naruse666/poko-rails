# frozen_string_literal: true

class UsersController < PokoRails::Controller
  def show
    p = []
    p << "id=#{params['id']}" if params.has_key? 'id'
    p << "q=#{params['q']}" if params.has_key? 'q'

    res = p.join(', ')
    puts res
    render plain: "#{res}\n"
  end
end
