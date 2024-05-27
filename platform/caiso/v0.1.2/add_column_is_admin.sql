-- kind: plan
-- schema: platform
-- version: v0.0.2

BEGIN;

ALTER TABLE platform.users ADD COLUMN is_admin BOOLEAN NOT NULL DEFAULT False;

COMMIT;