require "rails_helper"

RSpec.describe Task, type: :model do
  describe "scopes" do
    describe "#ordered" do
      before do
        2.times { create(:task) }
      end

      it "returns task ordered by desc id (higher id to lower)" do
        ordered_tasks = Task.ordered
        expect(ordered_by_desc_id(ordered_tasks)).to be_truthy
      end

      def ordered_by_desc_id(tasks)
        tasks.first.id > tasks.last.id
      end
    end
  end
end
