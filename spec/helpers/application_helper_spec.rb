require "rails_helper"

RSpec.describe ApplicationHelper, type: :helper do
  describe "#routes_namespacing" do
    it "returns arr which include only actual model" do
      task = Task.new
      expect(helper.routes_namespacing(:stack, task)).to eq([task])
    end
  end
end
