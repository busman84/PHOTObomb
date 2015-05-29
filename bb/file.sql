
CREATE TABLE users (
   id serial primary key,
   user_name text NOT NULL UNIQUE,
   email text NOT NULL UNIQUE,
   password_digest text NOT NULL
);

CREATE TABLE uploads (
   id serial primary key,
   photo text NOT NULL,
   user_id integer
);
