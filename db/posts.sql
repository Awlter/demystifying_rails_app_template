CREATE TABLE "posts" (
  "id"         INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  "title"      varchar,
  "body"       text,
  "author"     varchar,
  "create_at"  datetime NOT NULL
);