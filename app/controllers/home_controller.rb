class HomeController < ApplicationController
  SAMPLE_JSON = {
    :principals => [
      {
        "id" => 3,
        "name" => "Name 1",
        "supplier_guid" => "id1"
      },
      {
        "id" => 4,
        "name" => "Name 2",
        "supplier_guid" => "id2"
      },
      {
        "id" => 14,
        "name" => "Name 3",
        "supplier_guid" => "id3"
      }
    ]
  }

  def index
    respond_to do |format|
      format.html do
        @objects = RestApi.principals
      end

      # only test purpose
      format.json do
        render :json => SAMPLE_JSON
      end
    end
  end
end
