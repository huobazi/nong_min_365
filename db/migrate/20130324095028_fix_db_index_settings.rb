class FixDbIndexSettings < ActiveRecord::Migration
  def change 
    
    execute <<-SQL
    DROP INDEX index_on_items;
    CREATE INDEX index_on_items
      ON items
        USING btree
          (category_id, refresh_at, user_id, province_code COLLATE pg_catalog."C", city_code COLLATE pg_catalog."C", county_code COLLATE pg_catalog."C", town_code COLLATE pg_catalog."C", village_code COLLATE pg_catalog."C", xtype);
    SQL

    remove_index :chinese_regions, :code
    remove_index :chinese_regions, :level
    add_index :chinese_regions, [:code, :level], :name => 'index_chinese_regions'
    execute <<-SQL
    DROP INDEX index_chinese_regions;
    CREATE INDEX index_chinese_regionse
  ON chinese_regions
  USING btree
  (code COLLATE pg_catalog."C", level);
    SQL

  end
end
