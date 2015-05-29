
CREATE TABLE users (
   id serial primary key,
   user_name text NOT NULL UNIQUE,
   email text NOT NULL UNIQUE,
   password_digest text NOT NULL
);
