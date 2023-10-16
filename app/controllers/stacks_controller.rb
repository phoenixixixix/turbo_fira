class StacksController < ApplicationController
  before_action :set_stack, only: %i[ show edit update destroy ]

  def index
    @stacks = current_user.stacks
  end

  def show
  end

  def new
    @stack = Stack.new
  end

  def edit
  end

  def create
    @stack = current_user.stacks.build(stack_params)

    if @stack.save
      redirect_to @stack, notice: "Stack was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @stack.update(stack_params)
      redirect_to @stack, notice: "Stack was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @stack.destroy
    redirect_to stacks_url, notice: "Stack was successfully destroyed.", status: :see_other
  end

  private

  def set_stack
    @stack = Stack.find(params[:id])
  end

  def stack_params
    params.require(:stack).permit(:title)
  end
end
