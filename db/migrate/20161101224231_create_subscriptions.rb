class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|

      t.timestamps null: false
    end

    add_belongs_to :subscriptions, :user, index: true, foreign_key: true
    add_belongs_to :subscriptions, :question, index: true, foreign_key: true
  end
end
