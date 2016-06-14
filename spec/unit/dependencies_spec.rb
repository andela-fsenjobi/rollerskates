require "spec_helper"
# $LOAD_PATH.unshift File.expand_path("../helpers", __FILE__)

describe "Helpers Methods" do
  context '#const_missing' do
    it { expect("ItemsController".constantize).to eq ItemsController }
  end
end
