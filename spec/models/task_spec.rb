require "rails_helper"

RSpec.describe Task, type: :model do
  describe "associations" do
    describe "belongs to Stack" do
      let(:stack) { create(:stack) }
      subject { build(:task) }

      it "doesn't create Task without Stack" do
        subject.stack = nil
        expect(subject).to_not be_valid
      end

      it "expects Task to have Stack" do
        subject.stack = stack
        subject.save

        expect(subject.stack).to eq(stack)
      end
    end
  end

  describe "validations" do
    describe "description" do
      subject { build(:task)}

      it "expects Task to be invalid without title" do
        subject.description = ""
        expect(subject).to_not be_valid
      end

      it "expects error message when description blank" do
        subject.description = ""
        subject.valid?
        expect(subject.errors.full_messages).to include("Description can't be blank")
      end
    end
  end

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
