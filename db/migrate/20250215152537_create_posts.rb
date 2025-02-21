class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|

      t.string :title, null: false
      t.text :contents
      t.string :address #住所 
      t.float :latitude #緯度
      t.float :longitude #経度
      t.datetime :visited_at, default: -> { 'CURRENT_TIMESTAMP' } #訪問日時
      #t.string :tags #タグ
      t.integer :visibility, default:0 #投稿の公開有無
      t.references :user #Userモデルとのリレーション
      t.timestamps
    end
  end
end
