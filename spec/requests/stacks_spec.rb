require "rails_helper"

RSpec.describe "/stacks", type: :request do
  let(:valid_attributes) { { title: "Stack" } }

  let(:invalid_attributes) { { title: "" } }

  before { log_in(create(:user)) }

  describe "GET /index" do
    it "renders a successful response" do
      Stack.create! valid_attributes
      get stacks_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      stack = Stack.create! valid_attributes
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
      stack = Stack.create! valid_attributes
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
        stack = Stack.create! valid_attributes

        patch stack_url(stack), params: { stack: new_attributes }
        stack.reload

        expect(stack.title).to eq(new_attributes[:title])
      end

      it "redirects to the stack" do
        stack = Stack.create! valid_attributes
        patch stack_url(stack), params: { stack: new_attributes }
        stack.reload
        expect(response).to redirect_to(stack_url(stack))
      end
    end

    context "with invalid parameters" do
    
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        stack = Stack.create! valid_attributes
        patch stack_url(stack), params: { stack: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested stack" do
      stack = Stack.create! valid_attributes
      expect {
        delete stack_url(stack)
      }.to change(Stack, :count).by(-1)
    end

    it "redirects to the stacks list" do
      stack = Stack.create! valid_attributes
      delete stack_url(stack)
      expect(response).to redirect_to(stacks_url)
    end
  end
end
