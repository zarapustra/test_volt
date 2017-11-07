class AddUserAndPostReferenceToComments < ActiveRecord::Migration[5.1]
  def change
    add_reference :comments, :user
    add_reference :comments, :post
  end
end
