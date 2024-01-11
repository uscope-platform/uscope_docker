-- Copyright 2021 University of Nottingham Ningbo China
-- Author: Filippo Savi <filssavi@gmail.com>
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.


-- CREATE ROLE uscope
CREATE USER uscope WITH PASSWORD 'test';

-- CREATE DATABASE uscope, GIVE ALL PERMISSIONS AND OWNERSHIP TO USER uscope

CREATE DATABASE uscope;
GRANT ALL PRIVILEGES ON DATABASE uscope TO uscope;
ALTER DATABASE uscope OWNER TO uscope;

-- CHANGE TO uscope database as uscope role

\c uscope uscope

-- CREATE uscope SCHEMA

CREATE SCHEMA uscope AUTHORIZATION uscope;
grant usage on schema uscope TO uscope;
grant create on schema uscope TO uscope;

-- CHANGE DEFAULT SCHEMA

SET search_path TO uscope;

-- CREATE USERS TABLE

create table users
(
	username text not null
		constraint users_pk
			primary key,
	pw_hash text not null,
	role text not null
);

alter table users owner to uscope;

create unique index users_username_uindex
	on users (username);


-- CREATE LOGIN_TOKENS TABLE

create table login_tokens
(
    username  text
        constraint login_tokens_users_username_fk
            references users
            on update cascade on delete cascade,
    expiry    timestamp,
    validator text,
    selector  text not null
        constraint login_tokens_pk
            primary key
);

alter table login_tokens
    owner to uscope;

-- CREATE PROGRAMS TABLE

create table programs
(
    id      integer not null
        constraint programs_pk
            primary key,
    name    text,
    content text,
    type    text,
    hex     bigint[],
    build_settings jsonb,
    cached_bin_version text
);

alter table programs
    owner to uscope;

create unique index programs_id_uindex
    on programs (id);


-- CREATE SCRIPTS TABLE


create table scripts
(
    id       integer not null
        constraint scripts_pk
            primary key,
    name     text,
    path     text,
    content  text,
    triggers text
);

alter table scripts
    owner to uscope;

create unique index scripts_id_uindex
    on scripts (id);

-- CREATE DATA_VERSIONS TABLE

create table data_versions
(
    "table"       text not null
        constraint data_versions_pk
            primary key,
    version       uuid,
    last_modified timestamp
);

alter table data_versions
    owner to uscope;

create unique index data_versions_table_uindex
    on data_versions ("table");

create unique index data_versions_version_uindex
    on data_versions (version);


-- CREATE APPLICATIONS TABLE

create table applications
(
	application_name text not null,
	bitstream text,
	clock_frequency bigint default 100000000,
	channels jsonb,
	channel_groups jsonb,
	initial_registers_values jsonb,
	macro jsonb,
	parameters jsonb,
	peripherals jsonb,
    miscellaneous jsonb,
    soft_cores jsonb,
    filters jsonb,
    programs text[],
    scripts text[],
    id                       serial
        constraint applications_pk
            primary key
);

alter table applications owner to uscope;

create unique index applications_application_name_uindex
	on applications (application_name);

-- CREATE PERIPHERALS TABLE

create table peripherals
(
	name text not null,
	image text,
    parametric boolean default false not null,
	version text,
	registers jsonb,
    id serial constraint peripherals_pk primary key
);

alter table peripherals owner to uscope;

create unique index peripherals_name_uindex
	on peripherals (name);

-- CREATE APP SETTINGS TABLE

create table app_settings
(
	name text not null
		constraint app_settings_pk
			primary key,
	value jsonb,
	"user" text
		constraint user_settings_key
			references users
				on update cascade on delete cascade
);

alter table app_settings owner to uscope;

create unique index app_settings_name_uindex
	on app_settings (name);

-- CREATE BITSTREAM TABLE

create table bitstreams
(
    id   integer not null,
    path text    not null
);

alter table bitstreams
    owner to uscope;

create unique index bitstreams_id_uindex
    on bitstreams (id);

-- CREATE FILTERS TABLE

create table filters
(
    id integer not null
        constraint filters_pk
            primary key,
    name text,
    parameters jsonb,
    ideal_taps     double precision[],
    quantized_taps integer[]
);

alter table filters
    owner to uscope;

-- CREATE EMULATORS TABLE

create table emulators
(
    name        text,
    cores       jsonb,
    id          integer not null
        constraint emulators_pk
            primary key,
    connections jsonb[],
    n_cycles    integer
);

alter table emulators
    owner to uscope;

-- CREATE STORED FUNCTION TO UPDATE THE TABLE VERSION

create function update_version() returns trigger as $$ begin
insert into data_versions("table", version, last_modified) values (TG_ARGV[0], gen_random_uuid(),CURRENT_TIMESTAMP)
on conflict("table") do update set version=excluded.version, last_modified=excluded.last_modified;
return new;
end;
$$ language plpgsql;


-- CREATE TRIGGERS TO BUMP TABLE VERSIONS

create trigger bump_application_version
after insert or delete or update on applications
execute procedure update_version('Applications');

create trigger bump_bitstreams_version
after insert or delete or update on bitstreams
execute procedure update_version('bitstreams');

create trigger bump_peripherals_version
after insert or delete or update on peripherals
execute procedure update_version('Peripherals');

create trigger bump_programs_version
after insert or delete or update on programs
execute procedure update_version('programs');

create trigger bump_scripts_version
after insert or delete or update on scripts
execute procedure update_version('scripts');

create trigger bump_filters_version
after insert or delete or update on filters
execute procedure update_version('filters');

create trigger bump_emulators_version
after insert or delete or update on emulators
execute procedure update_version('emulators');


-- initialize data versions table

insert into data_versions("table", version, last_modified) values ('Applications', gen_random_uuid(),CURRENT_TIMESTAMP);
insert into data_versions("table", version, last_modified) values ('bitstreams', gen_random_uuid(),CURRENT_TIMESTAMP);
insert into data_versions("table", version, last_modified) values ('Peripherals', gen_random_uuid(),CURRENT_TIMESTAMP);
insert into data_versions("table", version, last_modified) values ('programs', gen_random_uuid(),CURRENT_TIMESTAMP);
insert into data_versions("table", version, last_modified) values ('scripts', gen_random_uuid(),CURRENT_TIMESTAMP);
insert into data_versions("table", version, last_modified) values ('filters', gen_random_uuid(),CURRENT_TIMESTAMP);
insert into data_versions("table", version, last_modified) values ('emulators', gen_random_uuid(),CURRENT_TIMESTAMP);