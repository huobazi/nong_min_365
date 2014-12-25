class WriteNidToCategory < ActiveRecord::Migration
  def up
    [
      {:id => 1  , :name => '水产渔业' , :nid => 5 },
      {:id => 2  , :name => '特种养殖' , :nid => 6 },
      {:id => 3  , :name => '地方特产' , :nid => 7 },
      {:id => 4  , :name => '茶叶副食' , :nid => 8 },
      {:id => 5  , :name => '花卉药材' , :nid => 9 },
      {:id => 6  , :name => '农机物资' , :nid => 10},
      {:id => 7  , :name => '纤维作物' , :nid => 11},
      {:id => 8  , :name => '化肥农药' , :nid => 12},
      {:id => 9  , :name => '物流运输' , :nid => 13},
      {:id => 10 , :name => '民间工艺' , :nid => 14},
      {:id => 11 , :name => '有机食品' , :nid => 15},
      {:id => 12 , :name => '生产加工' , :nid => 16},
      {:id => 13 , :name => '水果蔬菜' , :nid => 2 },
      {:id => 14 , :name => '种子苗木' , :nid => 4 },
      {:id => 15 , :name => '肉禽蛋奶' , :nid => 3 },
      {:id => 16 , :name => '五谷粮油' , :nid => 1 },
      {:id => 17 , :name => '土地租赁' , :nid => 17},
      {:id => 18 , :name => '其它类别' , :nid => 18}
    ].each do |c|
      category = Category.find(c[:id])
      category.update_attribute(:nid, c[:nid]) if category
    end

  end

  def down
  end
end
