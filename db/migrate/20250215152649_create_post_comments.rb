class CreatePostComments < ActiveRecord::Migration[6.1]
  def change
    create_table :post_comments do |t|
      t.references :user, null: false
      t.references :post, null: false
      t.text :comment
      t.timestamps
    end
  end
end
