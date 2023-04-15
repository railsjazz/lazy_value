class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name

      t.timestamps
    end

    100.times do |i|
      User.create(name: "User #{i}")
    end
  end
end
