# frozen_string_literal: true

class AddApprovedToComment < ActiveRecord::Migration[7.0]
  def change
    add_column :comments, :approved, :boolean, default: false
  end
end
