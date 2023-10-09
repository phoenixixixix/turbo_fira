require "rails_helper"

RSpec.describe "/tasks", type: :request do
  let(:invalid_attributes) { { description: "" } }

  before { log_in(create(:user)) }

  describe "GET /index" do
    it "renders a successful response" do
      task = create(:task)
      get stack_tasks_path(task.stack_id)
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      task = create(:task)
      get edit_task_url(task)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    let(:stack) { create(:stack) }

    context "with valid parameters" do
      let(:valid_attributes) { { description: "new task" } }

      it "creates a new Task" do
        expect {
          post stack_tasks_path(stack), params: { task: valid_attributes }
        }.to change(Task, :count).by(1)
      end

      it "redirects to the created task" do
        post stack_tasks_path(stack), params: { task: valid_attributes }
        expect(response).to redirect_to(stack_tasks_path(stack))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Task" do
        expect {
          post stack_tasks_path(stack), params: { task: invalid_attributes }
        }.to change(Task, :count).by(0)
      end
    
      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post stack_tasks_path(stack), params: { task: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) { { description: "updated desc" } }

      it "updates the requested task" do
        task = create(:task)
        patch task_path(task), params: { task: new_attributes }
        task.reload
        expect(task.description).to eq(new_attributes[:description])
      end

      it "redirects to the task" do
        task = create(:task)
        patch task_path(task), params: { task: new_attributes }
        task.reload
        expect(response).to redirect_to(stack_tasks_path(task.stack_id))
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        task = create(:task)
        patch task_path(task), params: { task: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested task" do
      task = create(:task)
      expect {
        delete task_path(task)
      }.to change(Task, :count).by(-1)
    end

    it "redirects to the tasks list" do
      task = create(:task)
      delete task_path(task)
      expect(response).to redirect_to(stack_tasks_path(task.stack_id))
    end
  end
end
