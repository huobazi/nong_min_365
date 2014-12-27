class AddCategory2IdToItems < ActiveRecord::Migration
  def change
    add_column :items, :category2_id, :integer

    execute <<-SQL
    DROP INDEX index_on_items;
    CREATE INDEX index_on_items
      ON items
        USING btree
          (category_id, category2_id, xtype, refresh_at, province_code COLLATE pg_catalog."C", city_code COLLATE pg_catalog."C", county_code COLLATE pg_catalog."C", town_code COLLATE pg_catalog."C", village_code COLLATE pg_catalog."C", user_id);
    SQL

  end
end
