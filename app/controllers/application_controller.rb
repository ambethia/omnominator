class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery

  # GET /
  def index
  end

  # POST /
  def create_omnom
    
    omnom = Omnom.new

    # JQuery is encoding this as a single escaped list, so we break it down...
    pplz = CGI.parse(params[:pplz])

    omnom.creator_email = pplz["owner_email"].first

    pplz["ppl_emailz[]"].each do |ppl|
      next if ppl.empty?
      omnom.pplz.build(:email => ppl)
    end

    # omnom_params[:noms].each do |nom|
    #   omnom.noms.build(nom)
    # end

    if omnom.save
      render :status => 200,
             :json => { :redirect_to => '/vote/1' } # + omnom.verification_code
    else
      render :status => 500,
             :json   => omnom.errors.to_json
    end
  rescue Exception => e
    render :status => 500,
           :json => [["unknown", e.inspect]].to_json
  end

  def vote
    render :text => "woo"
  end

end
