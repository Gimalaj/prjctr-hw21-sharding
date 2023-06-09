CREATE TABLE books (
                       id bigint not null,
                       category_id  int not null,
                       author character varying not null,
                       title character varying not null,
                       year int not null );

ALTER TABLE "books"
    ADD CONSTRAINT "books_id" PRIMARY KEY ("id");
CREATE INDEX "books_category_id" ON "books" ("category_id");

CREATE EXTENSION postgres_fdw;

CREATE SERVER books_1_server
FOREIGN DATA WRAPPER postgres_fdw
OPTIONS( host 'pg-s1', port '5432', dbname 'postgres' );

CREATE USER MAPPING FOR postgres
SERVER books_1_server
OPTIONS (user 'postgres', password 'postgres');

CREATE FOREIGN TABLE books_1 (
id bigint not null,
category_id  int not null,
author character varying not null,
title character varying not null,
year int not null )
SERVER books_1_server
OPTIONS (schema_name 'public', table_name 'books');

CREATE SERVER books_2_server
FOREIGN DATA WRAPPER postgres_fdw
OPTIONS( host 'pg-s2', port '5432', dbname 'postgres' );

CREATE USER MAPPING FOR postgres
SERVER books_2_server
OPTIONS (user 'postgres', password 'postgres');

CREATE FOREIGN TABLE books_2 (
id bigint not null,
category_id  int not null,
author character varying not null,
title character varying not null,
year int not null )
SERVER books_2_server
OPTIONS (schema_name 'public', table_name 'books');

CREATE VIEW all_books AS
SELECT * FROM books_1
UNION ALL
SELECT * FROM books_2
UNION ALL
SELECT * FROM books;

CREATE RULE books_insert_to_1 AS ON INSERT TO books
WHERE ( category_id = 1 )
DO INSTEAD INSERT INTO books_1 VALUES (NEW.*);

CREATE RULE books_insert_to_2 AS ON INSERT TO books
WHERE ( category_id = 2 )
DO INSTEAD INSERT INTO books_2 VALUES (NEW.*);


