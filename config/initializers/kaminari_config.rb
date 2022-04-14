# frozen_string_literal: true

Kaminari.configure do |config|
  config.default_per_page = 20 # 表示件数
  # config.max_per_page = nil
  config.window = 4          # 現在のページから左右何ページ分表示(最初は合計5、間だと合計9)
  # config.outer_window = 3
  # config.left = 0
  # config.right = 0
  # config.page_method_name = :page
  # config.param_name = :page
  # config.max_pages = nil
  # config.params_on_first_page = false
end
