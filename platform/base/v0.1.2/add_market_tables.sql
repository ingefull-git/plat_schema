-- kind: plan
-- schema: platform
-- version: v0.0.2

BEGIN;

CREATE SCHEMA IF NOT EXISTS platform;

SET search_path TO platform;


CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);

COMMIT;