class CreatePostContents < ActiveRecord::Migration[8.0]
  def change
    create_table :post_contents do |t|
      t.string :content_type
      t.text :content
      t.references :postable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
