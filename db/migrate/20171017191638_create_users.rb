class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :nickname
      t.string :email
      t.string :password_digest
      t.string :token, index: true
      t.timestamps
    end
  end
end
