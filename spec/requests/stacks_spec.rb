require "rails_helper"

RSpec.describe "/stacks", type: :request do
  let(:valid_attributes) { { title: "Stack" } }
  let(:invalid_attributes) { { title: "" } }
  let(:logged_in_user) { create(:user) }

  before { log_in(logged_in_user) }

  describe "GET /index" do
    it "renders a successful response" do
      get stacks_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      stack = create(:stack)
      get stack_url(stack)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_stack_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      stack = create(:stack)
      get edit_stack_url(stack)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Stack" do
        expect {
          post stacks_url, params: { stack: valid_attributes }
        }.to change(Stack, :count).by(1)
      end

      it "redirects to the created stack" do
        post stacks_url, params: { stack: valid_attributes }
        expect(response).to redirect_to(stack_url(Stack.last))
      end

      it "belongs to logged in user" do
        post stacks_url, params: { stack: valid_attributes }

        stack_user = Stack.last.user
        expect(stack_user).to eq(logged_in_user)
      end
    end

    context "with invalid parameters" do
      it "does not create a new Stack" do
        expect {
          post stacks_url, params: { stack: invalid_attributes }
        }.to change(Stack, :count).by(0)
      end

    
      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post stacks_url, params: { stack: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) { { title: "Updated Stack" } }

      it "updates the requested stack" do
        stack = create(:stack)

        patch stack_url(stack), params: { stack: new_attributes }
        stack.reload

        expect(stack.title).to eq(new_attributes[:title])
      end

      it "redirects to the stack" do
        stack = create(:stack)
        patch stack_url(stack), params: { stack: new_attributes }
        stack.reload
        expect(response).to redirect_to(stack_url(stack))
      end
    end

    context "with invalid parameters" do
    
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        stack = create(:stack)
        patch stack_url(stack), params: { stack: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested stack" do
      stack = create(:stack)
      expect {
        delete stack_url(stack)
      }.to change(Stack, :count).by(-1)
    end

    it "redirects to the stacks list" do
      stack = create(:stack)
      delete stack_url(stack)
      expect(response).to redirect_to(stacks_url)
    end
  end
end
