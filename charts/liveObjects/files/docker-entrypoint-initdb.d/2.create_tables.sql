-- 
-- NOTE: - Only project-specific tables should be created here. (e.g.: source, scenario,extractor, etc.)
--         For data that is shared between projects add it to the "1.create_users" file.
-- 

-- sudo -i -u liveobjects
-- psql
-- \c liveobjects;

-- \set lo_schema 'lo'
-- \set lo_customers_schema 'lo_customers'
-- \set learn_schema 'learn'
-- \set process_mining_schema 'process_mining'
-- \set customer_data_schema 'customer_data'

CREATE SCHEMA IF NOT EXISTS lo_customers;
grant all on schema lo_customers to liveobjects;
CREATE SCHEMA IF NOT EXISTS lo;
grant all on schema lo to liveobjects;
CREATE SCHEMA IF NOT EXISTS learn;
grant all on schema learn to liveobjects;
CREATE SCHEMA IF NOT EXISTS process_mining;
grant all on schema process_mining to liveobjects;
create schema if not exists customer_data;
grant all on schema customer_data to liveobjects;

START TRANSACTION;

-- version
CREATE TABLE IF NOT EXISTS lo.version(
    id                          serial primary key,
    version                     varchar(64),
	create_timestamptz          timestamptz default current_timestamp,
	update_timestamptz          timestamptz,
    record_type                 varchar(64),
    record_status               varchar(32),
    last_update_timestamptz     timestamptz,
    last_update_user            integer
);

create table lo.fieldmapping_type(
	mapping_type_id         serial  primary key,
	mapping_type_name           varchar(30) unique,
    record_type                 varchar(64),
    record_status               varchar(32),
    last_update_timestamptz     timestamptz,
    last_update_user            integer
);

create table lo.document_type(
	document_type_id            serial  primary key,
	document_type_name          varchar(30) unique,
    record_type                 varchar(64),
    record_status               varchar(32),
    last_update_timestamptz     timestamptz,
    last_update_user            integer
);

CREATE TABLE lo.form_fields
(
	form_id int NOT NULL,
	field_id int NOT NULL,
	field_name character varying(40),
	mandatory character(1),
    record_type                 varchar(64),
    record_status               varchar(32),
    last_update_timestamptz     timestamptz,
    last_update_user            integer,
	PRIMARY KEY (form_id, field_id)
);

create table lo.source_type(
	source_type_id          serial  primary key,
	source_type_name        varchar(30),
    record_type                 varchar(64),
    record_status               varchar(32),
    last_update_timestamptz     timestamptz,
    last_update_user            integer,
	form_id integer
  );

create table lo.extractor_type(
	extractor_type_id       serial  primary key,
	extractor_type_name     varchar(30),
    record_type                 varchar(64),
    record_status               varchar(32),
    last_update_timestamptz     timestamptz,
    last_update_user            integer
);

create table lo.scenario(
	scenario_id           serial primary key,
	scenario_name         varchar(30) unique not null,
	scenario_description  varchar(100),
	create_timestamptz    timestamptz default current_timestamp,
	update_timestamptz    timestamptz,
	create_user           varchar(20) not null,
	update_user           varchar(20),
    record_type                 varchar(64),
    record_status               varchar(32),
    last_update_timestamptz     timestamptz,
    last_update_user            integer
);

create table lo.source(
	source_id                   serial primary key,
	source_name                 varchar(30) unique not null,
	source_description          varchar (100),
	create_timestamptz          timestamptz default current_timestamp,
	source_type_id              int references lo.source_type(source_type_id) not null,
	source_data_format          int check ( source_data_format in (0,1,2) ) not null,
	connection_type             int check ( connection_type in (0,1,2) ) not null,
	application_server          varchar(100),
	instance_number             varchar(10),
	system_id                   varchar(10),
	ip                          varchar(36),
	port                        int,
	user_id                     varchar(64),
	password                    varchar(65),
	database_name               varchar(32),
	sftp_key_location       varchar(100),
	update_timestamptz      timestamptz,
	client_id               varchar(128),
	client_secret           varchar(64),
	grant_type              varchar(32),
	api_path                varchar(64),
    record_type                 varchar(64),
    record_status               varchar(32),
    last_update_timestamptz     timestamptz,
    last_update_user            integer
);

create table lo.object_mapping(
	mapping_id              serial primary key,
	source_type_id          int references lo.source_type(source_type_id),
	source_table_name       varchar(30) not null,
	document_type_id        int references lo.document_type(document_type_id),
	target_table_name       varchar(30),
    record_type                 varchar(64),
    record_status               varchar(32),
    last_update_timestamptz     timestamptz,
    last_update_user            integer,
	unique(source_type_id, source_table_name, document_type_id)
);

create table lo.field_mapping (
	mapping_id              int references lo.object_mapping(mapping_id) ,
	source_field_name       varchar(30) not null,
	target_field_name       varchar(30) not null,
	target_field_type       varchar(30),
	target_field_length     varchar(30),
    record_type                 varchar(64),
    record_status               varchar(32),
    last_update_timestamptz     timestamptz,
    last_update_user            integer,
	primary key (mapping_id, source_field_name)
);

create table lo.extractor_header(
	extractor_id				serial primary key,
	scenario_id					int references lo.scenario(scenario_id),
	source_id					int references lo.source(source_id),

	extractor_name				varchar(30) unique,
	extractor_type_id			int references lo.extractor_type(extractor_type_id),
	source_object_name			text,

	metadata_source				int check (metadata_source in (0,1,2,3,4)),
	incremental_load			boolean not null,
	incremental_load_field		varchar(30),
    incremental_load_value		timestamptz, /* added missing columns in extractor_header */
    extractor_rule				varchar(500), /* added missing columns in extractor_header */
	target_location             varchar(100),

    document_type_id            int references lo.document_type (document_type_id),
	target_table_name           varchar(40),
	metadata_file_input         text,
	create_timestamptz			timestamptz default current_timestamp,
	update_timestamptz			timestamptz,
	sql_query					varchar(500),
    prebaked_extractor          int,

    field_delimiter             varchar(10) default ',',
    has_header                  boolean,
    has_header_file             boolean,
    header_file_type_name       varchar(32),
    header_file_name            varchar(128),

    record_type                 varchar(64),
    record_status               varchar(32),
    last_update_timestamptz     timestamptz,
    last_update_user            integer
);

create table lo.extractor_details(
	extractor_id                int references lo.extractor_header(extractor_id),
	source_field_name           varchar(64) not null,
	target_field_name           varchar(64) not null,
	target_field_type           int not null,
	target_field_length         varchar(30),
	is_custom_mapping           boolean,
	is_primary_key              boolean,
    record_type                 varchar(64),
    record_status               varchar(32),
    last_update_timestamptz     timestamptz,
    last_update_user            integer,
	primary key(extractor_id, source_field_name)
);

create table lo.status_list (
	status_id                   serial  ,
	status_name                 varchar(20),
    record_type                 varchar(64),
    record_status               varchar(32),
    last_update_timestamptz     timestamptz,
    last_update_user            integer,
	primary key ( status_id )
);

create table lo.model_details (
	model_id                    serial primary key,
	fact_table_name             varchar(30),
	output_table_name           varchar(30),
	model_name                  varchar(30),
	hyper_parameters            varchar(200),
    record_type                 varchar(64),
    record_status               varchar(32),
    last_update_timestamptz     timestamptz,
    last_update_user            integer,
	extractor_id                int references lo.extractor_header(extractor_id)
);

create table lo.load_run_log (
	run_id						serial ,
	extractor_id				int references lo.extractor_header(extractor_id),
	start_time					timestamptz,
	end_time					timestamptz,
	status_id					int references lo.status_list (status_id),
    row_count                   int,
    extractor_rule              text,
    error                       text,
    record_type                 varchar(64),
    record_status               varchar(32),
    last_update_timestamptz     timestamptz,
    last_update_user            integer,
	primary key ( run_id)
);

create table lo.async_job(
	id                          serial,
	job_status                   int,
	result_url                   varchar(100),
    record_type                 varchar(64),
    record_status               varchar(32),
    last_update_timestamptz     timestamptz,
    last_update_user            integer,
	primary key (id)
);

create table lo.model_type(
	id                           serial,
	model_type                   varchar(50),
    record_type                 varchar(64),
    record_status               varchar(32),
    last_update_timestamptz     timestamptz,
    last_update_user            integer,
	primary key (id)
);

create table lo.model_subtype(
	id                          serial,
	model_subtype varchar(50),
    record_type                 varchar(64),
    record_status               varchar(32),
    last_update_timestamptz     timestamptz,
    last_update_user            integer,
	primary key (id)
);

create table lo.model_definition (
	id                      serial ,
	model_type_id int references lo.model_type(id),
	model_subtype_id int references lo.model_subtype(id),
    record_type                 varchar(64),
    record_status               varchar(32),
    last_update_timestamptz     timestamptz,
    last_update_user            integer,
	primary key ( id)
);

create table lo.model_header (
	id                      serial ,
	model_type_id int references lo.model_type(id),
	model_subtype_id int references lo.model_subtype(id),
	extractor_id  int references lo.extractor_header(extractor_id),
	create_timestamptz			timestamptz default current_timestamp,
    update_timestamptz			timestamptz,
    process_json                text,
    drilldown_extractor_id      int,
    drilldown_attribute         varchar(100),
    matching_job_id             int,
    matching_time_elapsed       varchar(100),
    rules_json                  jsonb,
	cluster_column				varchar(100),
	dep_cluster_column			varchar(100),
	process_config				text,
	model                       bytea,
    record_type                 varchar(64),
    record_status               varchar(32),
    last_update_timestamptz     timestamptz,
    last_update_user            integer,
	primary key ( id)
);

create table lo.model_run_log (
	run_id                      serial ,
	model_id int references lo.model_header(id),
	start_time                  timestamptz,
	end_time                    timestamptz,
	status_id                   int references lo.status_list (status_id),
    record_type                 varchar(64),
    record_status               varchar(32),
    last_update_timestamptz     timestamptz,
    last_update_user            integer,
	primary key ( run_id)
);

create table lo.prebaked_extractors (
    id                          serial,
    function_name               varchar(100),
    record_type                 varchar(64),
    record_status               varchar(32),
    last_update_timestamptz     timestamptz,
    last_update_user            integer,
    primary key ( id )
);

-- add header_file_type table for release 1.7.0
create table if not exists lo.header_file_type (
    header_file_type_id integer not null,
    header_file_type_name varchar(32) not null,
    header_file_type_description varchar(108),
    header_file_type_header varchar(216) not null,
    record_type                 varchar(64),
    record_status               varchar(32),
    last_update_timestamptz     timestamptz,
    last_update_user            integer,
    primary key (header_file_type_id )
);

ALTER TABLE lo.header_file_type ADD CONSTRAINT constraint_header_file_type_name UNIQUE (header_file_type_name);

CREATE SEQUENCE lo.header_file_type_id_seq
       AS integer
       INCREMENT BY 1
       MINVALUE 1
       MAXVALUE 2147483647
       CACHE 1
       NO CYCLE
       OWNED BY lo.header_file_type.header_file_type_id;
-- end add header_file_type table for release 1.7.0

CREATE TABLE lo.transform_type
(
    id                          serial primary key,
    name                        varchar(64),
    record_type                 varchar(64),
    record_status               varchar(32),
    last_update_timestamptz     timestamptz,
    last_update_user            integer
);

CREATE TABLE lo.transform
(
    id                          serial primary key,
    source_type_id              int references lo.source_type(source_type_id) not null,
    transform_type_id           int references lo.transform_type(id) not null,
    name                        varchar(64) not null,
    description                 varchar(128) not null,
    script                      text not null,
    create_timestampt			timestamptz default current_timestamp,
    update_timestampt			timestamptz,
    record_type                 varchar(64),
    record_status               varchar(32),
    last_update_timestamptz     timestamptz,
    last_update_user            integer
);
-- plot_type
CREATE TABLE IF NOT EXISTS lo.plot_type (
    plot_type_id                integer not null,
    plot_name                   varchar(32) not null,
    record_type                 varchar(64),
    record_status               varchar(32),
    last_update_timestamptz     timestamptz,
    last_update_user            integer,
    primary key (plot_type_id)
);
ALTER TABLE lo.plot_type ADD CONSTRAINT constraint_plot_name UNIQUE (plot_name);

-- aggregation_type
CREATE TABLE IF NOT EXISTS lo.aggregation_type (
    aggregation_type_id integer not null,
    aggregation_name varchar(32) not null,
    record_type                 varchar(64),
    record_status               varchar(32),
    last_update_timestamptz     timestamptz,
    last_update_user            integer,
    primary key (aggregation_type_id)
);

-- dashboard
CREATE TABLE IF NOT EXISTS lo.dashboard (
    dashboard_id serial,
    scenario_id integer  references lo.scenario(scenario_id),
    dashboard_name varchar(32) not null,
    create_time timestamp not null,
    update_time timestamp not null,
    record_type                 varchar(64),
    record_status               varchar(32),
    last_update_timestamptz     timestamptz,
    last_update_user            integer,
    primary key (dashboard_id)
);

-- plot
CREATE TABLE IF NOT EXISTS lo.plot (
    plot_id serial,
    dashboard_id integer references lo.dashboard(dashboard_id),
    extractor_id integer references lo.extractor_header(extractor_id),
    plot_type_id integer references lo.plot_type(plot_type_id),
    plot_label varchar(32) not null,
    aggregation_type_id integer references lo.aggregation_type(aggregation_type_id),
    x_field varchar(32) not null,
    y_field_1 varchar(32) not null,
    y_field_2 varchar(32) not null,
    record_type                 varchar(64),
    record_status               varchar(32),
    last_update_timestamptz     timestamptz,
    last_update_user            integer,
    primary key (plot_id)
);

CREATE TABLE IF NOT EXISTS lo.business_relations(
    id                              INT PRIMARY KEY,
    relation                        VARCHAR(100),
    record_type                     varchar(64),
    record_status                   varchar(32),
    last_update_timestamptz         timestamptz,
    last_update_user                integer
);

CREATE TABLE IF NOT EXISTS lo.business_dictionary(
    id                              SERIAL PRIMARY KEY,
    term	                        VARCHAR(100),
    relation_id                     INT REFERENCES lo.business_relations(id),
    entity	                        TEXT,
    record_type                     varchar(64),
    record_status                   varchar(32),
    last_update_timestamptz         timestamptz,
    last_update_user                integer
);

CREATE TABLE IF NOT EXISTS lo.autojoin_mapping(
    id	                            INT PRIMARY KEY,
    autojoin_mapping_type	        VARCHAR(30),
    record_type                     varchar(64),
    record_status                   varchar(32),
    last_update_timestamptz         timestamptz,
    last_update_user                integer
);

CREATE TABLE IF NOT EXISTS lo.autojoin_output_table_type(
    id	                            INT PRIMARY KEY,
    autojoin_output_table_type	    VARCHAR(30),
    record_type                     varchar(64),
    record_status                   varchar(32),
    last_update_timestamptz         timestamptz,
    last_update_user                integer
);

CREATE TABLE IF NOT EXISTS lo.scenario_entity_relation_header(
    id	                            SERIAL PRIMARY KEY,
    extractor_id	                INT,
    field_name	                    VARCHAR(100),
    table_name	                    VARCHAR(100),
    autojoin_mapping_type_id	    INT REFERENCES lo.autojoin_mapping(id),
    autojoin_output_table_type_id	INT REFERENCES lo.autojoin_output_table_type(id),
    record_type                     varchar(64),
    record_status                   varchar(32),
    last_update_timestamptz         timestamptz,
    last_update_user                integer
);
-- end lo schema related tables

-- learn related tables
CREATE TABLE learn.config_parameters(
    config_id serial,
    config_key varchar(40),
    config_value varchar(100),
    description text ,
    record_type                     varchar(64),
    record_status                   varchar(32),
    last_update_timestamptz         timestamptz,
    last_update_user                integer,
    PRIMARY KEY (config_id)
 );

CREATE TABLE learn.matching(
    join_id serial,
    src varchar(256) ,
    target varchar(256) ,
    src_attributes text ,
    target_match text ,
    target_attributes_to_pull text ,
    resultant varchar(256) ,
    res_pos varchar(256) ,
    res_neg varchar(256) ,
    extractor_id int references lo.extractor_header(extractor_id),
    record_type                     varchar(64),
    record_status                   varchar(32),
    last_update_timestamptz         timestamptz,
    last_update_user                integer,
    PRIMARY KEY (join_id)
 );

CREATE TABLE learn.uns_entries (
    entry_id serial,
    entry_text text ,
    file_name varchar(256),
    show_entry boolean,
    single_document boolean,
    extractor_id int ,
    record_type                     varchar(64),
    record_status                   varchar(32),
    last_update_timestamptz         timestamptz,
    last_update_user                integer,
    PRIMARY KEY (entry_id)
 );

CREATE TABLE learn.uns_attributes(
    attribute_id serial,
    attribute_name varchar(256) ,
    string_value text ,
    ground_truth boolean ,
    entry_id int references learn.uns_entries(entry_id),
    char_start int ,
    char_end int,
    predicted boolean,
    update_timestamptz timestamptz,
    enrichment boolean,
    deleted boolean,
    updated_by varchar(100),
    score numeric,
    single_document boolean,
    record_type                     varchar(64),
    record_status                   varchar(32),
    last_update_timestamptz         timestamptz,
    last_update_user                integer,
    PRIMARY KEY (attribute_id)
 );

CREATE TABLE learn.uns_flags (
    attribute_id serial,
    flagged boolean,
    entry_id int references learn.uns_entries(entry_id),
    entry_flagged boolean,
    record_type                     varchar(64),
    record_status                   varchar(32),
    last_update_timestamptz         timestamptz,
    last_update_user                integer,
    PRIMARY KEY (attribute_id)
 );

CREATE TABLE learn.rule_mining
(
    model_id          integer         NOT NULL,
    rule_id           integer         NOT NULL,
    rule_type         varchar(256),
    extractor_id      integer,
    rule_description  varchar(2000),
    rule_query        varchar(2000),
    selection_count   integer,
    key_fields        varchar(200),
    priority_field    varchar(50),
    record_type                     varchar(64),
    record_status                   varchar(32),
    last_update_timestamptz         timestamptz,
    last_update_user                integer,
    PRIMARY KEY (model_id, rule_id)
);

CREATE TABLE learn.matching_details
(
    model_id      integer,
    seq_no        integer,
    column_name   varchar(256),
    record_type                     varchar(64),
    record_status                   varchar(32),
    last_update_timestamptz         timestamptz,
    last_update_user                integer,
    extractor_id  integer
);

CREATE TABLE learn.data_profile (
    data_profile_id serial primary key,
    scenario_id integer  references lo.scenario(scenario_id),
    kind varchar(20) not null, -- auto-join, fact-find, etc.
    by varchar(20) not null, -- Describes which algorithm is responsible for the result (e.g. name natcher or bloom).
    table1 varchar(40),  --lo.extractor_header.target_column_name
    col1 varchar(64), --lo.extractor_details.target_field_name
    table2 varchar(40),
    col2 varchar(64),
    record_type                     varchar(64),
    record_status                   varchar(32),
    last_update_timestamptz         timestamptz,
    last_update_user                integer
);
-- end learn schema related table

-- process mining
-- As of v1.8.0, most of these tables are denormalized
-- this is intentional for speed of querying
CREATE TABLE process_mining.variant(
    model_id integer,
    filter_id integer,
    variant_id integer,
    name varchar(256),
    count integer,
    percentage numeric(5, 2),
    case_ids text,
    record_type                     varchar(64),
    record_status                   varchar(32),
    last_update_timestamptz         timestamptz,
    last_update_user                integer,
    PRIMARY KEY (model_id, filter_id, variant_id)
);

CREATE TABLE process_mining.variant_kpi(
    model_id integer,
    filter_id integer,
    variant_id integer,
    kpi_measure varchar(256),
    aggregation varchar(256),
    value integer,
    record_type                     varchar(64),
    record_status                   varchar(32),
    last_update_timestamptz         timestamptz,
    last_update_user                integer,
    PRIMARY KEY (model_id, filter_id, variant_id, kpi_measure, aggregation)
);

CREATE TABLE process_mining.graph_and_bottlenecks(
    model_id integer,
    filter_id integer,
    variant_id integer,
    graph text,
    bottlenecks text,
    record_type                     varchar(64),
    record_status                   varchar(32),
    last_update_timestamptz         timestamptz,
    last_update_user                integer,
    PRIMARY KEY (model_id, filter_id, variant_id)
);

CREATE TABLE process_mining.drilldown(
    model_id integer,
    filter_id integer,
    variant_id integer,
    drilldown text,
    record_type                     varchar(64),
    record_status                   varchar(32),
    last_update_timestamptz         timestamptz,
    last_update_user                integer,
    PRIMARY KEY (model_id, filter_id, variant_id)
);

CREATE TABLE process_mining.correlation(
    model_id integer,
    filter_id integer,
    variant_id integer,
    correlation text,
    record_type                     varchar(64),
    record_status                   varchar(32),
    last_update_timestamptz         timestamptz,
    last_update_user                integer,
    PRIMARY KEY (model_id, filter_id, variant_id)
);

CREATE TABLE process_mining.statistics(
    model_id integer,
    filter_id integer,
    variant_id integer,
    dep_attribute varchar(256),
    indep_attribute varchar(256),
    statistics text,
    record_type                     varchar(64),
    record_status                   varchar(32),
    last_update_timestamptz         timestamptz,
    last_update_user                integer,
    PRIMARY KEY (model_id, filter_id, variant_id, dep_attribute, indep_attribute)
);

CREATE TABLE process_mining.plot_data(
    model_id integer,
    filter_id integer,
    variant_id integer,
    dep_attribute varchar(256),
    indep_attribute varchar(256),
    data text,
    record_type                     varchar(64),
    record_status                   varchar(32),
    last_update_timestamptz         timestamptz,
    last_update_user                integer,
    PRIMARY KEY (model_id, filter_id, variant_id, dep_attribute, indep_attribute)
);

CREATE TABLE process_mining.baseline(
    model_id integer,
    baseline_id integer,
    name varchar(256),
    case_id text,
    graph text,
    bottleneck text,
    correlation text,
    summary text,
    record_type                     varchar(64),
    record_status                   varchar(32),
    last_update_timestamptz         timestamptz,
    last_update_user                integer,
    PRIMARY KEY (model_id, baseline_id)
);

CREATE TABLE process_mining.baseline_plot_data(
    model_id integer,
    baseline_id integer,
    dep_attribute varchar(256),
    indep_attribute varchar(256),
    data text,
    record_type                     varchar(64),
    record_status                   varchar(32),
    last_update_timestamptz         timestamptz,
    last_update_user                integer,
    PRIMARY KEY (model_id, baseline_id, dep_attribute, indep_attribute)
);

CREATE TABLE process_mining.status(
    model_id integer,
    filter_id integer,
    status varchar(100),
    message text,
    record_type                     varchar(64),
    record_status                   varchar(32),
    last_update_timestamptz         timestamptz,
    last_update_user                integer,
    PRIMARY KEY (model_id, filter_id)
);
-- end process mining schema related objects

create table if not exists customer_data.source_file(
    id serial NOT NULL,
    extractor_id  integer,
    file_name varchar(64),
    file_type varchar(8),
    file_content_in_bytea bytea,
    host_name varchar(64),
    record_type                     varchar(64),
    record_status                   varchar(32),
    last_update_timestamptz         timestamptz,
    last_update_user                integer
);

-- NOTE: - For any objects that is added after v2020.2.0 release, please add these audit columns to table object:
-- record_type                  varchar  (64) -- LO Configuration, Systemsetting, ….
-- record_status                varchar (32) -- active, inactive, logical deleted …
-- last_update_timestamptz      timestamptz
-- last_update_user             int -- user id

COMMIT;