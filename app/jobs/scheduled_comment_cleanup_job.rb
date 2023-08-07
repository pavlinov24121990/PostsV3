class ScheduledCommentCleanupJob < ApplicationJob
  queue_as :default

  def perform
    Comment.where(scheduled_for_deletion_at: true).where('updated_at <= ?', 1.minute.ago).destroy_all
  end
end