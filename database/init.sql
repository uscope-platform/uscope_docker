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
    path    text,
    content text,
    type    text,
    hex     bigint[]
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
	application_name text not null
		constraint applications_pk
			primary key,
	bitstream text,
	clock_frequency bigint default 100000000,
	channels jsonb,
	channel_groups jsonb,
	initial_registers_values jsonb,
	macro jsonb,
	parameters jsonb,
	peripherals jsonb,
    miscellaneous jsonb
);

alter table applications owner to uscope;

create unique index applications_application_name_uindex
	on applications (application_name);

-- CREATE PERIPHERALS TABLE

create table peripherals
(
	name text not null
		constraint peripherals_pk
			primary key,
	image text,
	version text,
	registers jsonb
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
