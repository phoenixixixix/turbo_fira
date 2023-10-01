class ResetStacksCacheCounters < ActiveRecord::Migration[7.0]
  def up
    Stack.all.each do |stack|
      Stack.reset_counters(stack.id, :tasks)
    end
  end

  def down
  end
end
