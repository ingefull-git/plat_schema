-- kind: plan
-- schema: platform
-- version: v0.1.1

BEGIN;

ALTER TABLE platform.users ADD COLUMN created_on timestamptz NOT NULL DEFAULT now();

COMMIT;