CREATE TABLE pants (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

INSERT INTO
pants (id, name)
VALUES
(1, "Grey"),
(2, "George"),
(3, "Mr. Pants");

CREATE TABLE shoes (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  pant_id INTEGER
);

INSERT INTO
shoes (id, name, pant_id)
VALUES
(1, "SuperShoe", 1),
(2, "UltraShoe", 1),
(3, "MasterShoe", 2);

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  email VARCHAR(255) NOT NULL,
  password_digest VARCHAR(255) NOT NULL,
  session_token VARCHAR(255) NOT NULL
);

INSERT INTO
users (id, email, password_digest, session_token)
VALUES
(1, "kingwoodchuckii@gmail.com",
  "$2a$10$3r0HMtUr9Ixhr3oK6DGeNuAlkoTwj75Ghaqch0o5ylPLXaRemJwia",
  "5vMMTEUqRHGD46MHy1C0qA"),
(2, "eviluser@doom.com",
  "$2a$10$RkhO40/MDpTnslPrZUJDP..0ZH//9rIyvVhRKx.cn0EFi.6cRjiSe",
  "QQCXckGwmLMBfN3vjMc9kw");
