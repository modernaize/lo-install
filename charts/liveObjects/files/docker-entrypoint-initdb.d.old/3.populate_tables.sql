-- 
-- NOTE: - Only project-specific tables should be created here. (e.g.: users, authorizations, menu_items, etc.) 
--         For data that is shared between projects add it to the "1.create_users" file.
-- 
-- \set lo_schema 'lo'
-- \set learn_schema 'learn'
-- \set process_mining_schema 'process_mining'

START TRANSACTION;
-- source_tye table
insert into lo.source_type(source_type_name,form_id)
values
('SAP_ECC',3), 
('SAP_SLT',3),
('SAP_BAPI',3),
('SAP_JCO',3), 
('API_HYBRIS',8),
('ARIBA',4), 
('API_SALESFORCE',8),
('FILE_FTP',2),
('FILE_SFTP',6), 
('FILE_UPLOAD_EXCEL',7) ,
('DATABASE_ORACLE',1),
('DATABASE_HANA',1), 
('DATABASE_DB2',1), 
('DATABASE_POSTGRESQL',1) ,
('DATABASE_MYSQL',1), 
('QUEUE_KAFKA',5),
('INTERNAL_JOIN',7),
('FUNCTION', 7),
('FILE_UPLOAD_MACRO',7),
('FILE_UPLOAD_CSV',7),
('FILE_UPLOAD_JSON',7),
('FILE_SFTP_EXCEL',6),
('FILE_SFTP_JSON',6),
('FILE_SFTP_CSV',6),
('FILE_UPLOAD_PDF',7),
('FILE_UPLOAD',7),
('AUTO_JOIN',7);

-- extractor type table
INSERT INTO lo.extractor_type(extractor_type_name) values('Infocube');
INSERT INTO lo.extractor_type(extractor_type_name) values('File');
INSERT INTO lo.extractor_type(extractor_type_name) values('Table');
INSERT INTO lo.extractor_type(extractor_type_name) values('API');

INSERT INTO lo.status_list(status_name) values('Completed');
INSERT INTO lo.status_list(status_name) values('In Progress');
INSERT INTO lo.status_list(status_name) values('Error');

-- populate form fields table

insert into lo.fieldmapping_type(mapping_type_name) values ('Custom Mapping') , ('Source Mapping') , ('Ontology Mapping');

INSERT INTO lo.form_fields(form_id, field_id, field_name, mandatory) VALUES (3,3,'System ID','X');
INSERT INTO lo.form_fields(form_id, field_id, field_name, mandatory) VALUES (3,2,'Port','X');
INSERT INTO lo.form_fields(form_id, field_id, field_name, mandatory) VALUES (3,5,'Password','X');
INSERT INTO lo.form_fields(form_id, field_id, field_name, mandatory) VALUES (3,4,'User ID','X');
INSERT INTO lo.form_fields(form_id, field_id, field_name, mandatory) VALUES (3,6,'Instance Number','X');
INSERT INTO lo.form_fields(form_id, field_id, field_name, mandatory) VALUES (1,2,'Port','X');
INSERT INTO lo.form_fields(form_id, field_id, field_name, mandatory) VALUES (1,1,'Host IP','X');
INSERT INTO lo.form_fields(form_id, field_id, field_name, mandatory) VALUES (1,4,'Password','X');
INSERT INTO lo.form_fields(form_id, field_id, field_name, mandatory) VALUES (1,3,'User ID','X');
INSERT INTO lo.form_fields(form_id, field_id, field_name, mandatory) VALUES (2,1,'Host IP','X');
INSERT INTO lo.form_fields(form_id, field_id, field_name, mandatory) VALUES (1,5,'Database Name','X');
INSERT INTO lo.form_fields(form_id, field_id, field_name, mandatory) VALUES (2,3,'User ID','X');
INSERT INTO lo.form_fields(form_id, field_id, field_name, mandatory) VALUES (2,2,'Port','X');
INSERT INTO lo.form_fields(form_id, field_id, field_name, mandatory) VALUES (3,1,'Host IP','X');
INSERT INTO lo.form_fields(form_id, field_id, field_name, mandatory) VALUES (2,4,'Password','X');
INSERT INTO lo.form_fields(form_id, field_id, field_name, mandatory) VALUES (6,1,'Host IP','X');
INSERT INTO lo.form_fields(form_id, field_id, field_name, mandatory) VALUES (6,2,'Port','X');
INSERT INTO lo.form_fields(form_id, field_id, field_name, mandatory) VALUES (6,3,'User ID','X');
INSERT INTO lo.form_fields(form_id, field_id, field_name, mandatory) VALUES (6,4,'Password','X');
INSERT INTO lo.form_fields(form_id, field_id, field_name, mandatory) VALUES (6,5,'SFTP Key Location','X');
INSERT INTO lo.form_fields(form_id, field_id, field_name, mandatory) VALUES (8,7,'Client Id','x');
INSERT INTO lo.form_fields(form_id, field_id, field_name, mandatory) VALUES (8,1,'Host IP','x');
INSERT INTO lo.form_fields(form_id, field_id, field_name, mandatory) VALUES (8,2,'Port','x');
INSERT INTO lo.form_fields(form_id, field_id, field_name, mandatory) VALUES (8,3,'User ID','x');
INSERT INTO lo.form_fields(form_id, field_id, field_name, mandatory) VALUES (8,4,'Password','x');
INSERT INTO lo.form_fields(form_id, field_id, field_name, mandatory) VALUES (8,10,'API Path','x');
INSERT INTO lo.form_fields(form_id, field_id, field_name, mandatory) VALUES (8,9,'Grant Type','x');
INSERT INTO lo.form_fields(form_id, field_id, field_name, mandatory) VALUES (8,8,'Client Secret','x');


insert into lo.model_subtype (model_subtype) values ('process discovery');
insert into lo.model_subtype (model_subtype) values ('attribute enrichment');
insert into lo.model_subtype (model_subtype) values ('process matching');
insert into lo.model_subtype (model_subtype) values ('rule mining');
insert into lo.model_subtype (model_subtype) values ('clustering');

insert into lo.model_type (model_type) values ('process discovery');
insert into lo.model_type (model_type) values ('object enrichment');
insert into lo.model_type (model_type) values ('unstructured mining');

insert into lo.model_definition ( model_type_id , model_subtype_id ) values ( 1,1 );
insert into lo.model_definition ( model_type_id , model_subtype_id ) values ( 2,2 );
insert into lo.model_definition ( model_type_id , model_subtype_id ) values ( 2,3 );

insert into lo.document_type(document_type_id, document_type_name) VALUES (0, 'Not Needed'), (1, 'Events'), (2, 'Party'),
 (3, 'Quote'),  (4, 'Order'), (5, 'Billing');

--  Populate prebaked_extractors table
INSERT INTO lo.prebaked_extractors(id, function_name) VALUES ( 1, 'SAP_MINE' );

INSERT INTO lo.transform_type(name) VALUES('Automation');
INSERT INTO lo.transform_type(name) VALUES('DB Update');
INSERT INTO lo.transform_type(name) VALUES('API');

insert into lo.header_file_type (header_file_type_id ,header_file_type_name ,header_file_type_description ,header_file_type_header ) values (NEXTVAL('lo.header_file_type_id_seq'),'SAP_DATA_TYPE_HEADER_FILE','SAP head file using Mapping of ABAP Data Type','FIELD_NAME, FIELD_TYPE, FIELD_LENGTH, FIELD_SCALE');

insert into lo.plot_type (plot_type_id ,plot_name) values (1,'Pie Chart')  ;
insert into lo.plot_type (plot_type_id ,plot_name) values (2,'Bar Chart')   ;
insert into lo.plot_type (plot_type_id ,plot_name) values (3,'Line Chart')  ;

insert into lo.aggregation_type (aggregation_type_id ,aggregation_name) values (1,'MIN') ;
insert into lo.aggregation_type (aggregation_type_id ,aggregation_name) values (2,'MAX')  ;
insert into lo.aggregation_type (aggregation_type_id ,aggregation_name) values (3,'AVG') ;
insert into lo.aggregation_type (aggregation_type_id ,aggregation_name) values (4,'SUM') ;
insert into lo.aggregation_type (aggregation_type_id ,aggregation_name) values (5,'COUNT');

--set new version for each release

insert into lo.version (version) values ('2020.2.0');

INSERT INTO lo.autojoin_mapping(id, autojoin_mapping_type)
VALUES
    (1, 'SELECTED'),
    (2, 'ACTIVITY'),
    (3, 'RESOURCE'),
    (4, 'CASE_ID');

INSERT INTO lo.business_relations(id, relation) 
VALUES 
    (1, 'Synonym'),
    (2, 'Belongs To'),
    (3, 'Precedes'),
    (4, 'SQL Aggregate'),
    (5, 'SQL Column')
ON CONFLICT DO NOTHING;

INSERT INTO lo.autojoin_output_table_type(id, autojoin_output_table_type)
VALUES
    (1, 'EVENT_TABLE'),
    (2, 'FACT_TABLE');

INSERT INTO lo.business_dictionary (id, term, relation_id, entity) 
VALUES 
    (1, 'Sales Order', 1, 'Order Number, Revenue, Sales Order Number'),
    (2, 'Purchase Order', 1, 'Order Number, Cost, Purchase Order Number'),
    (3, 'GL Account', 1, 'General Ledger, GL, Account Number'),
    (4, '=', 1, 'equal, equivalent, same, matches, identical'),
    (5, '>', 1, 'greater, larger, higher'),
    (6, 'AVG', 4, 'average, mean, common, usual'),
    (7, 'COUNT', 4, 'count, calculate, tally'),
    (8, 'MIN', 4, 'min, minimum, least, lowest, smallest'),
    (9, 'MAX', 4, 'max, maximum, greatest, highest, largest'),
    (10, 'SUM', 4, 'sum, total, aggregate, summation')
ON CONFLICT DO NOTHING;

-- comment this table out since it is using hardcoded customer table values.
-- will not be used for  v2020.2.0 release
-- INSERT INTO lo.scenario_entity_relation_header(extractor_id, field_name, table_name, autojoin_mapping_type_id, autojoin_output_table_type_id)
-- VALUES
--    (1, 'order_number',     'lo_customers.S_5_E_5_liveobjects', 1, 1),
--    (1, 'create_user',      'lo_customers.S_5_E_5_liveobjects', 2, 2),
--    (1, 'goods_issue_date', 'lo_customers.S_5_E_6_liveobjects', 3, 1);
    
-- end lo metadata objects    

-- learn metadata objects
insert into learn.config_parameters (config_key , config_value) values ('uns_iteration', 60);
insert into learn.config_parameters (config_key , config_value) values ('scoring_algos', 'jaro_winkler');
insert into learn.config_parameters (config_key , config_value) values ('preprocessing', 'True');
insert into learn.config_parameters (config_key , config_value) values ('scoring', 'best');
insert into learn.config_parameters (config_key , config_value) values ('match_threshold', 0.8);
insert into learn.config_parameters (config_key , config_value) values ('lookup_method', 'first');
insert into learn.config_parameters (config_key , config_value) values ('high_corr_cont', 0.3);
insert into learn.config_parameters (config_key , config_value) values ('med_corr_cont', 0.0003);
insert into learn.config_parameters (config_key , config_value) values ('high_corr_cat', 0.05);
insert into learn.config_parameters (config_key , config_value) values ('med_corr_cat', 0.5);
insert into learn.config_parameters (config_key , config_value) values ('when_to_train', 'start_time');
insert into learn.config_parameters (config_key , config_value) values ('number_of_variants', 10);
insert into learn.config_parameters (config_key , config_value) values ('categorical_variable_limit', 50);
insert into learn.config_parameters (config_key , config_value) values ('preview_exclude_filter', 'attribute:L_');
insert into learn.config_parameters (config_key , config_value) values ('top_predictions', 5);
insert into learn.config_parameters (config_key , config_value) values ('stop_words_list', '[]');
insert into learn.config_parameters (config_key , config_value) values ('ngrams_min', 3);
insert into learn.config_parameters (config_key , config_value) values ('ngrams_max', 3);
insert into learn.config_parameters (config_key , config_value) values ('cluster_n_components', '[4, 5, 6, 7]');
insert into learn.config_parameters (config_key , config_value) values ('drill_down_limited', 1);
insert into learn.config_parameters (config_key , config_value) values ('pic_to_text_config', 'r''--oem 3 --psm 6''');
--nRows, falsePositive, threshold
insert into learn.config_parameters (config_key , config_value) values
('auto_join_sample_size', 10000),
('auto_join_false_pos', .001),
('auto_join_threshold', .7),
('auto_join_alg', 'bloom'),
('enable_nli_search', 'False');

-- end learn metadata objects

COMMIT;