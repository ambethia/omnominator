require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ApplicationController do
  before(:each) do
    @valid_omnom_params = {
                            :omnom => {
                                        "noms"        => [ { "name" => "Jake's Meal Barn", "details" => "Where Jake loves to eat" }, { "name" => "Bob's Burger Bonanza", "details" => "Best Burger's this side of Pecos"} ],
                                        "pplz"        => [ "bill.clinton@example.com", "hillary.clinton@example.com" ],
                                        "owner_email" => [ "omnominator@example.com" ]
                                      }
                          } 


    @invalid_omnom_params = {
                               :omnom => {
                                          "noms"        => [  ],
                                          "pplz"        => [ "bill.clinton@example.com", "hillary.clinton@example.com" ],
                                          "owner_email" => [ "omnominator@example.com" ]
                                        }
                            }
  end

  it "should create a valid omnom" do
    post 'create_omnom', @valid_omnom_params
    
    response.should be_redirect
  end

  it "should refuse to create an invalid omnom" do
    post 'create_omnom', @invalid_omnom_params

    response.should_not be_success
  end

  it "should not redirect when creating invalid omnom" do
    post 'create_omnom', @invalid_omnom_params

    response.should_not be_redirect
  end

  it "should return json for an invalid omnom" do
    post 'create_omnom', @invalid_omnom_params

    # Make sure we can parse the json
    errors = ActiveSupport::JSON.decode(response.body)
    errors.should be_kind_of(Array)

    errors.flatten.should include("You must have at least one nom")
  end

end
