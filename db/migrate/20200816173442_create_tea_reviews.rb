class CreateTeaReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :tea_reviews do |t|
      t.string :name
      t.text :review

      t.timestamps
    end
  end
end
