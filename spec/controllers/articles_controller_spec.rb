require 'rails_helper'

RSpec.describe ArticlesController, :type => :controller do

  describe "GET list" do
    it "returns http success" do
      get :list
      expect(response).to be_success
    end
  end

  describe "GET item" do
    it "returns http success" do
      get :item
      expect(response).to be_success
    end
  end

end
