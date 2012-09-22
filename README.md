## NongMin365

rails g model models 


生成后台

rails g scaffold_controller admincp/models

rails g web_app_theme:themed admincp/models --layout=admincp 

rewrite原有文件




记得把 chinese_regions 表的 code 字段设的 排序规则设置为 

-- Index: index_chinese_regions_on_code

-- DROP INDEX index_chinese_regions_on_code;

CREATE INDEX index_chinese_regions_on_code
  ON chinese_regions
  USING btree
  (code COLLATE pg_catalog."C" );


同时 items 的 region_code 也同眼修改