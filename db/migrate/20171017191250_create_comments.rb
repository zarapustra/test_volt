class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.string :body
      t.datetime :published_at
      t.timestamps
    end
  end
end
