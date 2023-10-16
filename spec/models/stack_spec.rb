require "rails_helper"

RSpec.describe Stack, type: :model do
  describe "associations" do
    describe "has many Tasks" do
      let(:stack) { create(:stack) }
      let(:task_attrs) { { description: "Fira" } }

      it "creates task on stack object" do
        expect {
          stack.tasks.create(task_attrs)
        }.to change { Task.count }.by(1)
        expect(Task.last.stack).to eq(stack)
      end

      it "expect to destroy all associated Tasks on Stack destroy" do
        task = create(:task, stack: stack)

        expect {
          stack.destroy
        }.to change { Task.count }.by(-1)
        expect { task.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end

      describe "counter cache" do
        it "increments value on adding tasks to Stack" do
          expect {
            stack.tasks.create(task_attrs)
          }.to change { stack.tasks.size }.by(1)
        end

        it "decrements value on removing tasks from Stack" do
          task = create(:task, stack: stack)

          expect {
            task.destroy
          }.to change { stack.tasks.size }.by(-1)
        end
      end
    end

    describe "belonging to user" do
      subject { build(:stack) }

      it "creates stack with user" do
        user = create(:user)

        subject.user = user
        subject.save

        expect(subject.user).to eq(user)
      end

      it "expects user to be present" do
        subject.user = nil

        expect(subject).to be_invalid
        subject.valid?
        expect(subject.errors.full_messages).to include("User must exist")
      end
    end
  end

  describe "validations" do
    describe "title" do
      subject { build(:stack)}

      it "expects Stack to be invalid without title" do
        subject.title = ""
        expect(subject).to_not be_valid
      end

      it "expects error message when title blank" do
        subject.title = ""
        subject.valid?
        expect(subject.errors.full_messages).to include("Title can't be blank")
      end
    end
  end
end
