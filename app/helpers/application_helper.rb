module ApplicationHelper
  def full_name
    @user = current_user
    full_name = @user&.name&.concat(" ")&.concat(@user&.surname)
  end
end
