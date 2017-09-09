class Item < ApplicationRecord
  validates :code, presence: true, length: { maximum: 255 }
  validates :name, presence: true, length: { maximum: 255 }
  validates :url, presence: true, length: { maximum: 255 }
  validates :image_url, presence: true, length: { maximum: 255 }
  
  # item.ownerships で中間テーブルのインスタンス群を
  # item.users で item を want/have している users を取得可能
  has_many :ownerships
  has_many :users, through: :ownerships

# item を want/have している users を取得
  has_many :wants
  has_many :want_users, through: :wants, class_name: 'User', source: :user
  has_many :haves, class_name: 'Have'
  has_many :have_users, through: :haves, class_name: 'User', source: :user
end
