class CreateProperties < ActiveRecord::Migration[6.1]
  def change
    create_table :properties do |t|
      t.string :name
      t.string :address
      t.string :city
      t.text :notes

      t.references :user

      t.timestamps
    end
  end
end
