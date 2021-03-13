CREATE USER uscope WITH PASSWORD 'test';
CREATE DATABASE uscope;
GRANT ALL PRIVILEGES ON DATABASE uscope TO uscope;

ALTER DATABASE uscope OWNER TO uscope;
\c uscope uscope

CREATE SCHEMA uscope AUTHORIZATION uscope;
grant usage on schema uscope TO uscope;
grant create on schema uscope TO uscope;

SET search_path TO uscope;

create table uscope.users
(
    username text not null
        constraint users_pk
            primary key,
    pw_hash  text not null
);

alter table users
    owner to uscope;

create unique index users_username_uindex
    on users (username);

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

create table programs
(
    id      integer not null
        constraint programs_pk
            primary key,
    name    text,
    path    text,
    content text,
    type    text,
    hex     integer[]
);

alter table programs
    owner to uscope;

create unique index programs_id_uindex
    on programs (id);

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

create table hashes
(
    type  text not null
        constraint hashes_pk
            primary key,
    value text
);

alter table hashes
    owner to uscope;

create unique index hashes_type_uindex
    on hashes (type);

