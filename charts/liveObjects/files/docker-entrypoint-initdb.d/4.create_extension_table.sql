create schema if not exists extension;

create table if not exists extension.extension_category(
id serial not null,
category_name varchar(64) not null,
description varchar(256) not null,
record_type              varchar(64),
record_status            varchar(32),
last_update_timestamptz  timestamptz,
last_update_user         integer,
primary key (id)
);

create table extension.extension_type(
id serial not null,
extension_type_name varchar(64) not null,
extension_type_description varchar(128) ,
record_type              varchar(64),
record_status            varchar(32),
last_update_timestamptz  timestamptz,
last_update_user         integer,
primary key (id)
);

create table if not exists extension.extension(
id serial not null,
extension_category_id int references extension.extension_category(id) not null,
namespace_id int references auth.namespace(id) not null,
extension_type_id int references extension.extension_type(id) not null,
extension_name varchar(64) not null,
description varchar(256) not null,
overview text,
about varchar(128),
logo_file_name varchar(128) not null,
logo_content_in_bytea bytea,
extension_status varchar(16) not null, --install, activate, deactivate,uninstalled
extension_cost numeric(20,2),
record_type              varchar(64),
record_status            varchar(32),
last_update_timestamptz  timestamptz,
last_update_user         integer,
primary key (id)
);

create table if not exists extension.extension_library(
id serial not null,
extension_id int references extension.extension(id) not null,
library_file_name varchar(64) not null,
file_type varchar(12),
library_content_in_bytea bytea,
record_type              varchar(64),
record_status            varchar(32),
last_update_timestamptz  timestamptz,
last_update_user         integer,
primary key (id)
);

insert into extension.extension_category (
category_name,
description,
record_type,
record_status,
last_update_timestamptz,
last_update_user)
values(
'Developer Tools',
'Developer tools',
'SYSTEM',
'ACTIVE',
now(),
1);

insert into extension.extension_type(
extension_type_name,
extension_type_description,
record_type,
record_status,
last_update_timestamptz,
last_update_user)
values (
'connector',
'data source connector',
'SYSTEM',
'ACTIVE',
now(),
1)
;

commit;