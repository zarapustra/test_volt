class CreateComments < ActiveRecord::Migration[5.1]
  def up
    create_table :comments do |t|
      t.string :body
      t.references :posts
      t.datetime :published_at
      t.timestamps
    end
  end

  def down
    drop_table :comments
  end
end
