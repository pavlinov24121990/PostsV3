class AddScheduledForDeletionAtToComments < ActiveRecord::Migration[7.0]
  def change
    add_column :comments, :scheduled_for_deletion_at, :boolean
  end
end
