module BoardsHelper
  def sort_order(column, title)
    direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"
    link_to title , { column: column, direction: direction }
  end
end