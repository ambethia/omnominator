class ApplicationController < ActionController::Base
  helper :all
  before_filter :adjust_format_for_iphone

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
      flash[:script] = 'No cheating.'
      redirect_to "/" and return
    end
    @ppl.verify!
    flash[:script] = nil

    page = @ppl.voted_nom ? :results : :vote

    respond_to do |format|
      format.html   { render page }
      format.iphone { render page, :layout => false }
    end
  end

  def chad
    @ppl = Ppl.find_by_verification_code(params[:verification_code])
    @nom = @ppl.omnom.noms.find(params[:nom_id])
    @ppl.update_attribute :voted_nom, @nom
    flash[:script] = nil
    redirect_to vote_path(@ppl.verification_code)
  rescue
    flash[:script] = "$.flash.error('FAIL', 'Where ya gonna nom?')"
    respond_to do |format|
      format.html   { render :vote }
      format.iphone { render :vote, :layout => false }
    end
  end

  def check_your_mail
  end

  private
    def adjust_format_for_iphone
      request.format = :iphone if iphone_request?
    end

    def iphone_request?
      request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"][/(Mobile\/.+Safari)/]
    end
end
