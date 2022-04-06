crumb :boards_path do
  link "掲示板一覧", boards_path
end

crumb :boards_path_show do |id|
  link "登録一覧", boards_path(id)
  parent :boards_path
end

crumb :new_board_path do
  link "掲示板作成", new_board_path
  parent :boards_path if request.referer&.include?("board")
end


crumb :user_path_show do |user|
  link "掲示板作成", user_path(user.id)
  parent :new_board_path if request.referer&.include?("boards/new")
end