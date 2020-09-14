--
-- NOTE: - Only user and authentication tables should be created here. (e.g.: user,role, etc.)
--         For data that is used per project, add it to the "2.create_table" file.
--

\set auth_schema 'auth'
CREATE SCHEMA IF NOT EXISTS :auth_schema;

START TRANSACTION;

create table IF NOT EXISTS :auth_schema.project(
	id                          serial primary key,
    name                        VARCHAR(128),
	email                       VARCHAR(128),
	unique(name),
	unique(email)
);

CREATE TABLE IF NOT EXISTS :auth_schema.languages(
    id                          SERIAL PRIMARY KEY,
    name                        VARCHAR(40),
	code						CHAR(2),
    UNIQUE(name, code)
);

CREATE TABLE IF NOT EXISTS :auth_schema.time_formats(
    id                          SERIAL PRIMARY KEY,
    format                      VARCHAR(40),
    UNIQUE(format)
);

CREATE TABLE IF NOT EXISTS :auth_schema.currencies(
    id                          SERIAL PRIMARY KEY,
    name	                    VARCHAR(40),
    currency_code	            CHAR(3),
    symbol	                    CHAR(1),
    UNIQUE(name, currency_code, symbol)
);

CREATE TABLE IF NOT EXISTS :auth_schema.decimal_separators(
    id                          INT,
    separator	                CHAR(1),
    UNIQUE(id),
    UNIQUE(separator)
);

CREATE TABLE IF NOT EXISTS :auth_schema.locations (
    id int primary key,
    name varchar(80),
    alpha3 char(3),
    country_calling_code varchar(32),
    emoji text,
    UNIQUE (id, name, alpha3)
);

CREATE TABLE IF NOT EXISTS :auth_schema.user(
	id                          serial primary key,
	name                        VARCHAR(40),
    display_name                VARCHAR(255),
	username                    VARCHAR(40),
    title                       VARCHAR(100),
    department                  VARCHAR(100),
    organization                VARCHAR(100),
	email                       VARCHAR(40),
	phone                       VARCHAR(40),
	password                    VARCHAR(100),
	reset_token                 VARCHAR(100),
    project_id             		INT references :auth_schema.project(id),
	password_reset_needed 		BOOLEAN,
	secret_2fa                  VARCHAR(100),
    password_last_changed	    TIMESTAMPTZ,
    language	                INT REFERENCES :auth_schema.languages(id),
    time_format	                INT REFERENCES :auth_schema.time_formats(id),
    location	                INT REFERENCES :auth_schema.locations(id),
    timezone	                VARCHAR(100),
    currency	                INT REFERENCES :auth_schema.currencies(id),
    decimal_separator           INT REFERENCES :auth_schema.decimal_separators(id),
	enable_2fa                  BOOLEAN,
    provider                    VARCHAR(255),
	provider_id                 VARCHAR(255),
    modified_datetime           TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    created_datetime            TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    unique(name),
	unique(email),
	unique(username)
);

CREATE TABLE IF NOT EXISTS :auth_schema.user_profile_pictures(
    id INT REFERENCES :auth_schema.user(id),
    image_file BYTEA,
    modified_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(id)
);

create table IF NOT EXISTS :auth_schema.role(
	id                          serial primary key,
	name                        VARCHAR(40),
	unique(name)
);

create table IF NOT EXISTS :auth_schema.user_project_role(
	user_id                     INT references :auth_schema.user(id),
	project_id                  INT references :auth_schema.project(id),
	role_id                     INT references :auth_schema.role(id),
	unique(user_id, project_id, role_id)
);

create table IF NOT EXISTS :auth_schema.user_role(	
	user_id                     INT references :auth_schema.user(id),	
	role_id                     INT references :auth_schema.role(id),	
	unique(user_id, role_id)	
);
create table IF NOT EXISTS :auth_schema.permission(
	id                          serial primary key,
	name                        VARCHAR(40),
	unique(name)
);
-- version: v2020.3.0
-- add columns: metric_name,metric_description, metric_help

CREATE TABLE IF NOT EXISTS :auth_schema.resource(
    id                          INT,
    parent_id                   INT,
    name                        VARCHAR(60),
    metric_name                 varchar(64),
    metric_description          varchar(128),
    metric_help                 varchar(128),
    UNIQUE(id),
    UNIQUE(parent_id, name),
    UNIQUE(metric_name)
);
-- version
CREATE TABLE IF NOT EXISTS :auth_schema.version(
    id                          serial primary key,
    version                     varchar(64),
	create_timestamptz          timestamptz default current_timestamp,
	update_timestamptz          timestamptz
);

CREATE TABLE IF NOT EXISTS :auth_schema.extension_registration_requests (
    id serial PRIMARY KEY,
    source varchar(255),
    payload jsonb,
    created_on timestamptz DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS :auth_schema.frontend_extensions (
    id serial PRIMARY KEY,
    version varchar(100),
    namespace varchar(100),
    extension_name varchar(255),
    author varchar(255),
    type varchar(100),
    app_route varchar(255),
    external_url varchar(255),
    created_on timestamptz DEFAULT CURRENT_TIMESTAMP,
    modified_on timestamptz DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (namespace, app_route),
    UNIQUE (version, extension_name)
);

-- add for v1.9.0
CREATE TABLE IF NOT EXISTS :auth_schema.menu_item(
    id                          INT,
    parent_id                   INT NOT NULL DEFAULT 0,
    title                       VARCHAR (64) NOT NULL,
    order_id                    INT NOT NULL,
    title_type                  VARCHAR(4) NOT NULL,
    placement_location          VARCHAR(12) NOT NULL,
    url_path                    VARCHAR(128),
    icon_path                   TEXT,
    create_timestamptz          TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    update_timestamptz          TIMESTAMPTZ,
    resource_id                 INT REFERENCES :auth_schema.resource(id),
    iframe                      TEXT,
    attributes                  TEXT,
    extension_id                INT REFERENCES :auth_schema.frontend_extensions(id)
);

-- commit_log
CREATE TABLE IF NOT EXISTS :auth_schema.commit_log(
    id serial primary key,
    container_type  varchar(16) not null,
    application_version varchar (16) not null,
    boot_time timestamp,
    build_id int not null,
    commit_id varchar(16) not null,
    branch varchar(16) not null,
    build_date timestamp,
    create_timestamptz  timestamptz   DEFAULT CURRENT_TIMESTAMP,
    update_timestamptz  timestamptz
);

create table IF NOT EXISTS :auth_schema.role_permission(
	role_id                     INT references :auth_schema.role(id),
	permission_id               INT references :auth_schema.permission(id),
    UNIQUE(role_id, permission_id)
);

-- User, UserGroup, Role, IP, ACL
CREATE TABLE IF NOT EXISTS :auth_schema.authorization_types(
	id                          SERIAL PRIMARY KEY,
    type                        VARCHAR(40),
	UNIQUE(type)
);

CREATE TABLE IF NOT EXISTS :auth_schema.user_groups(
    id                          SERIAL PRIMARY KEY,
    group_name                  VARCHAR(100),
	UNIQUE(group_name)
);

CREATE TABLE IF NOT EXISTS :auth_schema.user_group_project_roles(
    user_group_id               INT REFERENCES :auth_schema.user_groups(id),
    project_id                  INT REFERENCES :auth_schema.project(id),
    role_id                     INT REFERENCES :auth_schema.role(id),
    UNIQUE(user_group_id, project_id, role_id)
);

CREATE TABLE IF NOT EXISTS :auth_schema.user_group_users(
    user_group_id	            INT REFERENCES :auth_schema.user_groups(id),
    user_id	                    INT REFERENCES :auth_schema.user(id),
    UNIQUE(user_group_id, user_id)
);

CREATE TABLE IF NOT EXISTS :auth_schema.status_types(
    id                          SERIAL PRIMARY KEY,
    status                      VARCHAR(40),
    UNIQUE(status)
);

CREATE TABLE IF NOT EXISTS :auth_schema.record_types(
    id	                        SERIAL PRIMARY KEY,
    type                        VARCHAR(40),
    UNIQUE(type)
);

-- e.g. route, menu, data, action, operation
CREATE TABLE IF NOT EXISTS :auth_schema.authorization_object_types(
    id	                        SERIAL PRIMARY KEY,
    name	                    VARCHAR(40),
    UNIQUE(name)
);

CREATE TABLE IF NOT EXISTS :auth_schema.authorization_directions(
    id                          SERIAL PRIMARY KEY,
    name                        VARCHAR(40),
    UNIQUE(name)
);

CREATE TABLE IF NOT EXISTS :auth_schema.authorizations(
    id          	            SERIAL PRIMARY KEY,
    namespace	                VARCHAR(100),
    project_id	                INT REFERENCES :auth_schema.project(id),
    -- tells you the authorization object type this is. depending on this value you should decide
    -- into which "extensions" table to :auth_schemaok into for records
    object_id	                INT REFERENCES :auth_schema.authorization_object_types(id),
    resource_id                 INT REFERENCES :auth_schema.resource(id),
    name	                    VARCHAR(100),
    subname	                    VARCHAR(100),
    -- The type be:auth_schemanging to this ID tells you what type of object_value to expect
    -- e.g. authorization_types.name == "user"? expect a "user_id" in the "object_value"
    type_id	                    INT REFERENCES :auth_schema.authorization_types(id),
    object_value	            INT, -- can be a reference to user_id, user_group_id, role_id, others...
    direction_id	            INT REFERENCES :auth_schema.authorization_directions(id),
    sequence                    INT,
    status_id	                INT REFERENCES :auth_schema.status_types(id),
    record_type_id	            INT REFERENCES :auth_schema.record_types(id),
    modified_datetime           TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    created_datetime            TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(namespace, project_id, resource_id, object_id, type_id, object_value, direction_id, sequence, status_id, record_type_id)
);

CREATE TABLE IF NOT EXISTS :auth_schema.authorization_menu_extension_types(
    id          	            SERIAL PRIMARY KEY,
    mode	                    VARCHAR(40),
    UNIQUE(mode)
);

CREATE TABLE IF NOT EXISTS :auth_schema.authorization_menu_extensions(
    authorization_id	        INT REFERENCES :auth_schema.authorizations(id),
    mode_id	                    INT REFERENCES :auth_schema.authorization_menu_extension_types(id),
    UNIQUE(authorization_id, mode_id)
);

CREATE TABLE IF NOT EXISTS :auth_schema.authorization_route_extension_types(
    id          	            SERIAL PRIMARY KEY,
    http_method	                VARCHAR(40),
    UNIQUE(http_method)
);

CREATE TABLE IF NOT EXISTS :auth_schema.authorization_route_extensions(
    authorization_id	        INT REFERENCES :auth_schema.authorizations(id),
    http_method_id              INT REFERENCES :auth_schema.authorization_route_extension_types(id),
    UNIQUE(authorization_id, http_method_id)
);

CREATE TABLE IF NOT EXISTS :auth_schema.authorization_data_extension_types(
    id          	            SERIAL PRIMARY KEY,
    operation                   VARCHAR(40),
    UNIQUE(operation)
);

CREATE TABLE IF NOT EXISTS :auth_schema.authorization_data_extensions(
    authorization_id	        INT REFERENCES :auth_schema.authorizations(id),
    operation_id                INT REFERENCES :auth_schema.authorization_data_extension_types(id),
    UNIQUE(authorization_id, operation_id)
);

CREATE TABLE IF NOT EXISTS :auth_schema.authorization_action_extension_types(
    id          	            SERIAL PRIMARY KEY,
    display                     VARCHAR(40),
    UNIQUE(display)
);

CREATE TABLE IF NOT EXISTS :auth_schema.authorization_action_extensions(
    authorization_id	        INT REFERENCES :auth_schema.authorizations(id),
    display_id                  INT REFERENCES :auth_schema.authorization_action_extension_types(id),
    UNIQUE(authorization_id, display_id)
);

CREATE TABLE IF NOT EXISTS :auth_schema.authorization_operation_extension_types(
    id          	            SERIAL PRIMARY KEY,
    operation                   VARCHAR(40),
    UNIQUE(operation)
);

CREATE TABLE IF NOT EXISTS :auth_schema.authorization_operation_extensions(
    authorization_id	        INT REFERENCES :auth_schema.authorizations(id),
    operation_id                INT REFERENCES :auth_schema.authorization_operation_extension_types(id),
    UNIQUE(authorization_id, operation_id)
);
 CREATE TABLE IF NOT EXISTS :auth_schema.api_key (
        id serial not null,
        key_name varchar(64) not null,
        user_id integer not null REFERENCES :auth_schema.user(id),
        access_key varchar(32) not null,
        access_secret_key varchar(128) not null,
        key_create_timestamptz timestamp not null,
        key_update_timestamptz timestamp not null,
        key_expired_on timestamp,
        access_role_id varchar(32) not null,
        status varchar(16) not null,
        primary key (id)
);

CREATE TABLE IF NOT EXISTS :auth_schema.user_settings(
    id	                            SERIAL PRIMARY KEY,
    user_id	                        INT,
    settings_type	                INT,
    target_id	                    INT,
    settings_json	                JSONB,
    UNIQUE(user_id, settings_type, target_id)
);

CREATE TABLE IF NOT EXISTS :auth_schema.settings_types(
    id	                            INT PRIMARY KEY,
    type                            VARCHAR(50),
    UNIQUE(type)
);

-- Add audit columns for v2020.2.0 release
--------------
-- record_type  varchar  (64) -- LO Configuration, Systemsetting, ….
-- record_status varchar (32) -- active, inactive, logical deleted …
-- last_update_timestamptz  timestamptz
-- last_update_user int -- user id
--------------
-- 1. add record_type column
do $$
declare
    auth_schema VARCHAR(10) := 'auth';
    selectrow record;
begin
for selectrow in
 select
      'ALTER TABLE '|| auth_schema ||'.'|| T.targettable || ' ADD COLUMN IF NOT EXISTS record_type varchar(64) NULL; ' as script

   from
      (
        select tablename as targettable from  pg_tables where schemaname  = auth_schema 
      ) T
loop
execute selectrow.script;
end loop;
end;
$$;
-- 2. add record_status column
do $$
declare
    selectrow record;
    auth_schema VARCHAR(10) := 'auth';
begin
for selectrow in
 select
      'ALTER TABLE '|| auth_schema ||'.'|| T.targettable || ' ADD COLUMN IF NOT EXISTS record_status varchar(32) NULL; ' as script
   from
      (
        select tablename as targettable from  pg_tables where schemaname  = auth_schema 
      ) T
loop
execute selectrow.script;
end loop;
end;
$$;
-- 3. add last_update_timestamptz column
do $$
declare
    selectrow record;
    auth_schema VARCHAR(10) := 'auth';
begin
for selectrow in
select
      'ALTER TABLE '|| auth_schema ||'.'|| T.targettable || ' ADD COLUMN IF NOT EXISTS last_update_timestamptz timestamptz NULL' as script
   from
      (
        select tablename as targettable from  pg_tables where schemaname = auth_schema 
      ) t
loop
execute selectrow.script;
end loop;
end;
$$;
-- 4. add last_update_user column
do $$
declare
    selectrow record;
    auth_schema VARCHAR(10) := 'auth';
begin
for selectrow in
select
      'ALTER TABLE '|| auth_schema ||'.'|| T.targettable ||  ' ADD COLUMN  IF NOT EXISTS last_update_user int  NULL' as script
   from
      (
        select tablename as targettable from  pg_tables where schemaname = auth_schema 
      ) t
loop
execute selectrow.script;
end loop;
end;
$$;
-- End add columns for v2020.2.0 release
-- For any objects that is added after v1.9.0, please add these audit columns to table object:
-- record_type  varchar  (64) -- LO Configuration, Systemsetting, ….
-- record_status varchar (32) -- active, inactive, logical deleted …
-- last_update_timestamptz  timestamptz
-- last_update_user int -- user id

-- Note: Release v2020.2.0.autojoin related tables have moved to 2.create_tables.sql 
-- becasue they are all in the 'lo' schema 


-- ANCHOR: - Queries for populating the tables

INSERT INTO 
    :auth_schema.resource(id, parent_id, name, metric_name, metric_description, metric_help)
VALUES
    (1, 0, 'home', 'Home', 'Home metrics', null),
    (19, 0, 'process exploration', 'ProcessExploration', 'Process exploration metrics', null),
    (2, 0, 'data wrangling', 'DataWrangling', 'Data wrangling metrics', null),
        (3, 0, 'connectors', 'DataWrangling.Source.Connectors', 'Data wrangling source connector metrics', null),
        (4, 0, 'scenario', 'DataWrangling.Scenario', 'Data wrangling scenario metrics', null),
        (5, 0, 'datasources', 'DataWrangling.datasources', 'Data wrangling data source metrics', null),
        (6, 0, 'load data', 'LoadData', 'Load data metrics', null),
    (7, 0, 'discovery', 'Discovery', 'Discovery metrics', null),
        (8, 0, 'process discovery', 'Discovery.ProcessDiscovery', 'Discovery Discovery metrics', null),
    (9, 0, 'ai', 'AI', 'AI metrics', null),
        (10, 0, 'enrichment', 'AI.Enrichment', 'AI Enrichment metrics', null),
        (22, 0, 'business dictionaries', 'AI.BusinessDictionaries', 'AI Business dictionaries metrics', null),
    (11, 0, 'settings', 'Settings', 'Settings metrics', null),
    (12, 0, 'license manager', 'License.Manager', 'License manager metrics', null),
    (13, 0, 'system manager', 'System.Manager', 'System manager metrics', null),
    (14, 0, 'commit log', 'CommitLog', 'Commit log metric', null),
    (15, 0, 'administration', 'Administration', 'Administration metrics', null),
        (16, 0, 'manage users', 'Administration.ManageUsers', 'Administration Manage users metrics', null),
        (17, 0, 'system configuration', 'Administration.SystemConfiguration', 'Administration System configuration metrics', null),
    (18, 0, 'manage projects', 'ManageProjects', 'Manage projects metrics', null),
    (20, 0, 'configuration', 'Configuration', 'Configuration metrics', null),
        (21, 0, 'authorization','configuration.Authorization', 'configuration Authorization metrics', null),
    (25, 0, 'all', 'All', 'All resource metrics', null);

-- set new version for each release
insert into :auth_schema.version(version) values('2020.3.0');

-- ANCHOR: - menu_item

insert into :auth_schema.menu_item(id, parent_id, title, order_id, title_type, placement_location, url_path, update_timestamptz) values
(1,  0,  'Home',                  1,  'TEXT', 'LEFT', '/',                     now()),
(19, 0,  'Process Exploration',   2,  'TEXT', 'LEFT', '/process-discovery',    now()),
(2,  0,  'Data Wrangling',        5,  'TEXT', 'LEFT', '/',                     now()),
    (3,  2,  'Connectors',            1,  'TEXT', 'LEFT', '/sourcing',             now()),
    (4,  2,  'Scenario',              2,  'TEXT', 'LEFT', '/scenario',             now()),
    (5,  2,  'Datasources',           3,  'TEXT', 'LEFT', '/extraction',           now()),
    (6,  2,  'Load Data',             4,  'TEXT', 'LEFT', '/load-data',            now()),
(7,  0,  'Discovery',             6,  'TEXT', 'LEFT', '/',                     now()),
    (8,  7,  'Process Discovery',     1,  'TEXT', 'LEFT', '/discovery',            now()),
(9, 0,  'AI',                    7,  'TEXT', 'LEFT', '/',                     now()),
    (10, 9,  'Enrichment',            1,  'TEXT', 'LEFT', '/enrichment',           now()),
    (22, 9,  'Business Dictionaries', 2,  'TEXT', 'LEFT', '/business-dictionary',  now()),
(11, 0,  'Settings',              8,  'TEXT', 'TOP',  '/settings',             now()),
(12, 0,  'License Manager',       9,  'TEXT', 'LEFT', '/license-manager',      now()),
(13, 0,  'System Manager',        10, 'TEXT', 'LEFT', '/',                     now()),
(14, 13, 'Commit Log',            11, 'TEXT', 'LEFT', '/commit-log',           now()),
(15, 0,  'Administration',        12, 'TEXT', 'LEFT', '/',                     now()),
    (16, 15, 'Manage Users',          1,  'TEXT', 'LEFT', '/manage-users',         now()),
    (17, 15, 'System Configuration',  2,  'TEXT', 'LEFT', '/system-configuration', now()),
(18, 0,  'Manage Projects',       13, 'TEXT', 'LEFT', '/projects',             now()),
(20, 0,  'Configuration',         14, 'TEXT', 'LEFT', '/',                     now()),
    (21, 20, 'Authorization',         1, 'TEXT', 'LEFT', '/configuration',        now())
;

-- Insert icons into menu items
UPDATE :auth_schema.menu_item SET icon_path = '<svg width="17px" height="18px" viewBox="0 0 17 18" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"><g id="Page-1" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd"><g id="Homeicon" fill="#45C197"><path d="M9.378,0.30837 L16.4899,5.85711 C16.7874,6.08921 16.9617,6.44637 16.9617,6.82437 L16.9617,15.831 C16.9617,16.5084 16.4122,17.0578 15.7348,17.0578 L12.3243,17.0578 C11.6469,17.0578 11.0975,16.5084 11.0975,15.831 L11.0975,11.6711 C11.0975,10.9937 10.548,10.4443 9.8697,10.4443 L7.0693,10.4443 C6.3919,10.4443 5.84241,10.9937 5.84241,11.6711 L5.84241,15.831 C5.84241,16.5084 5.29295,17.0578 4.61463,17.0578 L1.22683,17.0578 C0.54946,17.0578 0,16.5084 0,15.831 L0,6.82437 C0,6.44637 0.1743,6.08921 0.47178,5.85711 L7.5837,0.30837 C8.1114,-0.10279 8.8503,-0.10279 9.378,0.30837 Z" id="Path"></path></g></g></svg >'
    WHERE id = (SELECT id FROM :auth_schema.menu_item WHERE title = 'Home');
UPDATE :auth_schema.menu_item SET icon_path = '<svg width="16px" height="20px" viewBox="0 0 16 20" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"><g id="Page-1" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd"><g id="Loadata" fill="#45C197" fill-rule="nonzero"><path d="M1.86666667,4.4691358 C3.44242424,5.16049383 5.64848485,5.55555556 7.92727273,5.55555556 C10.2060606,5.55555556 12.4363636,5.16049383 13.9878788,4.4691358 C14.6181818,4.17283951 15.6121212,3.80246914 15.8060606,3.03703704 C15.8545455,2.79012346 15.8545455,2.56790123 15.7575758,2.39506173 C15.4909091,1.75308642 14.5939394,1.38271605 14.0363636,1.13580247 C12.4848485,0.395061728 10.2545455,0 7.97575758,0 C5.6969697,0 3.53939394,0.395061728 1.96363636,1.11111111 C1.30909091,1.40740741 0.436363636,1.82716049 0.218181818,2.61728395 C-0.096969697,3.60493827 1.13939394,4.12345679 1.86666667,4.4691358 Z" id="Path"></path><path d="M15.7818182,13.8765432 C15.3939394,14.1728395 14.9333333,14.4691358 14.3757576,14.7160494 C12.7030303,15.4567901 10.3757576,15.9012346 7.97575758,15.9012346 C5.55151515,15.9012346 3.22424242,15.4814815 1.55151515,14.7407407 C1.11515152,14.5432099 0.63030303,14.2716049 0.16969697,13.9259259 L0.16969697,17.4567901 C0.436363636,17.8518519 1.06666667,18.2962963 1.89090909,18.691358 C3.46666667,19.382716 5.67272727,19.7777778 7.97575758,19.7777778 C10.2787879,19.7777778 12.4848485,19.382716 14.0363636,18.691358 C14.9575758,18.2716049 15.5636364,17.7777778 15.830303,17.3333333 L15.830303,13.8765432 C15.8545455,13.8518519 15.8060606,13.8765432 15.7818182,13.8765432 Z" id="Shape"></path><path d="M14.569697,5.18518519 L14.4242424,5.25925926 C12.7515152,6 10.4242424,6.41975309 8,6.41975309 C5.57575758,6.41975309 3.22424242,6 1.57575758,5.25925926 L1.52727273,5.2345679 C1.13939394,5.0617284 0.63030303,4.81481481 0.16969697,4.4691358 L0.16969697,8 C0.436363636,8.39506173 1.06666667,8.83950617 1.89090909,9.20987654 C3.46666667,9.90123457 5.67272727,10.2716049 7.97575758,10.2716049 C10.2545455,10.2716049 12.4848485,9.90123457 14.0363636,9.18518519 C14.9575758,8.7654321 15.5636364,8.2962963 15.830303,7.85185185 L15.830303,4.49382716 C15.4424242,4.81481481 14.9333333,5.03703704 14.569697,5.18518519 Z" id="Shape"></path><path d="M14.4,10 C12.7272727,10.7407407 10.4484848,11.1604938 8,11.1604938 C5.5030303,11.1604938 3.22424242,10.7407407 1.57575758,10.0246914 C1.01818182,9.77777778 0.557575758,9.50617284 0.193939394,9.2345679 L0.193939394,12.691358 C0.460606061,13.1111111 1.09090909,13.5555556 1.91515152,13.9259259 C3.49090909,14.617284 5.6969697,15.0123457 8,15.0123457 C10.3030303,15.0123457 12.5090909,14.617284 14.0606061,13.9012346 C14.9818182,13.4814815 15.5878788,12.9876543 15.8545455,12.5432099 L15.8545455,9.20987654 C15.7818182,9.25925926 15.6848485,9.30864198 15.5878788,9.35802469 C15.2484848,9.58024691 14.8363636,9.80246914 14.4,10 Z" id="Shape"></path></g></g></svg >'
    WHERE id = (SELECT id FROM :auth_schema.menu_item WHERE title = 'Data Wrangling');
UPDATE :auth_schema.menu_item SET icon_path = '<svg width="18px" height="18px" viewBox="0 0 18 18" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"><g id="Page-1" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd"><g id="SourcingIcon" fill="#45C197"><path d="M11.25,6.75 L6.75,6.75 C6.45163,6.75 6.16548,6.63147 5.9545,6.4205 C5.74353,6.20952 5.625,5.92337 5.625,5.625 C5.625,5.32663 5.74353,5.04048 5.9545,4.8295 C6.16548,4.61853 6.45163,4.5 6.75,4.5 L11.25,4.5 C11.5484,4.5 11.8345,4.61853 12.0455,4.8295 C12.2565,5.04048 12.375,5.32663 12.375,5.625 C12.375,5.92337 12.2565,6.20952 12.0455,6.4205 C11.8345,6.63147 11.5484,6.75 11.25,6.75 Z M4.5,9 C4.5,8.7016 4.61853,8.4155 4.8295,8.2045 C5.04048,7.9935 5.32663,7.875 5.625,7.875 L12.375,7.875 C12.6734,7.875 12.9595,7.9935 13.1705,8.2045 C13.3815,8.4155 13.5,8.7016 13.5,9 C13.5,9.2984 13.3815,9.5845 13.1705,9.7955 C12.9595,10.0065 12.6734,10.125 12.375,10.125 L5.625,10.125 C5.32663,10.125 5.04048,10.0065 4.8295,9.7955 C4.61853,9.5845 4.5,9.2984 4.5,9 Z M13.5,2.3085 L13.5,2.21475 L4.5,2.21475 L4.5,2.3085 L2.55,12.3405 L6.75,12.3405 L6.75,13.5 C6.75,13.7984 6.86853,14.0845 7.0795,14.2955 C7.2905,14.5065 7.5766,14.625 7.875,14.625 L10.125,14.625 C10.4234,14.625 10.7095,14.5065 10.9205,14.2955 C11.1315,14.0845 11.25,13.7984 11.25,13.5 L11.25,12.3405 L15.45,12.3405 L13.5,2.3085 Z M18,12.375 L18,15.75 C18,16.3467 17.7629,16.919 17.341,17.341 C16.919,17.7629 16.3467,18 15.75,18 L2.25,18 C1.65326,18 1.08097,17.7629 0.65901,17.341 C0.23705,16.919 0,16.3467 0,15.75 L0,12.375 L2.25,2.25 C2.56575,1.07775 3.25725,0 4.5,0 L13.5,0 C14.7435,0 15.3975,1.1475 15.75,2.25 L18,12.375 Z" id="Shape"></path></g></g></svg >'
    WHERE id = (SELECT id FROM :auth_schema.menu_item WHERE title = 'Connectors');
UPDATE :auth_schema.menu_item SET icon_path = '<svg width="20px" height="20px" viewBox="0 0 20 20" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"><g id="Page-1" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd"><g id="ScenarioIcon" stroke="#45C197"><path d="M0.83337,1.34081 C0.83337,1.20622 0.88684,1.07713 0.98202,0.98196 C1.07719,0.88678 1.20628,0.83331 1.34087,0.83331 L18.5959,0.83331 C18.7305,0.83331 18.8596,0.88678 18.9547,0.98196 C19.0499,1.07713 19.1034,1.20622 19.1034,1.34081 L19.1034,16.0583 C19.1034,16.8659 18.7826,17.6404 18.2115,18.2115 C17.6405,18.7825 16.866,19.1033 16.0584,19.1033 L1.34087,19.1033 C1.20628,19.1033 1.07719,19.0498 0.98202,18.9547 C0.88684,18.8595 0.83337,18.7304 0.83337,18.5958 L0.83337,1.34081 Z" id="Path" stroke-width="1.5"></path><path d="M1.34082,4.89331 L18.5958,4.89331" id="Path" stroke-width="1.2"></path><path d="M5.90833,19.1033 L5.90833,1.84833" id="Path" stroke-width="1.2"></path><path d="M1.34082,7.93835 L18.5958,7.93835" id="Path" stroke-width="1.2"></path></g></g></svg >'
    WHERE id = (SELECT id FROM :auth_schema.menu_item WHERE title = 'Scenario');
UPDATE :auth_schema.menu_item SET icon_path = '<svg width="20px" height="22px" viewBox="0 0 20 22" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"><g id="Page-1" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd"><g id="ExtractionIcon" transform="translate(0.000000, 1.000000)"><polygon id="Path" fill="#45C197" fill-rule="nonzero" points="9.999 10.0009 0.90857 4.99955 9.999 0 19.0894 4.99955"></polygon><polygon id="Path" fill="#45C197" fill-rule="nonzero" points="0 9.9919 2.27351 8.1818 10.0009 12.2726 17.2722 8.1818 19.5457 9.5448 10.0009 15.0005"></polygon><polygon id="Path" stroke="#45C197" points="9.999 10.0009 0.90857 4.99955 9.999 0 19.0894 4.99955"></polygon><polygon id="Path" stroke="#45C197" points="0 9.9919 2.27351 8.1818 10.0009 12.2726 17.2722 8.1818 19.5457 9.5448 10.0009 15.0005"></polygon><polygon id="Path" stroke="#45C197" fill="#45C197" fill-rule="nonzero" points="9.9991 17.274 2.72785 13.6375 0.45435 15.0005 9.9991 20 19.5457 14.5425 17.2722 13.6375"></polygon> </g></g></svg >'
    WHERE id = (SELECT id FROM :auth_schema.menu_item WHERE title = 'Datasources');
UPDATE :auth_schema.menu_item SET icon_path = '<svg width="20px" height="17px" viewBox="0 0 20 17" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"><g id="Page-1" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd"><g id="LoaddataIcon" fill="#45C197" fill-rule="nonzero"><path d="M0.85592,5.98291 L0.76431,5.98291 C0.56164,6.00524 0.37458,6.09966 0.23906,6.24804 C0.10354,6.39642 0.0291,6.58831 0.0300312051,6.78686 L0.0300312051,10.2103 C0.02973,10.4086 0.10439,10.6002 0.23979,10.7485 C0.3752,10.8967 0.56189,10.9913 0.76431,11.0142 L19.2027,11.0142 C19.4054,10.9919 19.5925,10.8975 19.728,10.7491 C19.8635,10.6007 19.9379,10.4088 19.9370081,10.2103 L19.9370081,6.78686 C19.9373,6.58848 19.8627,6.39693 19.7272,6.24867 C19.5918,6.10042 19.4051,6.00583 19.2027,5.98291 L0.85592,5.98291 Z M2.78249,10.0013 C2.48015,10.0013 2.1846,9.914 1.93321,9.7505 C1.68182,9.587 1.48589,9.3546 1.37019,9.0827 C1.25449,8.8107 1.22422,8.5115 1.2832,8.2229 C1.34218,7.9342 1.48777,7.6691 1.70156,7.461 C1.91535,7.2529 2.18773,7.1111 2.48426,7.0537 C2.78079,6.99629 3.08816,7.0258 3.36748,7.1384 C3.64681,7.251 3.88555,7.4418 4.05353,7.6865 C4.2215,7.9312 4.31115,8.2189 4.31115,8.5132 C4.31002,8.9075 4.1486,9.2854 3.86217,9.5642 C3.57573,9.843 3.18757,10.0002 2.78249,10.0013 L2.78249,10.0013 Z M16.6034,8.9591 L7.12372,8.9591 C7.00205,8.9591 6.88537,8.912 6.79934,8.8283 C6.71331,8.7445 6.66498,8.6309 6.66498,8.5125 C6.66498,8.3941 6.71331,8.2805 6.79934,8.1967 C6.88537,8.113 7.00205,8.0659 7.12372,8.0659 L16.6034,8.0659 C16.7251,8.0659 16.8418,8.113 16.9278,8.1967 C17.0138,8.2805 17.0622,8.3941 17.0622,8.5125 C17.0622,8.6309 17.0138,8.7445 16.9278,8.8283 C16.8418,8.912 16.7251,8.9591 16.6034,8.9591 L16.6034,8.9591 Z" id="Shape"></path><path d="M0.85592,11.9367 L0.76431,11.9367 C0.56164,11.959 0.37458,12.0535 0.23906,12.2018 C0.10354,12.3502 0.0291,12.5421 0.0300312051,12.7407 L0.0300312051,16.1641 C0.0300312051,16.3858 0.12052,16.5984 0.28157,16.7552 C0.44263,16.912 0.66107,17.0001 0.88884,17.0001 L19.1412,17.0001 C19.254,17.0001 19.3656,16.9784 19.4698,16.9364 C19.574,16.8944 19.6687,16.8328 19.7484,16.7552 C19.8282,16.6776 19.8914,16.5854 19.9346,16.484 C19.9778,16.3826 20.0000009,16.2739 20.0000009,16.1641 L20.0000009,12.7407 C20.0003,12.5423 19.9256,12.3507 19.7902,12.2025 C19.6548,12.0542 19.4681,11.9596 19.2657,11.9367 L0.85592,11.9367 Z M2.78249,15.9551 C2.48015,15.9551 2.1846,15.8678 1.93321,15.7043 C1.68182,15.5408 1.48589,15.3084 1.37019,15.0365 C1.25449,14.7645 1.22422,14.4653 1.2832,14.1767 C1.34218,13.888 1.48777,13.6229 1.70156,13.4148 C1.91535,13.2067 2.18773,13.0649 2.48426,13.0075 C2.78079,12.9501 3.08816,12.9796 3.36748,13.0922 C3.64681,13.2048 3.88555,13.3956 4.05352,13.6403 C4.2215,13.885 4.31115,14.1727 4.31115,14.467 C4.31002,14.8613 4.1486,15.2392 3.86216,15.518 C3.57573,15.7968 3.18757,15.954 2.78249,15.9551 Z M16.6034,14.9129 L7.12372,14.9129 C7.00205,14.9129 6.88537,14.8658 6.79934,14.7821 C6.71331,14.6983 6.66498,14.5847 6.66498,14.4663 C6.66498,14.3479 6.71331,14.2343 6.79934,14.1505 C6.88537,14.0668 7.00205,14.0197 7.12372,14.0197 L16.6034,14.0197 C16.7251,14.0197 16.8418,14.0668 16.9278,14.1505 C17.0138,14.2343 17.0622,14.3479 17.0622,14.4663 C17.0622,14.5847 17.0138,14.6983 16.9278,14.7821 C16.8418,14.8658 16.7251,14.9129 16.6034,14.9129 L16.6034,14.9129 Z" id="Shape"></path><path d="M2.78244,3.15444 C3.11999,3.15444 3.39362,2.88807 3.39362,2.55949 C3.39362,2.23091 3.11999,1.96454 2.78244,1.96454 C2.4449,1.96454 2.17126,2.23091 2.17126,2.55949 C2.17126,2.88807 2.4449,3.15444 2.78244,3.15444 Z" id="Path"></path><path d="M2.78244,15.0605 C3.11999,15.0605 3.39362,14.7941 3.39362,14.4656 C3.39362,14.137 3.11999,13.8706 2.78244,13.8706 C2.4449,13.8706 2.17126,14.137 2.17126,14.4656 C2.17126,14.7941 2.4449,15.0605 2.78244,15.0605 Z" id="Path"></path><path d="M2.78244,9.1082 C3.11999,9.1082 3.39362,8.8418 3.39362,8.5132 C3.39362,8.1846 3.11999,7.9183 2.78244,7.9183 C2.4449,7.9183 2.17126,8.1846 2.17126,8.5132 C2.17126,8.8418 2.4449,9.1082 2.78244,9.1082 Z" id="Path"></path><path d="M19.937,4.28588 L19.937,0.836 C19.937,0.61428 19.8465,0.40164 19.6855,0.24486 C19.5244,0.08808 19.306,0 19.0782,0 L0.8588,0 C0.63103,0 0.41259,0.08808 0.25154,0.24486 C0.09048,0.40164 -9.61510349e-07,0.61428 -9.61510349e-07,0.836 L-9.61510349e-07,4.25941 C-0.00031,4.45778 0.07435,4.64934 0.20975,4.79759 C0.34516,4.94585 0.53185,5.04044 0.73427,5.06336 L19.1727,5.06336 C19.378,5.05339 19.5716,4.96727 19.7138,4.82268 C19.8559,4.67809 19.9358,4.48601 19.937,4.28588 Z M2.78251,4.04762 C2.48017,4.04762 2.18462,3.96035 1.93323,3.79683 C1.68184,3.63332 1.48591,3.40092 1.37021,3.12901 C1.25451,2.8571 1.22424,2.55789 1.28322,2.26924 C1.3422,1.98058 1.4878,1.71543 1.70158,1.50732 C1.91537,1.29921 2.18775,1.15748 2.48428,1.10006 C2.78082,1.04265 3.08818,1.07212 3.3675,1.18474 C3.64683,1.29737 3.88558,1.4881 4.05355,1.73281 C4.22152,1.97753 4.31117,2.26523 4.31117,2.55954 C4.31004,2.95387 4.14862,3.33173 3.86219,3.61056 C3.57575,3.88938 3.18759,4.04652 2.78251,4.04762 L2.78251,4.04762 Z M16.6034,3.0068 L7.12517,3.0068 C7.0035,3.0068 6.88682,2.95976 6.80079,2.87601 C6.71476,2.79226 6.66643,2.67868 6.66643,2.56024 C6.66643,2.44181 6.71476,2.32822 6.80079,2.24447 C6.88682,2.16073 7.0035,2.11368 7.12517,2.11368 L16.6034,2.11368 C16.7251,2.11368 16.8418,2.16073 16.9278,2.24447 C17.0139,2.32822 17.0622,2.44181 17.0622,2.56024 C17.0622,2.67868 17.0139,2.79226 16.9278,2.87601 C16.8418,2.95976 16.7251,3.0068 16.6034,3.0068 L16.6034,3.0068 Z" id="Shape"></path></g></g></svg >'
    WHERE id = (SELECT id FROM :auth_schema.menu_item WHERE title = 'Load Data');
UPDATE :auth_schema.menu_item SET icon_path = '<svg width="21px" height="22px" viewBox="0 0 21 22" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"><g id="Page-1" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd" stroke-linecap="round" stroke-linejoin="round"><g id="DiscoveryIcon" transform="translate(1.000000, 1.000000)" stroke="#45C197" stroke-width="0.8"><path d="M3.00623391e-06,0.90887 L3.00623391e-06,19.5456 C-0.00033,19.6049 0.01173,19.6638 0.03548,19.7187 C0.05922,19.7737 0.0942,19.8237 0.13842,19.8659 C0.18263,19.9081 0.23521,19.9417 0.29316,19.9647 C0.3511,19.9877 0.41328,19.9997 0.47614,20 L20.000003,20" id="Path"></path><path d="M2.8542,17.7278 L3.80646,17.7278 C3.86932,17.7275 3.93149,17.7155 3.98944,17.6925 C4.04738,17.6695 4.09996,17.6359 4.14418,17.5937 C4.18839,17.5515 4.22337,17.5015 4.24712,17.4466 C4.27087,17.3916 4.28292,17.3327 4.2825966,17.2734 L4.2825966,15.4544 C4.28292,15.3951 4.27087,15.3362 4.24712,15.2813 C4.22337,15.2263 4.18839,15.1763 4.14418,15.1341 C4.09996,15.0919 4.04738,15.0583 3.98944,15.0353 C3.93149,15.0123 3.86932,15.0003 3.80646,15 L2.8542,15 C2.79134,15.0003 2.72916,15.0123 2.67122,15.0353 C2.61327,15.0583 2.56069,15.0919 2.51648,15.1341 C2.47226,15.1763 2.43728,15.2263 2.41354,15.2813 C2.38979,15.3362 2.37774,15.3951 2.37805491,15.4544 L2.37805491,17.2722 C2.37757,17.3317 2.3895,17.3906 2.41317,17.4457 C2.43685,17.5008 2.4718,17.551 2.51603,17.5933 C2.56026,17.6356 2.61289,17.6693 2.67092,17.6924 C2.72895,17.7155 2.79123,17.7275 2.8542,17.7278 L2.8542,17.7278 Z" id="Path" fill="#45C197"></path><path d="M7.14313,17.7231 L8.0941,17.7231 C8.157,17.7227 8.2192,17.7107 8.2771,17.6877 C8.3351,17.6647 8.3876,17.6312 8.4319,17.589 C8.4761,17.5468 8.511,17.4968 8.5348,17.4418 C8.5585,17.3868 8.5706,17.328 8.57030544,17.2686 L8.57030544,12.2722 C8.5706,12.2128 8.5585,12.154 8.5348,12.099 C8.511,12.044 8.4761,11.994 8.4319,11.9518 C8.3876,11.9096 8.3351,11.8761 8.2771,11.8531 C8.2192,11.8301 8.157,11.8181 8.0941,11.8177 L7.14313,11.8177 C7.08027,11.8181 7.0181,11.8301 6.96015,11.8531 C6.9022,11.8761 6.84962,11.9096 6.80541,11.9518 C6.7612,11.994 6.72622,12.044 6.70247,12.099 C6.67872,12.154 6.66667,12.2128 6.6669934,12.2722 L6.6669934,17.2686 C6.66667,17.328 6.67872,17.3868 6.70247,17.4418 C6.72622,17.4968 6.7612,17.5468 6.80541,17.589 C6.84962,17.6312 6.9022,17.6647 6.96015,17.6877 C7.0181,17.7107 7.08027,17.7227 7.14313,17.7231 L7.14313,17.7231 Z" id="Path" fill="#45C197"></path><path d="M11.4297,17.7278 L12.382,17.7278 C12.4449,17.7275 12.507,17.7155 12.565,17.6925 C12.6229,17.6695 12.6755,17.636 12.7197,17.5938 C12.7639,17.5516 12.7989,17.5016 12.8227,17.4466 C12.8464,17.3916 12.8585,17.3328 12.8581096,17.2734 L12.8581096,9.0912 C12.8585,9.0318 12.8464,8.9729 12.8227,8.918 C12.7989,8.863 12.7639,8.813 12.7197,8.7708 C12.6755,8.7286 12.6229,8.695 12.565,8.672 C12.507,8.649 12.4449,8.637 12.382,8.6367 L11.4297,8.6367 C11.3669,8.637 11.3047,8.649 11.2468,8.672 C11.1888,8.695 11.1362,8.7286 11.092,8.7708 C11.0478,8.813 11.0128,8.863 10.9891,8.918 C10.9653,8.9729 10.9533,9.0318 10.9535945,9.0912 L10.9535945,17.2734 C10.9533,17.3328 10.9653,17.3916 10.9891,17.4466 C11.0128,17.5016 11.0478,17.5516 11.092,17.5938 C11.1362,17.636 11.1888,17.6695 11.2468,17.6925 C11.3047,17.7155 11.3669,17.7275 11.4297,17.7278 Z" id="Path" fill="#45C197"></path><path d="M15.7137,17.7278 L16.666,17.7278 C16.7288,17.7275 16.791,17.7155 16.8489,17.6925 C16.9069,17.6695 16.9595,17.636 17.0037,17.5938 C17.0479,17.5516 17.0829,17.5016 17.1066,17.4466 C17.1304,17.3916 17.1424,17.3328 17.1421055,17.2734 L17.1421055,5.90891 C17.1424,5.84954 17.1304,5.79069 17.1066,5.73573 C17.0829,5.68076 17.0479,5.63075 17.0037,5.58855 C16.9595,5.54635 16.9069,5.51279 16.8489,5.48979 C16.791,5.46678 16.7288,5.45478 16.666,5.45447 L15.7137,5.45447 C15.6508,5.45478 15.5887,5.46678 15.5307,5.48979 C15.4728,5.51279 15.4202,5.54635 15.376,5.58855 C15.3318,5.63075 15.2968,5.68076 15.273,5.73573 C15.2493,5.79069 15.2372,5.84954 15.2375849,5.90891 L15.2375849,17.2722 C15.2371,17.3317 15.249,17.3907 15.2727,17.4458 C15.2963,17.5009 15.3313,17.551 15.3755,17.5933 C15.4198,17.6357 15.4724,17.6693 15.5304,17.6924 C15.5884,17.7155 15.6507,17.7275 15.7137,17.7278 L15.7137,17.7278 Z" id="Path" fill="#45C197"></path><path d="M2.38062,9.5456 C2.38062,9.5456 9.1271,8.4844 16.6658,0.45447" id="Path"></path><polyline id="Path" points="14.7626 0 17.1432 0 17.1432 2.27219"></polyline></g></g></svg >'
    WHERE id = (SELECT id FROM :auth_schema.menu_item WHERE title = 'Discovery');
UPDATE :auth_schema.menu_item SET icon_path = '<svg width="22" height="22" viewBox="0 0 22 22" fill="none" xmlns="http://www.w3.org/2000/svg"><g clip-path="url(#clip0)"><path d="M13.0625 8.25V9.625C13.0625 9.90859 12.8305 10.1406 12.5469 10.1406H10.1406V12.5469C10.1406 12.8305 9.90859 13.0625 9.625 13.0625H8.25C7.96641 13.0625 7.73438 12.8305 7.73438 12.5469V10.1406H5.32812C5.04453 10.1406 4.8125 9.90859 4.8125 9.625V8.25C4.8125 7.96641 5.04453 7.73438 5.32812 7.73438H7.73438V5.32812C7.73438 5.04453 7.96641 4.8125 8.25 4.8125H9.625C9.90859 4.8125 10.1406 5.04453 10.1406 5.32812V7.73438H12.5469C12.8305 7.73438 13.0625 7.96641 13.0625 8.25ZM21.6992 20.4832L20.4832 21.6992C20.0793 22.1031 19.4262 22.1031 19.0266 21.6992L14.7383 17.4152C14.5449 17.2219 14.4375 16.9598 14.4375 16.6848V15.9844C12.9207 17.1703 11.0129 17.875 8.9375 17.875C4.00039 17.875 0 13.8746 0 8.9375C0 4.00039 4.00039 0 8.9375 0C13.8746 0 17.875 4.00039 17.875 8.9375C17.875 11.0129 17.1703 12.9207 15.9844 14.4375H16.6848C16.9598 14.4375 17.2219 14.5449 17.4152 14.7383L21.6992 19.0223C22.0988 19.4262 22.0988 20.0793 21.6992 20.4832ZM14.7812 8.9375C14.7812 5.70625 12.1687 3.09375 8.9375 3.09375C5.70625 3.09375 3.09375 5.70625 3.09375 8.9375C3.09375 12.1687 5.70625 14.7812 8.9375 14.7812C12.1687 14.7812 14.7812 12.1687 14.7812 8.9375Z" fill="#45C197"/></g><defs><clipPath id="clip0"><rect width="22" height="22" fill="white"/></clipPath></defs></svg>'
    WHERE id = (SELECT id FROM :auth_schema.menu_item WHERE title = 'Process Discovery');
UPDATE :auth_schema.menu_item SET icon_path = '<svg width="18" height="19" viewBox="0 0 18 19" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M18 6.77698C18 3.33167 15.2227 0.554321 11.7773 0.554321C8.36719 0.589478 5.625 3.33167 5.625 6.74182C5.625 7.44495 5.73047 8.07776 5.90625 8.71057L0.246094 14.3707C0.0703125 14.5465 0 14.7574 0 14.9684V17.7106C0 18.2028 0.351562 18.5543 0.84375 18.5543H4.78125C5.23828 18.5543 5.625 18.2028 5.625 17.7106V16.3043H7.03125C7.48828 16.3043 7.875 15.9528 7.875 15.4606V14.0543H9.17578C9.38672 14.0543 9.66797 13.9489 9.80859 13.7731L10.6523 12.8239C11.0039 12.8942 11.3906 12.9293 11.8125 12.9293C15.2227 12.9293 18 10.1871 18 6.77698ZM11.8125 5.05432C11.8125 4.14026 12.5508 3.36682 13.5 3.36682C14.4141 3.36682 15.1875 4.14026 15.1875 5.05432C15.1875 6.00354 14.4141 6.74182 13.5 6.74182C12.5508 6.74182 11.8125 6.00354 11.8125 5.05432Z" fill="#45C197"/></svg>'
    WHERE id = (SELECT id FROM :auth_schema.menu_item WHERE title = 'License Manager');
UPDATE :auth_schema.menu_item SET icon_path = '<svg width="12" height="24" viewBox="0 0 12 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M4.64998 0.300003V7.0128C2.50618 7.6134 0.918579 9.5802 0.918579 11.9064C0.918579 14.2326 2.50618 16.218 4.64998 16.8186V23.7H7.36858V16.8186C9.51238 16.218 11.1 14.2326 11.1 11.9064C11.1 9.5802 9.51238 7.6134 7.36858 7.0128V0.300003H4.64998ZM6.01858 9.525C7.34758 9.525 8.38138 10.5774 8.38138 11.9064C8.38138 13.2354 7.34758 14.2872 6.01858 14.2872C4.68958 14.2872 3.63718 13.2354 3.63718 11.9064C3.63718 10.5774 4.68958 9.525 6.01858 9.525Z" fill="#45C197"/></svg>'
    WHERE id = (SELECT id FROM :auth_schema.menu_item WHERE title = 'System Manager');
UPDATE :auth_schema.menu_item SET icon_path = '<svg width="12" height="24" viewBox="0 0 12 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M4.64998 0.300003V7.0128C2.50618 7.6134 0.918579 9.5802 0.918579 11.9064C0.918579 14.2326 2.50618 16.218 4.64998 16.8186V23.7H7.36858V16.8186C9.51238 16.218 11.1 14.2326 11.1 11.9064C11.1 9.5802 9.51238 7.6134 7.36858 7.0128V0.300003H4.64998ZM6.01858 9.525C7.34758 9.525 8.38138 10.5774 8.38138 11.9064C8.38138 13.2354 7.34758 14.2872 6.01858 14.2872C4.68958 14.2872 3.63718 13.2354 3.63718 11.9064C3.63718 10.5774 4.68958 9.525 6.01858 9.525Z" fill="#45C197"/></svg>'
    WHERE id = (SELECT id FROM :auth_schema.menu_item WHERE title = 'Commit Log');
UPDATE :auth_schema.menu_item SET icon_path = '<svg width="24" height="19" viewBox="0 0 24 19" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M19 6.96484C19.3516 7.03516 19.7383 7.03516 20.0898 6.96484L20.4062 7.49219C20.5117 7.66797 20.7227 7.73828 20.9336 7.66797C21.3203 7.52734 21.707 7.28125 22.0586 7.03516C22.1992 6.89453 22.2695 6.64844 22.1641 6.47266L21.8477 5.98047C22.0938 5.69922 22.3047 5.34766 22.4102 4.99609H23.0078C23.2188 4.99609 23.3945 4.85547 23.4297 4.64453C23.5 4.1875 23.5 3.76562 23.4297 3.34375C23.3945 3.13281 23.2188 2.95703 23.0078 2.95703H22.4102C22.3047 2.60547 22.0938 2.28906 21.8477 2.00781L22.1641 1.51562C22.2695 1.30469 22.1992 1.09375 22.0586 0.953125C21.707 0.671875 21.3203 0.460938 20.9336 0.285156C20.7227 0.214844 20.5117 0.285156 20.4062 0.496094L20.0898 0.988281C19.7383 0.917969 19.3516 0.917969 19 0.988281L18.6836 0.496094C18.5781 0.285156 18.3672 0.214844 18.1562 0.285156C17.7695 0.460938 17.3828 0.671875 17.0312 0.953125C16.8906 1.09375 16.8203 1.30469 16.9258 1.51562L17.2422 2.00781C16.9961 2.28906 16.7852 2.60547 16.6797 2.95703H16.082C15.8711 2.95703 15.6953 3.13281 15.6602 3.34375C15.5898 3.76562 15.5898 4.22266 15.6602 4.64453C15.6953 4.85547 15.8711 4.99609 16.082 4.99609H16.6797C16.7852 5.34766 16.9961 5.69922 17.2422 5.98047L16.9258 6.47266C16.8203 6.64844 16.8906 6.89453 17.0312 7.03516C17.3828 7.28125 17.7695 7.52734 18.1562 7.66797C18.3672 7.73828 18.5781 7.66797 18.6836 7.49219L19 6.96484ZM18.6133 4.92578C17.5938 3.55469 19.1055 2.00781 20.4766 3.0625C21.5312 4.39844 19.9844 5.94531 18.6133 4.92578ZM14.5703 10.3398C14.7109 9.60156 14.7109 8.82812 14.5703 8.08984L15.7656 7.49219C16.1172 7.28125 16.2578 6.85938 16.1172 6.47266C15.8008 5.62891 15.2031 4.85547 14.6055 4.15234C14.3594 3.83594 13.9023 3.76562 13.5508 3.97656L12.5312 4.57422C11.9688 4.08203 11.3008 3.69531 10.5977 3.44922V2.28906C10.5977 1.86719 10.3164 1.51562 9.89453 1.44531C9.01562 1.30469 8.10156 1.30469 7.22266 1.44531C6.83594 1.51562 6.55469 1.86719 6.55469 2.28906V3.44922C5.81641 3.69531 5.18359 4.08203 4.62109 4.57422L3.60156 3.97656C3.21484 3.76562 2.79297 3.87109 2.51172 4.15234C1.94922 4.85547 1.35156 5.62891 1.03516 6.47266C0.894531 6.85938 1.03516 7.28125 1.42188 7.49219L2.58203 8.08984C2.44141 8.82812 2.44141 9.60156 2.58203 10.3398L1.42188 10.9023C1.03516 11.1133 0.894531 11.5703 1.03516 11.9219C1.35156 12.8008 1.94922 13.5742 2.51172 14.2422C2.79297 14.5586 3.25 14.6289 3.60156 14.418L4.62109 13.8555C5.18359 14.3125 5.81641 14.6992 6.55469 14.9453V16.1406C6.55469 16.5625 6.83594 16.9141 7.25781 16.9844C8.13672 17.125 9.05078 17.125 9.89453 16.9844C10.3164 16.9141 10.5977 16.5625 10.5977 16.1406V14.9453C11.3008 14.6992 11.9688 14.3125 12.5312 13.8555L13.5508 14.4531C13.9023 14.6289 14.3594 14.5586 14.6055 14.2422C15.2031 13.5742 15.8008 12.8008 16.1172 11.9219C16.2578 11.5352 16.1172 11.1133 15.7656 10.9023L14.5703 10.3398ZM10.4219 11.0781C7.71484 13.1523 4.62109 10.0586 6.73047 7.35156C9.4375 5.27734 12.4961 8.37109 10.4219 11.0781ZM19 17.4766C19.3516 17.5469 19.7383 17.5469 20.0898 17.4766L20.4062 18.0039C20.5117 18.1797 20.7227 18.25 20.9336 18.1797C21.3203 18.0391 21.707 17.793 22.0586 17.5117C22.1992 17.4062 22.2695 17.1602 22.1641 16.9844L21.8477 16.457C22.0938 16.1758 22.3047 15.8594 22.4102 15.5078H23.0078C23.2188 15.5078 23.3945 15.3672 23.4297 15.1562C23.5 14.6992 23.5 14.2773 23.4297 13.8555C23.3945 13.6445 23.2188 13.4688 23.0078 13.4688H22.4102C22.3047 13.1172 22.0938 12.8008 21.8477 12.5195L22.1641 12.0273C22.2695 11.8164 22.1992 11.6055 22.0586 11.4648C21.707 11.1836 21.3203 10.9727 20.9336 10.7969C20.7227 10.7266 20.5117 10.7969 20.4062 11.0078L20.0898 11.5C19.7383 11.4297 19.3516 11.4297 19 11.5L18.6836 11.0078C18.5781 10.7969 18.3672 10.7266 18.1562 10.7969C17.7695 10.9727 17.3828 11.1836 17.0312 11.4648C16.8906 11.6055 16.8203 11.8164 16.9258 12.0273L17.2422 12.5195C16.9961 12.8008 16.7852 13.1172 16.6797 13.4688H16.082C15.8711 13.4688 15.6953 13.6445 15.6602 13.8555C15.5898 14.2773 15.5898 14.7344 15.6602 15.1562C15.6953 15.3672 15.8711 15.5078 16.082 15.5078H16.6797C16.7852 15.8594 16.9961 16.1758 17.2422 16.457L16.9258 16.9844C16.8203 17.1602 16.8906 17.4062 17.0312 17.5117C17.3828 17.793 17.7695 18.0391 18.1562 18.1797C18.3672 18.25 18.5781 18.1797 18.6836 18.0039L19 17.4766ZM18.6133 15.4023C17.5938 14.0664 19.1055 12.5195 20.4766 13.5742C21.5312 14.9102 19.9844 16.457 18.6133 15.4023Z" fill="#45C197"/></svg>'
    WHERE id = (SELECT id FROM :auth_schema.menu_item WHERE title = 'Administration');
UPDATE :auth_schema.menu_item SET icon_path = '<svg width="23" height="19" viewBox="0 0 23 19" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M21.4453 13.3984C21.5508 12.9062 21.5508 12.3789 21.4453 11.8867L22.3594 11.3594C22.4648 11.3242 22.5 11.1836 22.4648 11.0781C22.2188 10.3047 21.832 9.63672 21.3047 9.03906C21.2344 8.96875 21.0938 8.93359 20.9883 9.00391L20.0742 9.53125C19.6875 9.21484 19.2656 8.93359 18.7734 8.79297V7.73828C18.7734 7.59766 18.7031 7.49219 18.5977 7.49219C17.7891 7.31641 17.0156 7.31641 16.2422 7.49219C16.1367 7.49219 16.0664 7.59766 16.0664 7.73828V8.79297C15.5742 8.93359 15.1523 9.21484 14.7656 9.53125L13.8516 9.00391C13.7461 8.93359 13.6055 8.96875 13.5352 9.03906C13.0078 9.63672 12.5859 10.3047 12.375 11.0781C12.3398 11.1836 12.375 11.3242 12.4805 11.3594L13.3945 11.8867C13.2891 12.3789 13.2891 12.9062 13.3945 13.3984L12.4805 13.9258C12.375 13.9609 12.3398 14.1016 12.375 14.207C12.5859 14.9805 13.0078 15.6484 13.5352 16.2461C13.6055 16.3164 13.7461 16.3516 13.8516 16.2812L14.7656 15.7539C15.1523 16.0703 15.5742 16.3516 16.0664 16.4922V17.5469C16.0664 17.6875 16.1367 17.793 16.2422 17.793C17.0508 17.9688 17.8242 17.9688 18.5977 17.793C18.7031 17.793 18.7734 17.6875 18.7734 17.5469V16.4922C19.2656 16.3516 19.6875 16.0703 20.0742 15.7539L20.9883 16.2812C21.0938 16.3516 21.2344 16.3164 21.3047 16.2461C21.832 15.6484 22.2188 14.9805 22.4648 14.207C22.5 14.1016 22.4648 13.9609 22.3594 13.9258L21.4453 13.3984ZM17.4375 14.3477C16.4883 14.3477 15.7148 13.5742 15.7148 12.625C15.7148 11.7109 16.4883 10.9375 17.4375 10.9375C18.3516 10.9375 19.125 11.7109 19.125 12.625C19.125 13.5742 18.3516 14.3477 17.4375 14.3477ZM7.875 9.25C10.3359 9.25 12.375 7.24609 12.375 4.75C12.375 2.28906 10.3359 0.25 7.875 0.25C5.37891 0.25 3.375 2.28906 3.375 4.75C3.375 7.24609 5.37891 9.25 7.875 9.25ZM14.9414 17.2305C14.8359 17.1953 14.7656 17.125 14.6953 17.0898L14.4141 17.2656C14.2031 17.3711 13.957 17.4414 13.7109 17.4414C13.3594 17.4414 12.9727 17.2656 12.7266 16.9844C12.0586 16.3164 11.5664 15.4375 11.2852 14.5586C11.1094 13.9258 11.3555 13.2578 11.918 12.9414L12.1992 12.7656C12.1992 12.6953 12.1992 12.5898 12.1992 12.5195L11.918 12.3438C11.3555 12.0273 11.1094 11.3594 11.2852 10.7266C11.3203 10.6211 11.3906 10.5508 11.4258 10.4453C11.2852 10.4102 11.1445 10.375 11.0039 10.375H10.4062C9.63281 10.7617 8.78906 10.9375 7.875 10.9375C6.96094 10.9375 6.08203 10.7617 5.30859 10.375H4.71094C2.10938 10.375 0 12.5195 0 15.1211V16.5625C0 17.5117 0.738281 18.25 1.6875 18.25H14.0625C14.4141 18.25 14.7305 18.1445 15.0117 17.9688C14.9766 17.8281 14.9414 17.6875 14.9414 17.5469V17.2305Z" fill="#45C197"/></svg>'
    WHERE id = (SELECT id FROM :auth_schema.menu_item WHERE title = 'Manage Users');
UPDATE :auth_schema.menu_item SET icon_path = '<svg width="24" height="19" viewBox="0 0 24 19" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M19 6.96484C19.3516 7.03516 19.7383 7.03516 20.0898 6.96484L20.4062 7.49219C20.5117 7.66797 20.7227 7.73828 20.9336 7.66797C21.3203 7.52734 21.707 7.28125 22.0586 7.03516C22.1992 6.89453 22.2695 6.64844 22.1641 6.47266L21.8477 5.98047C22.0938 5.69922 22.3047 5.34766 22.4102 4.99609H23.0078C23.2188 4.99609 23.3945 4.85547 23.4297 4.64453C23.5 4.1875 23.5 3.76562 23.4297 3.34375C23.3945 3.13281 23.2188 2.95703 23.0078 2.95703H22.4102C22.3047 2.60547 22.0938 2.28906 21.8477 2.00781L22.1641 1.51562C22.2695 1.30469 22.1992 1.09375 22.0586 0.953125C21.707 0.671875 21.3203 0.460938 20.9336 0.285156C20.7227 0.214844 20.5117 0.285156 20.4062 0.496094L20.0898 0.988281C19.7383 0.917969 19.3516 0.917969 19 0.988281L18.6836 0.496094C18.5781 0.285156 18.3672 0.214844 18.1562 0.285156C17.7695 0.460938 17.3828 0.671875 17.0312 0.953125C16.8906 1.09375 16.8203 1.30469 16.9258 1.51562L17.2422 2.00781C16.9961 2.28906 16.7852 2.60547 16.6797 2.95703H16.082C15.8711 2.95703 15.6953 3.13281 15.6602 3.34375C15.5898 3.76562 15.5898 4.22266 15.6602 4.64453C15.6953 4.85547 15.8711 4.99609 16.082 4.99609H16.6797C16.7852 5.34766 16.9961 5.69922 17.2422 5.98047L16.9258 6.47266C16.8203 6.64844 16.8906 6.89453 17.0312 7.03516C17.3828 7.28125 17.7695 7.52734 18.1562 7.66797C18.3672 7.73828 18.5781 7.66797 18.6836 7.49219L19 6.96484ZM18.6133 4.92578C17.5938 3.55469 19.1055 2.00781 20.4766 3.0625C21.5312 4.39844 19.9844 5.94531 18.6133 4.92578ZM14.5703 10.3398C14.7109 9.60156 14.7109 8.82812 14.5703 8.08984L15.7656 7.49219C16.1172 7.28125 16.2578 6.85938 16.1172 6.47266C15.8008 5.62891 15.2031 4.85547 14.6055 4.15234C14.3594 3.83594 13.9023 3.76562 13.5508 3.97656L12.5312 4.57422C11.9688 4.08203 11.3008 3.69531 10.5977 3.44922V2.28906C10.5977 1.86719 10.3164 1.51562 9.89453 1.44531C9.01562 1.30469 8.10156 1.30469 7.22266 1.44531C6.83594 1.51562 6.55469 1.86719 6.55469 2.28906V3.44922C5.81641 3.69531 5.18359 4.08203 4.62109 4.57422L3.60156 3.97656C3.21484 3.76562 2.79297 3.87109 2.51172 4.15234C1.94922 4.85547 1.35156 5.62891 1.03516 6.47266C0.894531 6.85938 1.03516 7.28125 1.42188 7.49219L2.58203 8.08984C2.44141 8.82812 2.44141 9.60156 2.58203 10.3398L1.42188 10.9023C1.03516 11.1133 0.894531 11.5703 1.03516 11.9219C1.35156 12.8008 1.94922 13.5742 2.51172 14.2422C2.79297 14.5586 3.25 14.6289 3.60156 14.418L4.62109 13.8555C5.18359 14.3125 5.81641 14.6992 6.55469 14.9453V16.1406C6.55469 16.5625 6.83594 16.9141 7.25781 16.9844C8.13672 17.125 9.05078 17.125 9.89453 16.9844C10.3164 16.9141 10.5977 16.5625 10.5977 16.1406V14.9453C11.3008 14.6992 11.9688 14.3125 12.5312 13.8555L13.5508 14.4531C13.9023 14.6289 14.3594 14.5586 14.6055 14.2422C15.2031 13.5742 15.8008 12.8008 16.1172 11.9219C16.2578 11.5352 16.1172 11.1133 15.7656 10.9023L14.5703 10.3398ZM10.4219 11.0781C7.71484 13.1523 4.62109 10.0586 6.73047 7.35156C9.4375 5.27734 12.4961 8.37109 10.4219 11.0781ZM19 17.4766C19.3516 17.5469 19.7383 17.5469 20.0898 17.4766L20.4062 18.0039C20.5117 18.1797 20.7227 18.25 20.9336 18.1797C21.3203 18.0391 21.707 17.793 22.0586 17.5117C22.1992 17.4062 22.2695 17.1602 22.1641 16.9844L21.8477 16.457C22.0938 16.1758 22.3047 15.8594 22.4102 15.5078H23.0078C23.2188 15.5078 23.3945 15.3672 23.4297 15.1562C23.5 14.6992 23.5 14.2773 23.4297 13.8555C23.3945 13.6445 23.2188 13.4688 23.0078 13.4688H22.4102C22.3047 13.1172 22.0938 12.8008 21.8477 12.5195L22.1641 12.0273C22.2695 11.8164 22.1992 11.6055 22.0586 11.4648C21.707 11.1836 21.3203 10.9727 20.9336 10.7969C20.7227 10.7266 20.5117 10.7969 20.4062 11.0078L20.0898 11.5C19.7383 11.4297 19.3516 11.4297 19 11.5L18.6836 11.0078C18.5781 10.7969 18.3672 10.7266 18.1562 10.7969C17.7695 10.9727 17.3828 11.1836 17.0312 11.4648C16.8906 11.6055 16.8203 11.8164 16.9258 12.0273L17.2422 12.5195C16.9961 12.8008 16.7852 13.1172 16.6797 13.4688H16.082C15.8711 13.4688 15.6953 13.6445 15.6602 13.8555C15.5898 14.2773 15.5898 14.7344 15.6602 15.1562C15.6953 15.3672 15.8711 15.5078 16.082 15.5078H16.6797C16.7852 15.8594 16.9961 16.1758 17.2422 16.457L16.9258 16.9844C16.8203 17.1602 16.8906 17.4062 17.0312 17.5117C17.3828 17.793 17.7695 18.0391 18.1562 18.1797C18.3672 18.25 18.5781 18.1797 18.6836 18.0039L19 17.4766ZM18.6133 15.4023C17.5938 14.0664 19.1055 12.5195 20.4766 13.5742C21.5312 14.9102 19.9844 16.457 18.6133 15.4023Z" fill="#45C197"/></svg>'
    WHERE id = (SELECT id FROM :auth_schema.menu_item WHERE title = 'System Configuration');
UPDATE :auth_schema.menu_item SET icon_path = '<svg width="18" height="17" viewBox="0 0 18 17" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M11.25 11.0625C11.25 11.3789 10.9688 11.625 10.6875 11.625H7.3125C6.99609 11.625 6.75 11.3789 6.75 11.0625V9.375H0V14.4375C0 15.3516 0.773438 16.125 1.6875 16.125H16.3125C17.1914 16.125 18 15.3516 18 14.4375V9.375H11.25V11.0625ZM16.3125 3.75H13.5V2.0625C13.5 1.18359 12.6914 0.375 11.8125 0.375H6.1875C5.27344 0.375 4.5 1.18359 4.5 2.0625V3.75H1.6875C0.773438 3.75 0 4.55859 0 5.4375V8.25H18V5.4375C18 4.55859 17.1914 3.75 16.3125 3.75ZM11.25 3.75H6.75V2.625H11.25V3.75Z" fill="#45C197"/></svg>'
    WHERE id = (SELECT id FROM :auth_schema.menu_item WHERE title = 'Manage Projects');
UPDATE :auth_schema.menu_item SET icon_path = '<svg width="23" height="19" viewBox="0 0 23 19" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M4.5 12.9293H1.125C0.492188 12.9293 0 13.4567 0 14.0543V17.4293C0 18.0621 0.492188 18.5543 1.125 18.5543H4.5C5.09766 18.5543 5.625 18.0621 5.625 17.4293V14.0543C5.625 13.4567 5.09766 12.9293 4.5 12.9293ZM3.65625 10.1168H10.4062V11.8043H12.0938V10.1168H18.8438V11.8043H20.5312V9.80042C20.5312 9.06213 19.8984 8.42932 19.1602 8.42932H12.0938V6.17932H13.5C14.0977 6.17932 14.625 5.68713 14.625 5.05432V1.67932C14.625 1.08167 14.0977 0.554321 13.5 0.554321H9C8.36719 0.554321 7.875 1.08167 7.875 1.67932V5.05432C7.875 5.68713 8.36719 6.17932 9 6.17932H10.4062V8.42932H3.30469C2.56641 8.42932 1.96875 9.06213 1.96875 9.80042V11.8043H3.65625V10.1168ZM12.9375 12.9293H9.5625C8.92969 12.9293 8.4375 13.4567 8.4375 14.0543V17.4293C8.4375 18.0621 8.92969 18.5543 9.5625 18.5543H12.9375C13.5352 18.5543 14.0625 18.0621 14.0625 17.4293V14.0543C14.0625 13.4567 13.5352 12.9293 12.9375 12.9293ZM21.375 12.9293H18C17.3672 12.9293 16.875 13.4567 16.875 14.0543V17.4293C16.875 18.0621 17.3672 18.5543 18 18.5543H21.375C21.9727 18.5543 22.5 18.0621 22.5 17.4293V14.0543C22.5 13.4567 21.9727 12.9293 21.375 12.9293Z" fill="#45C197"/></svg>'
    WHERE id = (SELECT id FROM :auth_schema.menu_item WHERE title = 'Process Exploration');
UPDATE :auth_schema.menu_item SET icon_path = '<svg width="18" height="16" viewBox="0 0 18 16" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M2.8125 12.1875H0.5625C0.246094 12.1875 0 12.4688 0 12.75V15C0 15.3164 0.246094 15.5625 0.5625 15.5625H2.8125C3.09375 15.5625 3.375 15.3164 3.375 15V12.75C3.375 12.4688 3.09375 12.1875 2.8125 12.1875ZM2.8125 0.9375H0.5625C0.246094 0.9375 0 1.21875 0 1.5V3.75C0 4.06641 0.246094 4.3125 0.5625 4.3125H2.8125C3.09375 4.3125 3.375 4.06641 3.375 3.75V1.5C3.375 1.21875 3.09375 0.9375 2.8125 0.9375ZM2.8125 6.5625H0.5625C0.246094 6.5625 0 6.84375 0 7.125V9.375C0 9.69141 0.246094 9.9375 0.5625 9.9375H2.8125C3.09375 9.9375 3.375 9.69141 3.375 9.375V7.125C3.375 6.84375 3.09375 6.5625 2.8125 6.5625ZM17.4375 12.75H6.1875C5.87109 12.75 5.625 13.0312 5.625 13.3125V14.4375C5.625 14.7539 5.87109 15 6.1875 15H17.4375C17.7188 15 18 14.7539 18 14.4375V13.3125C18 13.0312 17.7188 12.75 17.4375 12.75ZM17.4375 1.5H6.1875C5.87109 1.5 5.625 1.78125 5.625 2.0625V3.1875C5.625 3.50391 5.87109 3.75 6.1875 3.75H17.4375C17.7188 3.75 18 3.50391 18 3.1875V2.0625C18 1.78125 17.7188 1.5 17.4375 1.5ZM17.4375 7.125H6.1875C5.87109 7.125 5.625 7.40625 5.625 7.6875V8.8125C5.625 9.12891 5.87109 9.375 6.1875 9.375H17.4375C17.7188 9.375 18 9.12891 18 8.8125V7.6875C18 7.40625 17.7188 7.125 17.4375 7.125Z" fill="#45C197"/></svg>'
    WHERE id = (SELECT id FROM :auth_schema.menu_item WHERE title = 'Configuration');
UPDATE :auth_schema.menu_item SET icon_path = '<svg width="7" height="10" viewBox="0 0 7 10" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M6.125 5.21484C6.37109 4.96875 6.37109 4.55859 6.125 4.28516L2.40625 0.566406C2.13281 0.320312 1.72266 0.320312 1.47656 0.566406L0.847656 1.19531C0.601562 1.46875 0.601562 1.87891 0.847656 2.125L3.5 4.77734L0.847656 7.40234C0.601562 7.64844 0.601562 8.05859 0.847656 8.33203L1.47656 8.93359C1.72266 9.20703 2.13281 9.20703 2.40625 8.93359L6.125 5.21484Z" fill="#FAFAFD"/></svg>'
    WHERE id = (SELECT id FROM :auth_schema.menu_item WHERE title = 'Authorization');
UPDATE :auth_schema.menu_item SET icon_path = '<svg width="20px" height="20px" viewBox="0 0 20 20" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"><g id="Page-1" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd"><g id="EnrichmentIcon"><polygon id="Path" stroke="#45C197" points="18.3649 1.62134 1.63354 1.62134 1.63354 17.8377 18.3649 17.8377"></polygon><polygon id="Path" fill="#45C197" fill-rule="nonzero" points="3.81223 0 0 0 0 3.78364 3.81223 3.78364"></polygon><polygon id="Path" fill="#45C197" fill-rule="nonzero" points="3.81223 7.56726 0 7.56726 0 11.3509 3.81223 11.3509"></polygon><polygon id="Path" fill="#45C197" fill-rule="nonzero" points="3.81223 16.2164 0 16.2164 0 20 3.81223 20"></polygon><polygon id="Path" fill="#45C197" fill-rule="nonzero" points="11.9055 0 8.0933 0 8.0933 3.78364 11.9055 3.78364"></polygon><polygon id="Path" fill="#45C197" fill-rule="nonzero" points="11.9055 7.56726 8.0933 7.56726 8.0933 11.3509 11.9055 11.3509"></polygon><polygon id="Path" fill="#45C197" fill-rule="nonzero" points="11.9055 16.2164 8.0933 16.2164 8.0933 20 11.9055 20"></polygon><polygon id="Path" fill="#45C197" fill-rule="nonzero" points="20 0 16.1877 0 16.1877 3.78364 20 3.78364"></polygon><polygon id="Path" fill="#45C197" fill-rule="nonzero" points="20 7.56726 16.1877 7.56726 16.1877 11.3509 20 11.3509"></polygon><polygon id="Path" fill="#45C197" fill-rule="nonzero" points="20 16.2164 16.1877 16.2164 16.1877 20 20 20"></polygon></g></g></svg>'
    WHERE id = (SELECT id FROM :auth_schema.menu_item WHERE title = 'AI');
UPDATE :auth_schema.menu_item SET icon_path = '<svg width="20px" height="20px" viewBox="0 0 20 20" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"><g id="Page-1" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd"><g id="EnrichmentIcon"><polygon id="Path" stroke="#45C197" points="18.3649 1.62134 1.63354 1.62134 1.63354 17.8377 18.3649 17.8377"></polygon><polygon id="Path" fill="#45C197" fill-rule="nonzero" points="3.81223 0 0 0 0 3.78364 3.81223 3.78364"></polygon><polygon id="Path" fill="#45C197" fill-rule="nonzero" points="3.81223 7.56726 0 7.56726 0 11.3509 3.81223 11.3509"></polygon><polygon id="Path" fill="#45C197" fill-rule="nonzero" points="3.81223 16.2164 0 16.2164 0 20 3.81223 20"></polygon><polygon id="Path" fill="#45C197" fill-rule="nonzero" points="11.9055 0 8.0933 0 8.0933 3.78364 11.9055 3.78364"></polygon><polygon id="Path" fill="#45C197" fill-rule="nonzero" points="11.9055 7.56726 8.0933 7.56726 8.0933 11.3509 11.9055 11.3509"></polygon><polygon id="Path" fill="#45C197" fill-rule="nonzero" points="11.9055 16.2164 8.0933 16.2164 8.0933 20 11.9055 20"></polygon><polygon id="Path" fill="#45C197" fill-rule="nonzero" points="20 0 16.1877 0 16.1877 3.78364 20 3.78364"></polygon><polygon id="Path" fill="#45C197" fill-rule="nonzero" points="20 7.56726 16.1877 7.56726 16.1877 11.3509 20 11.3509"></polygon><polygon id="Path" fill="#45C197" fill-rule="nonzero" points="20 16.2164 16.1877 16.2164 16.1877 20 20 20"></polygon></g></g></svg>'
    WHERE id = (SELECT id FROM :auth_schema.menu_item WHERE title = 'Enrichment');
UPDATE :auth_schema.menu_item SET icon_path = '<svg width="16" height="19" viewBox="0 0 16 19" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M15.75 12.9062V1.09375C15.75 0.636719 15.3633 0.25 14.9062 0.25H3.375C1.51172 0.25 0 1.76172 0 3.625V14.875C0 16.7383 1.51172 18.25 3.375 18.25H14.9062C15.3633 18.25 15.75 17.8984 15.75 17.4062V16.8438C15.75 16.5977 15.6094 16.3516 15.4336 16.2109C15.2578 15.6484 15.2578 14.1016 15.4336 13.5742C15.6094 13.4336 15.75 13.1875 15.75 12.9062ZM4.5 4.96094C4.5 4.85547 4.57031 4.75 4.71094 4.75H12.1641C12.2695 4.75 12.375 4.85547 12.375 4.96094V5.66406C12.375 5.80469 12.2695 5.875 12.1641 5.875H4.71094C4.57031 5.875 4.5 5.80469 4.5 5.66406V4.96094ZM4.5 7.21094C4.5 7.10547 4.57031 7 4.71094 7H12.1641C12.2695 7 12.375 7.10547 12.375 7.21094V7.91406C12.375 8.05469 12.2695 8.125 12.1641 8.125H4.71094C4.57031 8.125 4.5 8.05469 4.5 7.91406V7.21094ZM13.3945 16H3.375C2.74219 16 2.25 15.5078 2.25 14.875C2.25 14.2773 2.74219 13.75 3.375 13.75H13.3945C13.3242 14.3828 13.3242 15.4023 13.3945 16Z" fill="#45C197"/></svg>'
    WHERE id = (SELECT id FROM :auth_schema.menu_item WHERE title = 'Business Dictionaries');

-- Link all the menu items to their record in "resource" by matching it with their name
UPDATE :auth_schema.menu_item SET resource_id = resource.id FROM :auth_schema.resource
WHERE LOWER(menu_item.title) = LOWER(resource.name);
INSERT INTO :auth_schema.authorization_types(type) 
    VALUES ('User'), ('UserGroup'), ('Role'), ('IP'), ('ACL')
    ON CONFLICT(type) DO NOTHING;
    
INSERT INTO :auth_schema.status_types(status) VALUES ('Active'), ('Inactive')
    ON CONFLICT(status) DO NOTHING;
INSERT INTO :auth_schema.record_types(type) VALUES ('System')
    ON CONFLICT(type) DO NOTHING;
INSERT INTO :auth_schema.authorization_object_types(name) 
    VALUES ('route'), ('menu'), ('data'), ('action'), ('operation')
    ON CONFLICT(name) DO NOTHING;
INSERT INTO :auth_schema.authorization_menu_extension_types(mode) VALUES ('Display')
    ON CONFLICT(mode) DO NOTHING;
INSERT INTO :auth_schema.authorization_route_extension_types(http_method) 
    VALUES ('GET'), ('POST'), ('PUT'), ('DELETE')
    ON CONFLICT(http_method) DO NOTHING;
INSERT INTO :auth_schema.authorization_data_extension_types(operation) 
    VALUES ('display'), ('update'), ('delete'), ('add')
    ON CONFLICT(operation) DO NOTHING;
INSERT INTO :auth_schema.authorization_action_extension_types(display) 
    VALUES ('visible'), ('hidden')
    ON CONFLICT(display) DO NOTHING;
INSERT INTO :auth_schema.authorization_operation_extension_types(operation) 
    VALUES ('create_model'), ('run_model'), ('train_model')
    ON CONFLICT(operation) DO NOTHING;
INSERT INTO :auth_schema.authorization_directions(name) 
    VALUES ('Allow'), ('Deny')
    ON CONFLICT(name) DO NOTHING;
-- Insert the name of the roles
INSERT INTO :auth_schema.role(id,name) VALUES(1,'ROLE_ADMIN');
INSERT INTO :auth_schema.role(id,name) VALUES(2,'ROLE_USER');
INSERT INTO :auth_schema.role(id,name) VALUES(3,'ROLE_MODEL_VIEWER');
INSERT INTO :auth_schema.role(id,name) VALUES(4,'ROLE_ROOT');
INSERT INTO :auth_schema.role(id,name) VALUES(5,'ROLE_LICENCE_ADMIN');
INSERT INTO :auth_schema.role(id,name) VALUES(6,'ROLE_SYSTEM_ADMIN');
-- Insert the available permissions
INSERT INTO :auth_schema.permission(name) VALUES('auth:signup');
INSERT INTO :auth_schema.permission(name) VALUES('unslearn:models:train');
INSERT INTO :auth_schema.permission(name) VALUES('unslearn:models:deleteAllPredicted');
INSERT INTO :auth_schema.permission(name) VALUES('unslearn:models:entries:attributes:label');
INSERT INTO :auth_schema.permission(name) VALUES('project:create');
INSERT INTO :auth_schema.permission(name) VALUES('licence:edit');
INSERT INTO :auth_schema.permission(name) VALUES('system:configuration');
INSERT INTO :auth_schema.permission(name) VALUES('users:management');
-- NOTE: - OLD ROLE PERMISSIONS (deprecated; will be removed in favor of the 'authorizations' table)
-- Assign permissions of ROLE_ADMIN
INSERT INTO :auth_schema.role_permission(role_id, permission_id) VALUES(1, 1);
INSERT INTO :auth_schema.role_permission(role_id, permission_id) VALUES(1, 2);
INSERT INTO :auth_schema.role_permission(role_id, permission_id) VALUES(1, 3);
INSERT INTO :auth_schema.role_permission(role_id, permission_id) VALUES(1, 4);
INSERT INTO :auth_schema.role_permission(role_id, permission_id) VALUES(1, 8);
-- Assign permissions of ROLE_USER
INSERT INTO :auth_schema.role_permission(role_id, permission_id) VALUES(2, 2);
INSERT INTO :auth_schema.role_permission(role_id, permission_id) VALUES(2, 3);
INSERT INTO :auth_schema.role_permission(role_id, permission_id) VALUES(2, 4);
-- Assign permissions of ROLE_ROOT
INSERT INTO :auth_schema.role_permission(role_id, permission_id) VALUES(4, 1);
INSERT INTO :auth_schema.role_permission(role_id, permission_id) VALUES(4, 5);
INSERT INTO :auth_schema.role_permission(role_id, permission_id) VALUES(4, 8);
-- Assign permissions of ROLE_LICENCE_ADMIN
INSERT INTO :auth_schema.role_permission(role_id, permission_id) VALUES(5, 6);
-- Assign permissions of ROLE_SYSTEM_ADMIN
INSERT INTO :auth_schema.role_permission(role_id, permission_id) VALUES(6, 7);
INSERT INTO :auth_schema.role_permission(role_id, permission_id) VALUES(6, 8);
-- Insert the initial project called liveobjects
INSERT INTO :auth_schema.project(name, email) VALUES('liveobjects', 'support@liveobjects.ai');
-- Fill out initial user settings options
INSERT INTO :auth_schema.languages(name, code) VALUES('English', 'en');
INSERT INTO :auth_schema.languages(name, code) VALUES('German', 'de');
INSERT INTO :auth_schema.languages(name, code) VALUES('Dutch', 'nl');

INSERT INTO :auth_schema.time_formats(format) VALUES('YYYY-MM-DD');

INSERT INTO :auth_schema.currencies(name, currency_code, symbol) VALUES('US Dollar', 'USD', '$');
INSERT INTO :auth_schema.currencies(name, currency_code, symbol) VALUES('Euro', 'EUR', '€');

INSERT INTO :auth_schema.decimal_separators(id, separator) VALUES (1, '.'), (2, ',');

INSERT INTO :auth_schema.locations VALUES
    (1, 'South Africa', 'ZAF', '+27', '🇿🇦'), (2, 'Ethiopia', 'ETH', '+251', '🇪🇹'), (3, 'Algeria', 'DZA', '+213', '🇩🇿'), (4, 'Bahrain', 'BHR', '+973', '🇧🇭'), (5, 'Egypt', 'EGY', '+20', '🇪🇬'), (6, 'Jordan', 'JOR', '+962', '🇯🇴'), (7, 'Kuwait', 'KWT', '+965', '🇰🇼'), (8, 'Libya', 'LBY', '+218', '🇱🇾'), (9, 'Morocco', 'MAR', '+212', '🇲🇦'), (10, 'Oman', 'OMN', '+968', '🇴🇲'), (11, 'Palestinian Territory, Occupied', 'PSE', '+970', '🇵🇸'), (12, 'Qatar', 'QAT', '+974', '🇶🇦'), (13, 'Saudi Arabia', 'SAU', '+966', '🇸🇦'), (14, 'Syrian Arab Republic', 'SYR', '+963', '🇸🇾'), (15, 'Tunisia', 'TUN', '+216', '🇹🇳'), (16, 'United Arab Emirates', 'ARE', '+971', '🇦🇪'), (17, 'Yemen', 'YEM', '+967', '🇾🇪'), (18, 'Sudan', 'SDN', '+249', '🇸🇩'), (19, 'Chad', 'TCD', '+235', '🇹🇩'), (20, 'Comoros', 'COM', '+269', '🇰🇲'), (21, 'Djibouti', 'DJI', '+253', '🇩🇯'), (22, 'Mauritania', 'MRT', '+222', '🇲🇷'), (23, 'Lebanon', 'LBN', '+961', '🇱🇧'), (24, 'Iraq', 'IRQ', '+964', '🇮🇶'), (25, 'Azerbaijan', 'AZE', '+994', '🇦🇿'), (26, 'Belarus', 'BLR', '+375', '🇧🇾'), (27, 'Bangladesh', 'BGD', '+880', '🇧🇩'), (28, 'Vanuatu', 'VUT', '+678', '🇻🇺'), (29, 'Bosnia & Herzegovina', 'BIH', '+387', '🇧🇦'), (30, 'Bulgaria', 'BGR', '+359', '🇧🇬'), (31, 'Andorra', 'AND', '+376', '🇦🇩'), (32, 'Czech Republic', 'CZE', '+420', '🇨🇿'), (33, 'Denmark', 'DNK', '+45', '🇩🇰'), (34, 'Austria', 'AUT', '+43', '🇦🇹'), (35, 'Germany', 'DEU', '+49', '🇩🇪'), (36, 'Liechtenstein', 'LIE', '+423', '🇱🇮'), (37, 'Switzerland', 'CHE', '+41', '🇨🇭'), (38, 'Maldives', 'MDV', '+960', '🇲🇻'), (39, 'Bhutan', 'BTN', '+975', '🇧🇹'), (40, 'Greece', 'GRC', '+30', '🇬🇷'), (41, 'Cyprus', 'CYP', '+357', '🇨🇾'), (42, 'Anguilla', 'AIA', '+1 264', '🇦🇮'), (43, 'Antigua And Barbuda', 'ATG', '+1 268', '🇦🇬'), (44, 'Australia', 'AUS', '+61', '🇦🇺'), (45, 'Bahamas', 'BHS', '+1 242', '🇧🇸'), (46, 'Barbados', 'BRB', '+1 246', '🇧🇧'), (47, 'Belize', 'BLZ', '+501', '🇧🇿'), (48, 'Bermuda', 'BMU', '+1 441', '🇧🇲'), (49, 'British Indian Ocean Territory', 'IOT', '+246', '🇮🇴'), (50, 'Cayman Islands', 'CYM', '+1 345', '🇰🇾'), (51, 'Christmas Island', 'CXR', '+61', '🇨🇽'), (52, 'Cocos (Keeling) Islands', 'CCK', '+61', '🇨🇨'), (53, 'Dominica', 'DMA', '+1 767', '🇩🇲'), (54, 'Falkland Islands', 'FLK', '+500', '🇫🇰'), (55, 'Gambia', 'GMB', '+220', '🇬🇲'), (56, 'Ghana', 'GHA', '+233', '🇬🇭'), (57, 'Gibraltar', 'GIB', '+350', '🇬🇮'), (58, 'Grenada', 'GRD', '+473', '🇬🇩'), (59, 'Guam', 'GUM', '+1 671', '🇬🇺'), (60, 'Guyana', 'GUY', '+592', '🇬🇾'), (61, 'Jamaica', 'JAM', '+1 876', '🇯🇲'), (62, 'Kiribati', 'KIR', '+686', '🇰🇮'), (63, 'Liberia', 'LBR', '+231', '🇱🇷'), (64, 'Micronesia, Federated States Of', 'FSM', '+691', '🇫🇲'), (65, 'Namibia', 'NAM', '+264', '🇳🇦'), (66, 'New Zealand', 'NZL', '+64', '🇳🇿'), (67, 'Nigeria', 'NGA', '+234', '🇳🇬'), (68, 'Niue', 'NIU', '+683', '🇳🇺'), (69, 'Norfolk Island', 'NFK', '+672', '🇳🇫'), (70, 'Northern Mariana Islands', 'MNP', '+1 670', '🇲🇵'), (71, 'Palau', 'PLW', '+680', '🇵🇼'), (72, 'Papua New Guinea', 'PNG', '+675', '🇵🇬'), (73, 'Philippines', 'PHL', '+63', '🇵🇭'), (74, 'Pitcairn', 'PCN', '+872', '🇵🇳'), (75, 'Saint Helena, Ascension And Tristan Da Cunha', 'SHN', '+290', '🇸🇭'), (76, 'Saint Kitts And Nevis', 'KNA', '+1 869', '🇰🇳'), (77, 'Saint Lucia', 'LCA', '+1 758', '🇱🇨'), (78, 'Saint Pierre And Miquelon', 'SPM', '+508', '🇵🇲'), (79, 'Saint Vincent And The Grenadines', 'VCT', '+1 784', '🇻🇨'), (80, 'Sierra Leone', 'SLE', '+232', '🇸🇱'), (81, 'Solomon Islands', 'SLB', '+677', '🇸🇧'), (82, 'South Georgia And The South Sandwich Islands', 'SGS', NULL, '🇬🇸'), (83, 'South Sudan', 'SSD', '+211', '🇸🇸'), (84, 'Tokelau', 'TKL', '+690', '🇹🇰'), (85, 'Tonga', 'TON', '+676', '🇹🇴'), (86, 'Trinidad And Tobago', 'TTO', '+1 868', '🇹🇹'), (87, 'Turks And Caicos Islands', 'TCA', '+1 649', '🇹🇨'), (88, 'Tuvalu', 'TUV', '+688', '🇹🇻'), (89, 'United States', 'USA', '+1', '🇺🇸'), (90, 'United States Minor Outlying Islands', 'UMI', '+1', '🇺🇲'), (91, 'Virgin Islands (British)', 'VGB', '+1 284', '🇻🇬'), (92, 'Virgin Islands (US)', 'VIR', '+1 340', '🇻🇮'), (93, 'Zambia', 'ZMB', '+260', '🇿🇲'), (94, 'Eritrea', 'ERI', '+291', '🇪🇷'), (95, 'United Kingdom', 'GBR', '+44', '🇬🇧'), (96, 'Fiji', 'FJI', '+679', '🇫🇯'), (97, 'Cameroon', 'CMR', '+237', '🇨🇲'), (98, 'Canada', 'CAN', '+1', '🇨🇦'), (99, 'Jersey', 'JEY', '+44', '🇯🇪'),
    (100, 'Mauritius', 'MUS', '+230', '🇲🇺'), (101, 'Seychelles', 'SYC', '+248', '🇸🇨'), (102, 'Rwanda', 'RWA', '+250', '🇷🇼'), (103, 'Ireland', 'IRL', '+353', '🇮🇪'), (104, 'Isle Of Man', 'IMN', '+44', '🇮🇲'), (105, 'India', 'IND', '+91', '🇮🇳'), (106, 'Marshall Islands', 'MHL', '+692', '🇲🇭'), (107, 'Cook Islands', 'COK', '+682', '🇨🇰'), (108, 'Nauru', 'NRU', '+674', '🇳🇷'), (109, 'Malawi', 'MWI', '+265', '🇲🇼'), (110, 'American Samoa', 'ASM', '+1 684', '🇦🇸'), (111, 'Samoa', 'WSM', '+685', '🇼🇸'), (112, 'Zimbabwe', 'ZWE', '+263', '🇿🇼'), (113, 'Lesotho', 'LSO', '+266', '🇱🇸'), (114, 'Swaziland', 'SWZ', '+268', '🇸🇿'), (115, 'Kenya', 'KEN', '+254', '🇰🇪'), (116, 'Uganda', 'UGA', '+256', '🇺🇬'), (117, 'Botswana', 'BWA', '+267', '🇧🇼'), (118, 'Singapore', 'SGP', '+65', '🇸🇬'), (119, 'Estonia', 'EST', '+372', '🇪🇪'), (120, 'Faroe Islands', 'FRO', '+298', '🇫🇴'), (121, 'Iran, Islamic Republic Of', 'IRN', '+98', '🇮🇷'), (122, 'Finland', 'FIN', '+358', '🇫🇮'), (123, 'Benin', 'BEN', '+229', '🇧🇯'), (124, 'Burkina Faso', 'BFA', '+226', '🇧🇫'), (125, 'Burundi', 'BDI', '+257', '🇧🇮'), (126, 'Côte d''Ivoire', 'CIV', '+225', '🇨🇮'), (127, 'France', 'FRA', '+33', '🇫🇷'), (128, 'French Guiana', 'GUF', '+594', '🇬🇫'), (129, 'French Polynesia', 'PYF', '+689', '🇵🇫'), (130, 'French Southern Territories', 'ATF', NULL, '🇹🇫'), (131, 'Gabon', 'GAB', '+241', '🇬🇦'), (132, 'Guadeloupe', 'GLP', '+590', '🇬🇵'), (133, 'Guernsey', 'GGY', '+44', '🇬🇬'), (134, 'Guinea', 'GIN', '+224', '🇬🇳'), (135, 'Mali', 'MLI', '+223', '🇲🇱'), (136, 'Mayotte', 'MYT', '+262', '🇾🇹'), (137, 'Monaco', 'MCO', '+377', '🇲🇨'), (138, 'New Caledonia', 'NCL', '+687', '🇳🇨'), (139, 'Niger', 'NER', '+227', '🇳🇪'), (140, 'Reunion', 'REU', '+262', '🇷🇪'), (141, 'Saint Barthélemy', 'BLM', '+590', '🇧🇱'), (142, 'Saint Martin', 'MAF', '+590', '🇲🇫'), (143, 'Senegal', 'SEN', '+221', '🇸🇳'), (144, 'Togo', 'TGO', '+228', '🇹🇬'), (145, 'Wallis And Futuna', 'WLF', '+681', '🇼🇫'), (146, 'Luxembourg', 'LUX', '+352', '🇱🇺'), (147, 'Haiti', 'HTI', '+509', '🇭🇹'), (148, 'Republic Of Congo', 'COG', '+242', '🇨🇬'), (149, 'Democratic Republic Of Congo', 'COD', '+243', '🇨🇩'), (150, 'Madagascar', 'MDG', '+261', '🇲🇬'), (151, 'Central African Republic', 'CAF', '+236', '🇨🇫'), (152, 'Israel', 'ISR', '+972', '🇮🇱'), (153, 'Croatia', 'HRV', '+385', '🇭🇷'), (154, 'Hungary', 'HUN', '+36', '🇭🇺'), (155, 'Armenia', 'ARM', '+374', '🇦🇲'), (156, 'Indonesia', 'IDN', '+62', '🇮🇩'), (157, 'Iceland', 'ISL', '+354', '🇮🇸'), (158, 'Italy', 'ITA', '+39', '🇮🇹'), (159, 'San Marino', 'SMR', '+378', '🇸🇲'), (160, 'Vatican City State', 'VAT', '+379,+39', '🇻🇦'), (161, 'Japan', 'JPN', '+81', '🇯🇵'), (162, 'Greenland', 'GRL', '+299', '🇬🇱'), (163, 'Georgia', 'GEO', '+995', '🇬🇪'), (164, 'Kazakhstan', 'KAZ', '+7,+7 6,+7 7', '🇰🇿'), (165, 'Cambodia', 'KHM', '+855', '🇰🇭'), (166, 'Korea, Democratic People''s Republic Of', 'PRK', '+850', '🇰🇵'), (167, 'Korea, Republic Of', 'KOR', '+82', '🇰🇷'), (168, 'Lao People''s Democratic Republic', 'LAO', '+856', '🇱🇦'), (169, 'Latvia', 'LVA', '+371', '🇱🇻'), (170, 'Lithuania', 'LTU', '+370', '🇱🇹'), (171, 'Macedonia, The Former Yugoslav Republic Of', 'MKD', '+389', '🇲🇰'), (172, 'Malta', 'MLT', '+356', '🇲🇹'), (173, 'Mongolia', 'MNG', '+976', '🇲🇳'), (174, 'Montenegro', 'MNE', '+382', '🇲🇪'), (175, 'Brunei Darussalam', 'BRN', '+673', '🇧🇳'), (176, 'Malaysia', 'MYS', '+60', '🇲🇾'), (177, 'Myanmar', 'MMR', '+95', '🇲🇲'), (178, 'Nepal', 'NPL', '+977', '🇳🇵'), (179, 'Aruba', 'ABW', '+297', '🇦🇼'), (180, 'Bonaire, Saint Eustatius And Saba', 'BES', '+599', '🇧🇶'), (181, 'Curacao', 'CUW', '+599', '🇨🇼'), (182, 'Netherlands', 'NLD', '+31', '🇳🇱'), (183, 'Sint Maarten', 'SXM', '+1 721', '🇸🇽'), (184, 'Suriname', 'SUR', '+597', '🇸🇷'), (185, 'Belgium', 'BEL', '+32', '🇧🇪'), (186, 'Norway', 'NOR', '+47', '🇳🇴'), (187, 'Poland', 'POL', '+48', '🇵🇱'), (188, 'Angola', 'AGO', '+244', '🇦🇴'), (189, 'Brazil', 'BRA', '+55', '🇧🇷'), (190, 'Cabo Verde', 'CPV', '+238', '🇨🇻'), (191, 'Guinea-bissau', 'GNB', '+245', '🇬🇼'), (192, 'Mozambique', 'MOZ', '+258', '🇲🇿'), (193, 'Portugal', 'PRT', '+351', '🇵🇹'), (194, 'Sao Tome and Principe', 'STP', '+239', '🇸🇹'), (195, 'Timor-Leste, Democratic Republic of', 'TLS', '+670', '🇹🇱'), (196, 'Afghanistan', 'AFG', '+93', '🇦🇫'), (197, 'Moldova', 'MDA', '+373', '🇲🇩'), (198, 'Romania', 'ROU', '+40', '🇷🇴'), (199, 'Kyrgyzstan', 'KGZ', '+996', '🇰🇬'),
    (200, 'Russian Federation', 'RUS', '+7,+7 3,+7 4,+7 8', '🇷🇺'), (201, 'Sri Lanka', 'LKA', '+94', '🇱🇰'), (202, 'Slovakia', 'SVK', '+421', '🇸🇰'), (203, 'Slovenia', 'SVN', '+386', '🇸🇮'), (204, 'Somalia', 'SOM', '+252', '🇸🇴'), (205, 'Argentina', 'ARG', '+54', '🇦🇷'), (206, 'Chile', 'CHL', '+56', '🇨🇱'), (207, 'Colombia', 'COL', '+57', '🇨🇴'), (208, 'Costa Rica', 'CRI', '+506', '🇨🇷'), (209, 'Cuba', 'CUB', '+53', '🇨🇺'), (210, 'Dominican Republic', 'DOM', '+1 809,+1 829,+1 849', '🇩🇴'), (211, 'El Salvador', 'SLV', '+503', '🇸🇻'), (212, 'Guatemala', 'GTM', '+502', '🇬🇹'), (213, 'Honduras', 'HND', '+504', '🇭🇳'), (214, 'Mexico', 'MEX', '+52', '🇲🇽'), (215, 'Nicaragua', 'NIC', '+505', '🇳🇮'), (216, 'Panama', 'PAN', '+507', '🇵🇦'), (217, 'Paraguay', 'PRY', '+595', '🇵🇾'), (218, 'Spain', 'ESP', '+34', '🇪🇸'), (219, 'Uruguay', 'URY', '+598', '🇺🇾'), (220, 'Venezuela, Bolivarian Republic Of', 'VEN', '+58', '🇻🇪'), (221, 'Bolivia, Plurinational State Of', 'BOL', '+591', '🇧🇴'), (222, 'Peru', 'PER', '+51', '🇵🇪'), (223, 'Puerto Rico', 'PRI', '+1 787,+1 939', '🇵🇷'), (224, 'Equatorial Guinea', 'GNQ', '+240', '🇬🇶'), (225, 'Ecuador', 'ECU', '+593', '🇪🇨'), (226, 'Albania', 'ALB', '+355', '🇦🇱'), (227, 'Serbia', 'SRB', '+381', '🇷🇸'), (228, 'Tanzania, United Republic Of', 'TZA', '+255', '🇹🇿'), (229, 'Sweden', 'SWE', '+46', '🇸🇪'), (230, 'Åland Islands', 'ALA', '+358', '🇦🇽'), (231, 'Tajikistan', 'TJK', '+992', '🇹🇯'), (232, 'Thailand', 'THA', '+66', '🇹🇭'), (233, 'Turkmenistan', 'TKM', '+993', '🇹🇲'), (234, 'Turkey', 'TUR', '+90', '🇹🇷'), (235, 'Ukraine', 'UKR', '+380', '🇺🇦'), (236, 'Pakistan', 'PAK', '+92', '🇵🇰'), (237, 'Uzbekistan', 'UZB', '+998', '🇺🇿'), (238, 'Viet Nam', 'VNM', '+84', '🇻🇳'), (239, 'China', 'CHN', '+86', '🇨🇳'), (240, 'Taiwan', 'TWN', '+886', '🇹🇼'), (241, 'Hong Kong', 'HKG', '+852', '🇭🇰'), (242, 'Macao', 'MAC', '+853', '🇲🇴'), (243, 'Antarctica', 'ATA', '+672', '🇦🇶'), (244, 'Bouvet Island', 'BVT', NULL, '🇧🇻'), (245, 'Heard Island And McDonald Islands', 'HMD', NULL, '🇭🇲'), (246, 'Martinique', 'MTQ', '+596', '🇲🇶'), (247, 'Montserrat', 'MSR', '+1 664', '🇲🇸'), (248, 'Svalbard And Jan Mayen', 'SJM', '+47', '🇸🇯'), (249, 'Western Sahara', 'ESH', '+212', '🇪🇭');

INSERT INTO :auth_schema.user(name, username, email, password, project_id, password_reset_needed, secret_2fa, enable_2fa, provider)
VALUES ('root', 'root', 'root@liveobjects.ai', null, 1, TRUE, '3ZYMZNAMQGRNSTEJ', FALSE, 'local');

INSERT INTO :auth_schema.user(name, username, email, password, project_id, password_reset_needed, secret_2fa, enable_2fa, provider)
VALUES ('admin', 'admin', 'support@liveobjects.ai', null, 1, TRUE, '3ZYMZNAMQGRNSTEJ', FALSE, 'local');

INSERT INTO :auth_schema.user(name, username, email, password, project_id, password_reset_needed, secret_2fa, enable_2fa, provider)
VALUES ('license_admin', 'license_admin', 'licences@liveobjects.ai', null, 1, TRUE, '3ZYMZNAMQGRNSTEJ', FALSE, 'local');

INSERT INTO :auth_schema.user(name, username, email, password, project_id, password_reset_needed, secret_2fa, enable_2fa, provider)
VALUES ('system_admin', 'system_admin', 'system_admin@liveobjects.ai', null, 1, TRUE, '3ZYMZNAMQGRNSTEJ', FALSE, 'local');
-- Add appropiate roles to the users
-- Create a "root" user with complete access to create and delete databases
INSERT INTO :auth_schema.user_project_role(user_id, project_id, role_id) VALUES(1, 1, 4);
-- Create an "admin" user for the 1st project. With the ability to create new users only there. 
-- Also allows for backward compatibility with for single "liveobjects" db deployments.
INSERT INTO :auth_schema.user_project_role(user_id, project_id, role_id) VALUES(2, 1, 1);
-- Create a "licence admin" user that can log in and set the app's licence
INSERT INTO :auth_schema.user_project_role(user_id, project_id, role_id) VALUES(3, 1, 5);
-- Create a "system_admin" user that can log in and set the app's system manager
INSERT INTO :auth_schema.user_project_role(user_id, project_id, role_id) VALUES(4, 1, 6);

-- Added for backwards compatibility in 1.8
INSERT INTO :auth_schema.user_role(user_id, role_id) VALUES(2, 1);
INSERT INTO :auth_schema.user_role(user_id, role_id) VALUES(3, 5);

-- ANCHOR: - Initial menu_items RBAC
-- ROLE_LICENCE_ADMIN
    INSERT INTO 
        :auth_schema.authorizations(namespace, project_id, resource_id, object_id, type_id, object_value, direction_id, sequence, status_id, record_type_id)
    VALUES 
        -- home
        ('1', 1, 1, 2, 3, 5, 1, 9000, 1, 1),
        -- settings
        ('1', 1, 11, 2, 3, 5, 1, 9000, 1, 1),
        -- license manager
        ('1', 1, 12, 2, 3, 5, 1, 9000, 1, 1);

-- ROLE_ADMIN
    INSERT INTO
        :auth_schema.authorizations(namespace, project_id, resource_id, object_id, type_id, object_value, direction_id, sequence, status_id, record_type_id)
    VALUES
        -- home
        ('1', 1, 1, 2, 3, 1, 1, 9000, 1, 1),
        -- data wrangling
        ('1', 1, 2, 2, 3, 1, 1, 9000, 1, 1),
        -- data wrangling > connectors
        ('1', 1, 3, 2, 3, 1, 1, 9000, 1, 1),
        -- data wrangling > scenario
        ('1', 1, 4, 2, 3, 1, 1, 9000, 1, 1),
        -- data wrangling > datasources
        ('1', 1, 5, 2, 3, 1, 1, 9000, 1, 1),
        -- data wrangling > load data
        ('1', 1, 6, 2, 3, 1, 1, 9000, 1, 1),
        -- discovery
        ('1', 1, 7, 2, 3, 1, 1, 9000, 1, 1),
        -- discovery > process discovery
        ('1', 1, 8, 2, 3, 1, 1, 9000, 1, 1),
        -- ai
        ('1', 1, 9, 2, 3, 1, 1, 9000, 1, 1),
        -- ai > enrichment
        ('1', 1, 10, 2, 3, 1, 1, 9000, 1, 1),
        -- ai > business dictionaries
        ('1', 1, 22, 2, 3, 1, 1, 9000, 1, 1),
        -- settings
        ('1', 1, 11, 2, 3, 1, 1, 9000, 1, 1),
        -- administration
        ('1', 1, 15, 2, 3, 1, 1, 9000, 1, 1),
        -- manage users
        ('1', 1, 16, 2, 3, 1, 1, 9000, 1, 1),
        -- system configuration
        ('1', 1, 17, 2, 3, 1, 1, 9000, 1, 1),
        -- process exploration
        ('1', 1, 19, 2, 3, 1, 1, 9000, 1, 1),
        -- all
        ('1', 1, 25, 2, 3, 1, 1, 9000, 1, 1);

-- ROLE_USER
    INSERT INTO 
        :auth_schema.authorizations(namespace, project_id, resource_id, object_id, type_id, object_value, direction_id, sequence, status_id, record_type_id)
    VALUES 
        -- home
        ('1', 1, 1, 2, 3, 2, 1, 9000, 1, 1),
        -- settings
        ('1', 1, 11, 2, 3, 2, 1, 9000, 1, 1);

-- ROLE_MODEL_VIEWER
    INSERT INTO 
        :auth_schema.authorizations(namespace, project_id, resource_id, object_id, type_id, object_value, direction_id, sequence, status_id, record_type_id)
    VALUES 
        -- home
        ('1', 1, 1, 2, 3, 3, 1, 9000, 1, 1),
        -- data wrangling
        ('1', 1, 2, 2, 3, 3, 1, 9000, 1, 1),
        -- data wrangling > connectors
        ('1', 1, 3, 2, 3, 3, 1, 9000, 1, 1),
        -- data wrangling > scenario
        ('1', 1, 4, 2, 3, 3, 1, 9000, 1, 1),
        -- data wrangling > datasources
        ('1', 1, 5, 2, 3, 3, 1, 9000, 1, 1),
        -- ai
        ('1', 1, 9, 2, 3, 3, 1, 9000, 1, 1),
        -- ai > enrichment
        ('1', 1, 10, 2, 3, 3, 1, 9000, 1, 1),
        -- settings
        ('1', 1, 11, 2, 3, 3, 1, 9000, 1, 1);

-- ROLE_ROOT
    INSERT INTO
        :auth_schema.authorizations(namespace, project_id, resource_id, object_id, type_id, object_value, direction_id, sequence, status_id, record_type_id)
    VALUES
        -- home
        ('1', 1, 1, 2, 3, 4, 1, 9000, 1, 1),
        -- settings
        ('1', 1, 11, 2, 3, 4, 1, 9000, 1, 1),
        -- manage projects
        ('1', 1, 18, 2, 3, 4, 1, 9000, 1, 1);

-- ROLE_SYSTEM_ADMIN
    INSERT INTO
        :auth_schema.authorizations(namespace, project_id, resource_id, object_id, type_id, object_value, direction_id, sequence, status_id, record_type_id)
    VALUES
        -- home
        ('1', 1, 1, 2, 3, 6, 1, 9000, 1, 1),
        -- settings
        ('1', 1, 11, 2, 3, 6, 1, 9000, 1, 1),
        -- system manager
        ('1', 1, 13, 2, 3, 6, 1, 9000, 1, 1),
        -- commit log
        ('1', 1, 14, 2, 3, 6, 1, 9000, 1, 1),
        -- configuration
        ('1', 1, 20, 2, 3, 6, 1, 9000, 1, 1),
        -- configuration > authorization
        ('1', 1, 21, 2, 3, 6, 1, 9000, 1, 1),
        -- administration
        ('1', 1, 15, 2, 3, 6, 1, 9000, 1, 1),
        -- administration > system configuration
        ('1', 1, 17, 2, 3, 6, 1, 9000, 1, 1);

 create table if not exists auth.namespace(
id serial not null,
namespace varchar(64) not null,
namespace_description varchar(182),
record_type              varchar(64),
record_status            varchar(32),
last_update_timestamptz  timestamptz,
last_update_user         integer,
primary key (id)
)
;

insert into auth.namespace(
namespace,
namespace_description,
record_type,
record_status,
last_update_timestamptz,
last_update_user)
values (
'lo',
'Default liveobject namespace',
'SYSTEM',
'ACTIVE',
now(),
1)
;

create table auth.license_status(
status_id int not null,
status_text text not null,
record_type              varchar(64),
record_status            varchar(32),
last_update_timestamptz  timestamptz,
last_update_user         integer,
primary key (status_id)
);
insert into auth.license_status(status_id,status_text,record_type,record_status,last_update_timestamptz,last_update_user)
values
(1,'Active','SYSTEM','Active',now(),1),
(2,'Expired','SYSTEM','Active',now(),1),
(3,'Inactive','SYSTEM','Active',now(),1)
;

create table auth.license_file(
id int not null,
license_file text not null,
create_date timestamptz not null,
update_date timestamptz not null,
status_id int references auth.license_status(status_id) not null,
license_in_bytea bytea,
record_type              varchar(64),
record_status            varchar(32),
last_update_timestamptz  timestamptz,
last_update_user         integer,
primary key (id)
)
;

COMMIT;