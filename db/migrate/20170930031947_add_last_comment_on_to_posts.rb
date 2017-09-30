class AddLastCommentOnToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :last_commented_on, :datetime
  end
end
