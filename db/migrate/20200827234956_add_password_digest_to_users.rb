t.string :descripcion
t.string :ubicacion
t.references :person, index: true, foreign_key: true
t.references :user, index: true, foreign_key: trueclass AddPasswordDigestToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :password_digest, :string
  end
end
