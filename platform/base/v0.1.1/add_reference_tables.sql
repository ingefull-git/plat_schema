-- kind: plan
-- schema: platform
-- version: v0.1.1

BEGIN;

SET search_path TO platform;


CREATE TABLE IF NOT EXISTS refers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(250)
);

COMMIT;