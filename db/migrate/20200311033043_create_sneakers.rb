class CreateSneakers < ActiveRecord::Migration[5.1]
  def change
    create_table :sneakers do |t|
      t.string :brand 
      t.string :model
      t.string :color
      t.string :size
      t.belongs_to :user
      
    end
  end
end
