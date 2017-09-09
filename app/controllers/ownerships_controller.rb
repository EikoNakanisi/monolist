class OwnershipsController < ApplicationController

#Item の Want ボタンが押されたアクション
  def create
    @item = Item.find_or_initialize_by(code: params[:item_code])
# Item.find_by して見つかればテーブルに保存されていたインスタンスを返し
# 見つからなければ Item.new して新規作成

    unless @item.persisted?
      # @item が保存されていない場合、先に @item を保存する
      results = RakutenWebService::Ichiba::Item.search(itemCode: @item.code)
      #read は items_controller.rb に書かれている
      @item = Item.new(read(results.first))
      @item.save
    end

    # Want 関係として保存
    if params[:type] == 'Want'
      current_user.want(@item)
      #helpers/sessions_helper.rb で定義したcurrent_user
      flash[:success] = '商品を Want しました。'
    end

    redirect_back(fallback_location: root_path)
  end

  def destroy
    @item = Item.find(params[:item_id])

    if params[:type] == 'Want'
      current_user.unwant(@item) 
      flash[:success] = '商品の Want を解除しました。'
    end

    redirect_back(fallback_location: root_path)
  end
end
