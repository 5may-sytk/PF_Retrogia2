class CreateRelationships < ActiveRecord::Migration[6.1]
  def change
    create_table :relationships do |t|
      t.references :follower, foreign_key: { to_table: :users }, index: true
      t.references :followed, foreign_key: { to_table: :users }, index: true
      t.timestamps
    end
  end
end
