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
