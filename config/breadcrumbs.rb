crumb :boards_path do
  link "掲示板一覧", boards_path
end

crumb :boards_path_show do |board|
  session[:board_id] = board.id if session[:board_id].nil?
  session[:board_title] = board.title if session[:board_title].nil?
  link session[:board_title], board_path(session[:board_id])
  parent :boards_path if request.referer&.include?("boards")
  parent :user_path_show if request.referer&.include?("users/")
end

crumb :edit_board_path do
  link "編集", edit_board_path(session[:board_id])
  parent :boards_path_show
end

crumb :new_board_path do
  link "作成", new_board_path
  parent :boards_path if request.referer&.include?("board")
end

crumb :user_path do
  link "ユーザー一覧", users_path
end

crumb :user_path_show do |user|
  # session[:user_id] = user.id if session[:user_id].nil?
  session[:user_name] = user.name if session[:user_name].nil?
  if request.referer&.include?("boards/")
    link user.name, user_path(user.id)
    parent :boards_path_show
  else
    link session[:user_name], user_path(session[:user_id])
    parent :user_path
  end

  # if request.referer&.include?("boards/")
  #   link user.name, user_path(user.id)
  # else
  #   link session[:user_name], user_path(session[:user_id])
  # end
  # if request.referer&.include?("boards/")
  #   parent :boards_path_show
  # else
  #   parent :user_path
  # end
end


crumb :followings_path do
  if request.referer&.include?("users/")
    link "フォロー一覧", followings_path
    parent :user_path_show
  else
    link "フォロー一覧", followings_path
    parent :user_path
  end
end

crumb :followers_path do
  if request.referer&.include?("users/")
    link "フォロワー一覧", followers_path
    parent :user_path_show
  else
    link "フォロワー一覧", followers_path
    parent :user_path
  end
end