class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.references :votable, polymorphic: true
      t.integer :rate_point, limit: 1
      t.timestamps
    end

    add_belongs_to :votes, :user, index: true, foreign_key: true
    add_index :votes, [:user_id, :votable_id, :votable_type]
  end
end
