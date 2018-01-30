class CreateUsers < ActiveRecord::Migration[5.1]
  def up
    create_table :users do |t|
      t.string :nickname, index: true
      t.string :email, index: true
      t.string :password_digest
      t.string :token, index: true
      t.string :avatar
      t.string :time_zone, default: 'UTC'
      t.boolean :admin, defailt: true
      t.timestamps
    end
  end

  def down
    drop_table(:users)
  end
end
