class AddFkStackToTasks < ActiveRecord::Migration[7.0]
  def change
    add_reference :tasks, :stack
  end
end
