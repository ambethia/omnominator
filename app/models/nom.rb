class Nom < ActiveRecord::Base
  belongs_to :omnom
  before_save :sanitize_details

  ALLOWED_HTML_TAGS_IN_DETAILS = %w(p br a)

  validates_presence_of :name

  private
    # Please, no crazy HTML allowed inside our details field.
    def sanitize_details
      self.details = ActionController::Base.helpers.sanitize(details, { :attributes => ALLOWED_HTML_TAGS_IN_DETAILS } )
    end
end
