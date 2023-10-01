class AddTasksCounterToStacks < ActiveRecord::Migration[7.0]
  def change
    add_column :stacks, :tasks_count, :integer
  end
end
