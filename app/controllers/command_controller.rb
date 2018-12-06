class CommandController < ApplicationController
  skip_before_action :verify_authenticity_token

  include Command
end
