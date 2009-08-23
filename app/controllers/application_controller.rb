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
  
  # Ppl#verify! is a no-op for anyone but the creator, <3 Gavin.
  def vote
    @ppl = Ppl.find_by_verification_code(params[:verification_code])
    unless @ppl
      flash[:script] = "$.flash.warn('Nanny-nanny boo-boo pants on fire', 'No cheating.')"
      redirect_to "/" and return
    end
    @ppl.verify!
    flash[:script] = nil

    page = @ppl.voted_nom ? :results : :vote

    render page
  end

  def chad
    @ppl = Ppl.find_by_verification_code(params[:verification_code])
    @nom = @ppl.omnom.noms.find(params[:nom_id])
    @ppl.update_attribute :voted_nom, @nom
    flash[:script] = nil
    redirect_to vote_path(@ppl.verification_code)
  rescue
    flash[:script] = "$.flash.error('FAIL', 'Where ya gonna nom?')"
    render :vote
  end

  def check_your_mail
  end
end
