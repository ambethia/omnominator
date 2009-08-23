class ApplicationController < ActionController::Base
  helper :all

  # GET /
  def index
  end

  # POST /
  def create_omnom
    omnom = Omnom.new(params[:omnom])

    if omnom.save
      render :status => 200,
             :json => { :redirect_to => '/check_your_mail' } # + omnom.verification_code
    else
      render :status => 500,
             :json   => omnom.errors.to_json
    end
  rescue Exception => e
    logger.error(e)

    render :status => 500,
           :json => [["unknown", e.inspect]].to_json
  end

  def vote
    @ppl   = Ppl.find_by_verification_code(params[:verification_code])
    @omnom = @ppl.omnom

    # no-op for anyone but the creator, <3 Gavin.
    @ppl.verify!

    unless @ppl.voted_nom
      render :vote
    else
      render :results
    end
  end

  def check_your_mail
  end

end
