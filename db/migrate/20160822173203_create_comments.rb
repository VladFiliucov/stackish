class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :commentable, polymorphic: true
      t.text :body

      t.timestamps null: false
    end

    add_belongs_to :comments, :user, index: true, foreign_key: true
    add_index :comments, [:commentable_id, :commentable_type]
  end
end
