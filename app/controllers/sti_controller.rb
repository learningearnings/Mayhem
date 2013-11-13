load 'lib/sti_client.rb'
class StiController < ApplicationController

  def give_credits
    sti_client = STIClient.new
    sti_client.session_token = params["sti_session_variable"]
    render :json => sti_client.session_information.parsed_response
  end
end
