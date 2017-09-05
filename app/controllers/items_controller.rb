class ItemsController < ApplicationController
  before_action :require_user_logged_in

  def new
#カラ配列初期化 検索ワードが入力されたとき値が入る
    @items = []
#フォームから送信される検索ワードを取得
    @keyword = params[:keyword]
#楽天APIを使用して検索を実行:検索ワード、画像あり、20件検索→検索結果は results に代入
    if @keyword
      results = RakutenWebService::Ichiba::Item.search({
        keyword: @keyword,
        imageFlag: 1,
        hits: 20,
      })

      results.each do |result|
        # 扱い易いように Item としてインスタンスを作成する（保存はしない）
        item = Item.new(read(result))
        #item を [] に追加
        @items << item
      end
    end
  end

  private
# 複雑な検索結果から、必要な値を読み出し、最後に配列として return
  def read(result)
    code = result['itemCode']
    name = result['itemName']
    url = result['itemUrl']
    # ?_ex=128x128 は画像サイズ調整；サイズ指定無しの画像を取得
    image_url = result['mediumImageUrls'].first['imageUrl'].gsub('?_ex=128x128', '')

    return {
      code: code,
      name: name,
      url: url,
      image_url: image_url,
    }
  end
end
