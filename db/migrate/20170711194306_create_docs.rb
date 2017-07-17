class CreateDocs < ActiveRecord::Migration[5.0]
  def change
    create_table :docs do |t|
      t.string :description
      t.string :filename
      t.string :savefilename

      t.timestamps
    end
  end
end
