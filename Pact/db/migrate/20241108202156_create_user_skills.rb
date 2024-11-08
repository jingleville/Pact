class CreateUserSkills < ActiveRecord::Migration[7.2]
  def change
    create_table :user_skills do |t|
      t.references :user
      t.references :skill

      t.timestamps
    end
  end
end
