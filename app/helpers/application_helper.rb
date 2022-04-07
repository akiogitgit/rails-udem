# 全ページで使える
module ApplicationHelper
  def header_link_item(name, path)
    class_name = "duration-300 hover:opacity-60"
    # 今のパスと引数のパス同じなら、変数にクラスを追加
    class_name << " opacity-60" if current_page?(path)

    # liタグ内に a タグを埋め込む
    content_tag :li, class: "" do
      link_to name, path, class: class_name
    end
  end
end
