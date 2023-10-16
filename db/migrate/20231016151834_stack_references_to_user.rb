class StackReferencesToUser < ActiveRecord::Migration[7.0]
  def change
    add_belongs_to :stacks, :user
  end
end
