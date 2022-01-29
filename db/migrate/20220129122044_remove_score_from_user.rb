class RemoveScoreFromUser < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :score, :integer
  end
end
