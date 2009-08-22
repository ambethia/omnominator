class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery

  # GET /
  def index
  end

  # POST /
  def create_omnom
    omnom_params = params[:omnom]

    omnom = Omnom.new
    omnom.creator_email = omnom_params[:owner_email]

    omnom_params[:pplz].each do |ppl|
      omnom.pplz.build(:email => ppl)
    end

    omnom_params[:noms].each do |nom|
      omnom.noms.build(nom)
    end
    
    if omnom.save
      redirect_to '/vote/' + omnom.verification_code
    else
      render :status => 500,
             :json => omnom.errors.to_json
    end
  end
end
