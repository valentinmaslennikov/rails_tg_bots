class CreateTeaReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :tea_reviews do |t|
      t.string :tea
      t.text :review

      t.timestamps
    end
  end
end
