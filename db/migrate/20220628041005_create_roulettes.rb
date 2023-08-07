class CreateRoulettes < ActiveRecord::Migration[6.0]
  def change
    create_table :roulettes do |t|
      t.string :name, limit: 255, default: ""
      t.string :description, limit: 255, default: ""
      t.string :streaming_url, limit: 512, default: ""
      t.boolean :publish, default: 0
      t.timestamps
    end
  end
end
