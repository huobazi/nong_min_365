## NongMin365

rails g model models 


生成后台

rails g scaffold_controller admincp/models

rails g web_app_theme:themed admincp/models --layout=admincp 

rewrite原有文件

## 记得重设索引
----------- 发布 记得设置这几个code的排序规则 -------------
-- Index: index_chinese_regions_on_code
DROP INDEX index_chinese_regions_on_code;
CREATE INDEX index_chinese_regions_on_code
  ON chinese_regions
  USING btree
  (code COLLATE pg_catalog."C" );

-- Index: index_items_on_province_code
DROP INDEX index_items_on_province_code;

CREATE INDEX index_items_on_province_code
  ON items
  USING btree
  (province_code COLLATE pg_catalog."C");


-- Index: index_items_on_city_code
DROP INDEX index_items_on_city_code;
CREATE INDEX index_items_on_city_code
  ON items
  USING btree
  (city_code COLLATE pg_catalog."C");

-- Index: index_items_on_county_code
DROP INDEX index_items_on_county_code;
CREATE INDEX index_items_on_county_code
  ON items
  USING btree
  (county_code COLLATE pg_catalog."C");


-- Index: index_items_on_town_code
DROP INDEX index_items_on_town_code;
CREATE INDEX index_items_on_town_code
  ON items
  USING btree
  (town_code COLLATE pg_catalog."C");

-- Index: index_items_on_village_code
DROP INDEX index_items_on_village_code;
CREATE INDEX index_items_on_village_code
  ON items
  USING btree
  (village_code COLLATE pg_catalog."C");
