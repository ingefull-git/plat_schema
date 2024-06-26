-- kind: plan
-- schema: platform
-- version: v0.1.1

BEGIN;

CREATE SCHEMA IF NOT EXISTS platform;

SET search_path TO platform;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";


CREATE TABLE IF NOT EXISTS asset_data_type (
    id smallint GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name varchar NOT NULL UNIQUE,
    description varchar,
    schema json,
    asset_type_id int,
    created_on timestamptz NOT NULL DEFAULT now()
);

COMMENT ON TABLE asset_data_type
    IS 'This table holds information on different types of asset data';


CREATE TABLE IF NOT EXISTS asset_meter_type (
    id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name varchar UNIQUE,
    description varchar,
    created_on timestamptz NOT NULL DEFAULT now()
);

COMMENT ON TABLE asset_meter_type
    IS 'This table defines all the possible asset meter (telemetry stream) type, like BESS, SCADA, etc.';


CREATE TABLE IF NOT EXISTS cop_limit_type (
    id smallint GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name varchar NOT NULL UNIQUE,
    description varchar,
    created_on timestamptz NOT NULL DEFAULT now()
);

COMMENT ON TABLE cop_limit_type
    IS 'This table defined all the cop limit types.';


CREATE TABLE IF NOT EXISTS cop_status_type (
    id smallint GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name varchar NOT NULL UNIQUE,
    description varchar,
    created_on timestamptz NOT NULL DEFAULT now()
);


CREATE TABLE IF NOT EXISTS registration_type (
    id smallint GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name varchar NOT NULL UNIQUE,
    description varchar,
    created_on timestamptz NOT NULL DEFAULT now()
);

COMMENT ON TABLE registration_type
    IS 'This table defines all the possible registration types in the asset tree including asset_group, asset, and etc...';


CREATE TABLE IF NOT EXISTS resource_type (
    id smallint GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name varchar NOT NULL UNIQUE,
    description varchar,
    created_on timestamptz NOT NULL DEFAULT now()
);

COMMENT ON TABLE resource_type
    IS 'This table defined all the possible resource type, which defined by ISO/RTO.';


CREATE TABLE IF NOT EXISTS process_type (
    id smallint GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name varchar NOT NULL UNIQUE,
    description varchar NOT NULL,
    created_on timestamptz NOT NULL DEFAULT now()
);


CREATE TABLE IF NOT EXISTS product_type (
    id smallint GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name varchar NOT NULL UNIQUE,
    description varchar,
    created_on timestamptz NOT NULL DEFAULT now()
);

COMMENT ON TABLE product_type
    IS 'This table defined the types of the product.';


CREATE TABLE IF NOT EXISTS soc_type (
    id smallint GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name varchar NOT NULL UNIQUE,
    description varchar NULL,
    created_on timestamptz NOT NULL DEFAULT now()
);

COMMENT ON TABLE soc_type
    IS 'This table defined soc types.';


CREATE TABLE IF NOT EXISTS task_type (
    id smallint GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name varchar NOT NULL UNIQUE,
    description varchar,
    created_on timestamptz NOT NULL DEFAULT now()
);


CREATE TABLE IF NOT EXISTS telemetry_value_type (
    id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name varchar NOT NULL UNIQUE,
    description varchar,
    created_on timestamptz NOT NULL DEFAULT now()
);

COMMENT ON TABLE telemetry_value_type
    IS 'This table defines all the possible telemetry value types Mosaic is handling, like SOC, SOE, etc.';


CREATE TABLE IF NOT EXISTS asset_mode (
    id smallint GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name varchar NOT NULL UNIQUE,
    description varchar,
    created_on timestamptz NOT NULL DEFAULT now()
);

COMMENT ON TABLE asset_mode
    IS 'This table defined all the possible asset statuses in Mosaic Platform, like active, inactive.';


CREATE TABLE IF NOT EXISTS host_customer (
    id smallint GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name varchar NOT NULL,
    updated_on timestamptz NOT NULL DEFAULT now(),
    salesforce_record_id varchar,
    quickbase_record_id int,
    scheduling_coordinator_id varchar
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_customer_quickbase_record_id ON host_customer USING btree (quickbase_record_id);
CREATE UNIQUE INDEX IF NOT EXISTS idx_customer_salesforce_record_id ON host_customer USING btree (salesforce_record_id);


CREATE TABLE IF NOT EXISTS iso (
    id smallint GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name varchar NOT NULL UNIQUE,
    display_name varchar NOT NULL UNIQUE,
    time_zone varchar NOT NULL,
    created_on timestamptz NOT NULL DEFAULT now(),
    created_by int NOT NULL,
    last_modified_on timestamptz NOT NULL DEFAULT now(),
    last_modified_by int NOT NULL
);

COMMENT ON TABLE iso
    IS 'This table defined ISO/RTO and some of its related parameters';


CREATE TABLE IF NOT EXISTS market_job_type (
    id smallint GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name varchar NOT NULL UNIQUE,
    description varchar,
    created_on timestamptz NOT NULL DEFAULT now()
);


CREATE TABLE IF NOT EXISTS market_type (
    id smallint GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name varchar NOT NULL UNIQUE,
    description varchar NOT NULL,
    created_on timestamptz NOT NULL DEFAULT now()
);


CREATE TABLE IF NOT EXISTS offer_type (
    id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name varchar NOT NULL UNIQUE,
    description varchar,
    created_on timestamptz NOT NULL DEFAULT now()
);

COMMENT ON TABLE offer_type
    IS 'This tables stores the kinds of Award Offer Types available in the market';


CREATE TABLE IF NOT EXISTS users (
    id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name varchar NOT NULL,
    email varchar NOT NULL UNIQUE,
    title varchar NOT NULL,
    preferences jsonb NOT NULL,
    created_on timestamptz NOT NULL DEFAULT now(),
    is_active bool NOT NULL DEFAULT true,
    has_registered bool NOT NULL DEFAULT false,
    updated_on timestamptz DEFAULT now(),
    phone_number varchar,
    has_mfa bool DEFAULT false,
    slack_user_id varchar,
    external_user_id varchar UNIQUE
);


CREATE TABLE IF NOT EXISTS asset_type (
    id smallint GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name varchar NOT NULL UNIQUE,
    description varchar,
    created_on timestamptz NOT NULL DEFAULT now(),
    asset_registration_type_id int NULL,
    asset_schema jsonb NULL,
    asset_config_schema jsonb NULL,
    FOREIGN KEY (asset_registration_type_id)
        REFERENCES registration_type(id)
);

COMMENT ON TABLE asset_type
    IS 'This table defined all the possible asset type, like wind, solar, battery and etc..';


CREATE TABLE IF NOT EXISTS market (
    id smallint GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name varchar NOT NULL UNIQUE,
    data jsonb NOT NULL DEFAULT '{}'::jsonb,
    description varchar,
    market_type_id smallint NOT NULL,
    created_on timestamptz NOT NULL DEFAULT now(),
    FOREIGN KEY (market_type_id)
        REFERENCES market_type(id)
);

COMMENT ON TABLE market
    IS 'This table defined all the markets that ISO/RTO provided.';


CREATE TABLE IF NOT EXISTS market_agent (
    id smallint GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    iso_id smallint NOT NULL,
    name varchar NOT NULL UNIQUE,
    description varchar,
    market_agent_code varchar NOT NULL,
    market_participant_code varchar,
    api_user varchar,
    password varchar,
    certificate varchar,
    level smallint NOT NULL,
    created_by smallint NOT NULL,
    created_on timestamptz NOT NULL DEFAULT now(),
    last_modified_by smallint NOT NULL,
    last_modified_on timestamptz NOT NULL DEFAULT now(),
    FOREIGN KEY (iso_id)
        REFERENCES iso(id)
);
COMMENT ON TABLE market_agent
    IS 'This table is used to maintain data object for QSE, SC, market participant and etc., they are called different name in different ISO/RTOs.';


CREATE TABLE IF NOT EXISTS market_job (
    id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    scenario_id int,
    market_type_id smallint NOT NULL,
    market_job_type_id smallint NOT NULL,
    associated_run_id smallint,
    job_run_start timestamptz,
    job_run_end timestamptz,
    job_run_status varchar,
    created_on timestamptz NOT NULL DEFAULT now(),
    FOREIGN KEY (market_job_type_id)
        REFERENCES market_job_type(id),
    FOREIGN KEY (market_type_id)
        REFERENCES market_type(id)
);


CREATE TABLE IF NOT EXISTS market_task (
    id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    market_job_id int,
    task_type_id smallint NOT NULL,
    forecast_input_id smallint,
    task_horizon_start timestamptz NOT NULL,
    task_horizon_end timestamptz NOT NULL,
    task_run_start timestamptz NOT NULL,
    task_run_end timestamptz NOT NULL,
    task_run_status varchar NOT NULL,
    log varchar,
    input_data jsonb,
    created_on timestamptz NOT NULL DEFAULT now(),
    FOREIGN KEY (market_job_id)
        REFERENCES market_job(id),
    FOREIGN KEY (task_type_id)
        REFERENCES task_type(id)
);

CREATE INDEX IF NOT EXISTS idx_market_task_created_on ON market_task USING btree (created_on);
CREATE INDEX IF NOT EXISTS idx_market_task_task_run_end ON market_task USING btree (task_run_end);
CREATE INDEX IF NOT EXISTS idx_market_task_task_run_start ON market_task USING btree (task_run_start);
CREATE INDEX IF NOT EXISTS idx_market_task_task_run_status ON market_task USING btree (task_run_status);


CREATE TABLE IF NOT EXISTS permissions (
    id varchar(255) NOT NULL PRIMARY KEY,
    name varchar(255) NOT NULL,
    description varchar NULL,
    market_assignable bool NOT NULL,
    customer_assignable bool NOT NULL,
    asset_assignable bool NOT NULL,
    requires_internal_admin bool NOT NULL,
    created_on timestamptz NOT NULL DEFAULT now(),
    created_by int NULL,
    CONSTRAINT permissions_chk_at_least_one_assignable CHECK (((market_assignable = true) OR (customer_assignable = true) OR (asset_assignable = true))),
    FOREIGN KEY (created_by)
        REFERENCES users(id)
);


CREATE TABLE IF NOT EXISTS product (
    id smallint GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    iso_id smallint NOT NULL DEFAULT 11,
    market_id int NOT NULL,
    product_type_id smallint NOT NULL,
    name varchar NOT NULL,
    data jsonb NOT NULL DEFAULT '{}'::jsonb,
    description varchar,
    valid_start timestamptz NOT NULL DEFAULT '2009-12-31 21:00:00-03',
    valid_end timestamptz NOT NULL DEFAULT '9998-12-31 21:00:00-03',
    created_on timestamptz NOT NULL DEFAULT now(),
    FOREIGN KEY (iso_id)
        REFERENCES iso(id),
    FOREIGN KEY (market_id)
        REFERENCES market(id),
    FOREIGN KEY (product_type_id)
        REFERENCES product_type(id)
);

CREATE INDEX IF NOT EXISTS product_market_id_idx ON product USING btree (market_id);
CREATE INDEX IF NOT EXISTS product_name_idx ON product USING btree (name);

COMMENT ON TABLE product
    IS 'This table defined general products used in different ISOs/RTOs.';


CREATE TABLE IF NOT EXISTS region (
    id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name varchar NOT NULL,
    description varchar,
    data jsonb NOT NULL DEFAULT '{}'::jsonb,
    iso_id smallint NOT NULL DEFAULT 11,
    FOREIGN KEY (iso_id)
        REFERENCES iso(id)
);

CREATE UNIQUE INDEX IF NOT EXISTS region_name ON region USING btree (name);


CREATE TABLE IF NOT EXISTS region_award (
    id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    market_agent_id int NOT NULL,
    region_id int NOT NULL,
    market_task_id int,
    product_id int NOT NULL,
    process_type_id smallint NOT NULL,
    bid_id varchar NOT NULL,
    offer_type_id smallint NOT NULL,
    award_quantity double precision NOT NULL,
    interval_start timestamptz NOT NULL,
    interval_end timestamptz NOT NULL,
    prep_time timestamptz NOT NULL,
    created_on timestamptz NOT NULL DEFAULT now(),
    FOREIGN KEY (market_agent_id)
        REFERENCES market_agent(id),
    FOREIGN KEY (market_task_id)
        REFERENCES market_task(id),
    FOREIGN KEY (offer_type_id)
        REFERENCES offer_type(id),
    FOREIGN KEY (process_type_id)
        REFERENCES process_type(id),
    FOREIGN KEY (product_id)
        REFERENCES product(id),
    FOREIGN KEY (region_id)
        REFERENCES region(id)
);

COMMENT ON TABLE region_award
    IS 'This table stores Awardeds at Region level';


CREATE TABLE IF NOT EXISTS asset (
    id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name varchar NOT NULL,
    region_id int NOT NULL,
    resource_id varchar UNIQUE,
    data jsonb NOT NULL DEFAULT '{}'::jsonb,
    customer_id int NOT NULL,
    resource_id_load varchar UNIQUE,
    parent_asset_id int,
    root_asset_id int,
    asset_type_id int NOT NULL,
    created_on timestamptz NOT NULL DEFAULT now(),
    created_by int NOT NULL,
    asset_key uuid NOT NULL DEFAULT uuid_generate_v4(),
    valid_start timestamptz NOT NULL DEFAULT '2009-12-31 21:00:00-03',
    valid_end timestamptz NOT NULL DEFAULT '9998-12-31 21:00:00-03',
    asset_mode_id smallint NOT NULL,
    FOREIGN KEY (asset_mode_id)
        REFERENCES asset_mode(id),
    FOREIGN KEY (asset_type_id)
        REFERENCES asset_type(id),
    FOREIGN KEY (created_by)
        REFERENCES users(id),
    FOREIGN KEY (parent_asset_id)
        REFERENCES asset(id),
    FOREIGN KEY (region_id)
        REFERENCES region(id),
    FOREIGN KEY (root_asset_id)
        REFERENCES asset(id),
    FOREIGN KEY (customer_id)
        REFERENCES host_customer(id)
);

CREATE UNIQUE INDEX IF NOT EXISTS asset_name ON asset USING btree (name);
CREATE INDEX IF NOT EXISTS asset_region_id ON asset USING btree (region_id);
CREATE INDEX IF NOT EXISTS idx_asset_customer_id ON asset USING btree (customer_id);


CREATE TABLE IF NOT EXISTS asset_data (
    id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    asset_id int NOT NULL,
    tag varchar NOT NULL,
    data jsonb NOT NULL,
    start_time timestamptz NOT NULL,
    created_on timestamptz NOT NULL DEFAULT now(),
    created_by int NOT NULL,
    deleted bool NOT NULL,
    deleted_by int,
    asset_data_type_id smallint DEFAULT 1,
    FOREIGN KEY (asset_data_type_id)
        REFERENCES asset_data_type(id),
    FOREIGN KEY (asset_id)
        REFERENCES asset(id),
    FOREIGN KEY (created_by)
        REFERENCES users(id),
    FOREIGN KEY (deleted_by)
        REFERENCES users(id)
);

CREATE INDEX IF NOT EXISTS asset_data_asset_id_tag_idx ON asset_data USING btree (asset_id, tag);


CREATE TABLE IF NOT EXISTS asset_meter (
    id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    asset_meter_key uuid DEFAULT uuid_generate_v4(),
    asset_id int NOT NULL,
    asset_meter_type_id smallint,
    name varchar NOT NULL,
    meter_reading_frequency int,
    meter_upload_frequency int,
    effective_time timestamptz,
    expiration_time timestamptz,
    status smallint,
    valid_start timestamptz NOT NULL DEFAULT '2009-12-31 21:00:00-03',
    valid_end timestamptz NOT NULL DEFAULT '9998-12-31 21:00:00-03',
    created_by int,
    created_on timestamptz NOT NULL DEFAULT now(),
    FOREIGN KEY (asset_meter_type_id)
        REFERENCES asset_meter_type(id),
    FOREIGN KEY (asset_id)
        REFERENCES asset(id)
);

COMMENT ON TABLE asset_meter
    IS 'This table defines meter (telemetry stream) under each asset.';


CREATE TABLE IF NOT EXISTS asset_product_data (
    id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    asset_id int NOT NULL,
    product_id int NOT NULL,
    tag varchar NOT NULL,
    data jsonb NOT NULL,
    start_time timestamptz NOT NULL,
    created_on timestamptz NOT NULL DEFAULT now(),
    created_by int NOT NULL,
    deleted bool NOT NULL,
    deleted_by int,
    FOREIGN KEY (asset_id)
        REFERENCES asset(id),
    FOREIGN KEY (created_by)
        REFERENCES users(id),
    FOREIGN KEY (deleted_by)
        REFERENCES users(id),
    FOREIGN KEY (product_id)
        REFERENCES product(id)
);

CREATE INDEX IF NOT EXISTS apd_asset_id_product_id_tag_idx ON asset_product_data USING btree (asset_id, product_id, tag);
CREATE INDEX IF NOT EXISTS apd_asset_id_tag_idx ON asset_product_data USING btree (asset_id, tag);


CREATE TABLE IF NOT EXISTS asset_telemetry_data (
    id bigint GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    asset_meter_id int,
    telemetry_value_type_id smallint NOT NULL,
    process_type_id smallint NOT NULL,
    read_time timestamptz,
    value double precision,
    created_on timestamptz NOT NULL DEFAULT now(),
    FOREIGN KEY (asset_meter_id)
        REFERENCES asset_meter(id),
    FOREIGN KEY (telemetry_value_type_id)
        REFERENCES telemetry_value_type(id),
    FOREIGN KEY (process_type_id)
        REFERENCES process_type(id)
);

CREATE INDEX IF NOT EXISTS idx_read_time ON asset_telemetry_data USING btree (read_time);

COMMENT ON TABLE asset_telemetry_data
    IS '';


CREATE TABLE IF NOT EXISTS award (
    id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    market_task_id int NULL,
    asset_id int NOT NULL,
    product_id int NULL,
    resource_type_id smallint NOT NULL,
    process_type_id smallint NOT NULL,
    award_quantity double precision NOT NULL,
    interval_start timestamptz NOT NULL,
    interval_end timestamptz NOT NULL,
    prep_time timestamptz NOT NULL,
    created_on timestamptz NOT NULL DEFAULT now(),
    FOREIGN KEY (asset_id)
        REFERENCES asset(id),
    FOREIGN KEY (market_task_id)
        REFERENCES market_task(id),
    FOREIGN KEY (resource_type_id)
        REFERENCES resource_type(id),
    FOREIGN KEY (process_type_id)
        REFERENCES process_type(id)
);

CREATE INDEX IF NOT EXISTS idx_award_created_on ON award USING btree (created_on);
CREATE INDEX IF NOT EXISTS idx_award_interval_end ON award USING btree (interval_end);
CREATE INDEX IF NOT EXISTS idx_award_interval_start ON award USING btree (interval_start);
CREATE INDEX IF NOT EXISTS idx_award_resource_type ON award USING btree (resource_type_id);


CREATE TABLE IF NOT EXISTS bid (
    id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    market_task_id int,
    asset_id int NOT NULL,
    resource_type_id smallint NOT NULL,
    product_id smallint NOT NULL,
    process_type_id smallint NOT NULL,
    interval_start timestamptz NOT NULL,
    interval_end timestamptz NOT NULL,
    prep_time timestamptz NOT NULL,
    created_on timestamptz NOT NULL DEFAULT now(),
    FOREIGN KEY (asset_id)
        REFERENCES asset(id),
    FOREIGN KEY (market_task_id)
        REFERENCES market_task(id),
    FOREIGN KEY (resource_type_id)
        REFERENCES resource_type(id),
    FOREIGN KEY (process_type_id)
        REFERENCES process_type(id)
);

CREATE INDEX IF NOT EXISTS idx_bid_asset_id ON bid USING btree (asset_id);
CREATE INDEX IF NOT EXISTS idx_bid_created_on ON bid USING btree (created_on);
CREATE INDEX IF NOT EXISTS idx_bid_interval_end ON bid USING btree (interval_end);
CREATE INDEX IF NOT EXISTS idx_bid_interval_start ON bid USING btree (interval_start);


CREATE TABLE IF NOT EXISTS bid_segment (
    id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    bid_id int NOT NULL,
    interval_start timestamptz,
    interval_end timestamptz,
    segment smallint NOT NULL,
    price double precision,
    quantity double precision,
    prep_time timestamptz,
    created_on timestamptz NOT NULL DEFAULT now(),
    FOREIGN KEY (bid_id)
        REFERENCES bid(id)
);

CREATE INDEX IF NOT EXISTS idx_bid_segment_bid_id ON bid_segment USING btree (bid_id);


CREATE TABLE IF NOT EXISTS configuration (
    asset_id int NOT NULL,
    market_id smallint NOT NULL,
    hour_ending smallint NOT NULL,
    start_time timestamptz NOT NULL,
    created_on timestamptz NOT NULL DEFAULT now(),
    data jsonb NOT NULL,
    created_by int NOT NULL,
    deleted bool NOT NULL,
    deleted_by int NOT NULL,
    PRIMARY KEY (asset_id, start_time, hour_ending, market_id, created_on),
    FOREIGN KEY (asset_id)
        REFERENCES asset(id),
    FOREIGN KEY (market_id)
        REFERENCES market(id),
    FOREIGN KEY (created_by)
        REFERENCES users(id),
    FOREIGN KEY (deleted_by)
        REFERENCES users(id)
);


CREATE TABLE IF NOT EXISTS cop_limit (
    id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    market_task_id int NULL,
    asset_id int NOT NULL,
    resource_type_id smallint NOT NULL,
    limit_type_id smallint NOT NULL,
    process_type_id smallint NOT NULL,
    cop_limit_value double precision NOT NULL,
    interval_start timestamptz NOT NULL,
    interval_end timestamptz NOT NULL,
    prep_time timestamptz NOT NULL,
    created_on timestamptz NOT NULL DEFAULT now(),
    FOREIGN KEY (asset_id)
        REFERENCES asset(id),
    FOREIGN KEY (market_task_id)
        REFERENCES market_task(id),
    FOREIGN KEY (resource_type_id)
        REFERENCES resource_type(id),
    FOREIGN KEY (limit_type_id)
        REFERENCES cop_limit_type(id),
    FOREIGN KEY (process_type_id)
        REFERENCES process_type(id)
);

CREATE INDEX IF NOT EXISTS idx_cop_limit_created_on ON cop_limit USING btree (created_on);
CREATE INDEX IF NOT EXISTS idx_cop_limit_interval_end ON cop_limit USING btree (interval_end);
CREATE INDEX IF NOT EXISTS idx_cop_limit_interval_start ON cop_limit USING btree (interval_start);
CREATE INDEX IF NOT EXISTS idx_cop_limit_limit_type ON cop_limit USING btree (limit_type_id);
CREATE INDEX IF NOT EXISTS idx_cop_limit_resource_type ON cop_limit USING btree (resource_type_id);


CREATE TABLE IF NOT EXISTS cop_product (
    id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    market_task_id int,
    asset_id int NOT NULL,
    resource_type_id smallint NOT NULL,
    product_id smallint NOT NULL,
    process_type_id smallint NOT NULL,
    cop_product_value double precision NOT NULL,
    interval_start timestamptz NOT NULL,
    interval_end timestamptz NOT NULL,
    prep_time timestamptz NOT NULL,
    created_on timestamptz NOT NULL DEFAULT now(),
    FOREIGN KEY (asset_id)
        REFERENCES asset(id),
    FOREIGN KEY (market_task_id)
        REFERENCES market_task(id),
    FOREIGN KEY (resource_type_id)
        REFERENCES resource_type(id),
    FOREIGN KEY (process_type_id)
        REFERENCES process_type(id)
);

CREATE INDEX IF NOT EXISTS idx_cop_product_created_on ON cop_product USING btree (created_on);
CREATE INDEX IF NOT EXISTS idx_cop_product_interval_end ON cop_product USING btree (interval_end);
CREATE INDEX IF NOT EXISTS idx_cop_product_interval_start ON cop_product USING btree (interval_start);
CREATE INDEX IF NOT EXISTS idx_cop_product_resource_type ON cop_product USING btree (resource_type_id);


CREATE TABLE IF NOT EXISTS cop_status (
    id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    market_task_id int,
    asset_id int NOT NULL,
    resource_type_id smallint NOT NULL,
    cop_status_type_id smallint NOT NULL,
    process_type_id smallint NOT NULL,
    interval_start timestamptz NOT NULL,
    interval_end timestamptz NOT NULL,
    prep_time timestamptz NOT NULL,
    created_on timestamptz NOT NULL DEFAULT now(),
    FOREIGN KEY (asset_id)
        REFERENCES asset(id),
    FOREIGN KEY (cop_status_type_id)
        REFERENCES cop_status_type(id),
    FOREIGN KEY (market_task_id)
        REFERENCES market_task(id),
    FOREIGN KEY (resource_type_id)
        REFERENCES resource_type(id),
    FOREIGN KEY (process_type_id)
        REFERENCES process_type(id)
);

CREATE INDEX IF NOT EXISTS idx_cop_status_created_on ON cop_status USING btree (created_on);
CREATE INDEX IF NOT EXISTS idx_cop_status_interval_end ON cop_status USING btree (interval_end);
CREATE INDEX IF NOT EXISTS idx_cop_status_interval_start ON cop_status USING btree (interval_start);
CREATE INDEX IF NOT EXISTS idx_cop_status_resource_type ON cop_status USING btree (resource_type_id);


CREATE TABLE IF NOT EXISTS input_cop_limit (
    market_task_id int NOT NULL,
    cop_limit_id int NOT NULL,
    PRIMARY KEY (market_task_id, cop_limit_id),
    FOREIGN KEY (cop_limit_id)
        REFERENCES cop_limit(id),
    FOREIGN KEY (market_task_id)
        REFERENCES market_task(id)
);


CREATE TABLE IF NOT EXISTS input_cop_product (
    market_task_id int NOT NULL,
    cop_product_id int NOT NULL,
    PRIMARY KEY (market_task_id, cop_product_id),
    FOREIGN KEY (cop_product_id)
        REFERENCES cop_product(id),
    FOREIGN KEY (market_task_id)
        REFERENCES market_task(id)
);


CREATE TABLE IF NOT EXISTS input_cop_status (
    market_task_id int NOT NULL,
    cop_status_id int NOT NULL,
    PRIMARY KEY (market_task_id, cop_status_id),
    FOREIGN KEY (cop_status_id)
        REFERENCES cop_status(id),
    FOREIGN KEY (market_task_id)
        REFERENCES market_task(id)
);


CREATE TABLE IF NOT EXISTS interval_soc (
    id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    market_task_id int,
    asset_id int NOT NULL,
    interval_start timestamptz NOT NULL,
    interval_end timestamptz NOT NULL,
    soc_type_id smallint NOT NULL,
    process_type_id smallint NOT NULL,
    soc_value double precision NOT NULL,
    prep_time timestamptz NOT NULL,
    created_on timestamptz NOT NULL DEFAULT now(),
    FOREIGN KEY (asset_id)
        REFERENCES asset(id),
    FOREIGN KEY (market_task_id)
        REFERENCES market_task(id),
    FOREIGN KEY (soc_type_id)
        REFERENCES soc_type(id),
    FOREIGN KEY (process_type_id)
        REFERENCES process_type(id)
);


CREATE TABLE IF NOT EXISTS market_permission_grants (
    id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id int NOT NULL,
    permission_id varchar(255) NOT NULL,
    created_on timestamptz NOT NULL DEFAULT now(),
    created_by int,
    CONSTRAINT market_permission_grants_foreign_keys_unique UNIQUE (user_id, permission_id),
    FOREIGN KEY (created_by)
        REFERENCES users(id),
    FOREIGN KEY (permission_id)
        REFERENCES permissions(id) ON DELETE RESTRICT,
    FOREIGN KEY (user_id)
        REFERENCES users(id)
);

CREATE INDEX IF NOT EXISTS idx_market_permission_grants_permission_id ON market_permission_grants USING btree (permission_id);
CREATE INDEX IF NOT EXISTS idx_market_permission_grants_user_id ON market_permission_grants USING btree (user_id);
CREATE INDEX IF NOT EXISTS idx_market_permission_grants_user_id_permission_id ON market_permission_grants USING btree (user_id, permission_id);


CREATE TABLE IF NOT EXISTS market_product_xref (
    id smallint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name varchar NOT NULL,
    iso_id smallint NOT NULL,
    market_id smallint NOT NULL,
    product_id smallint NOT NULL,
    description varchar,
    valid_start timestamptz NOT NULL DEFAULT '2009-12-31 21:00:00-03',
    valid_end timestamptz NOT NULL DEFAULT '9998-12-31 21:00:00-03',
    created_on timestamptz NOT NULL DEFAULT now(),
    last_modified_on timestamptz NOT NULL DEFAULT now(),
    FOREIGN KEY (iso_id)
        REFERENCES iso(id),
    FOREIGN KEY (market_id)
        REFERENCES market(id),
    FOREIGN KEY (product_id)
        REFERENCES product(id)
);

COMMENT ON TABLE market_product_xref
    IS 'This table defines the market/product combination that ISO provides.';


CREATE TABLE IF NOT EXISTS obligation (
    id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    market_task_id int NOT NULL,
    cop_product_id int,
    award_id int,
    region_award_id int,
    CONSTRAINT obligation_check CHECK (((cop_product_id IS NOT NULL) <> ((award_id IS NOT NULL) OR (region_award_id IS NOT NULL)))),
    CONSTRAINT obligation_market_task_id_award_id_key UNIQUE (market_task_id, award_id),
    CONSTRAINT obligation_market_task_id_cop_product_id_key UNIQUE (market_task_id, cop_product_id),
    CONSTRAINT obligation_market_task_id_region_award_id_key UNIQUE (market_task_id, region_award_id),
    FOREIGN KEY (award_id)
        REFERENCES award(id),
    FOREIGN KEY (cop_product_id)
        REFERENCES cop_product(id),
    FOREIGN KEY (market_task_id)
        REFERENCES market_task(id),
    FOREIGN KEY (region_award_id)
        REFERENCES region_award(id)
);


CREATE TABLE IF NOT EXISTS settlement (
    id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    market_task_id int,
    asset_id int NOT NULL,
    product_id int,
    resource_type_id smallint NOT NULL,
    process_type_id smallint NOT NULL,
    settlement_amount double precision NOT NULL,
    interval_start timestamptz NOT NULL,
    interval_end timestamptz NOT NULL,
    prep_time timestamptz NOT NULL,
    created_on timestamptz NOT NULL DEFAULT now(),
    FOREIGN KEY (asset_id)
        REFERENCES asset(id),
    FOREIGN KEY (market_task_id)
        REFERENCES market_task(id),
    FOREIGN KEY (resource_type_id)
        REFERENCES resource_type(id),
    FOREIGN KEY (process_type_id)
        REFERENCES process_type(id)
);

CREATE INDEX IF NOT EXISTS idx_settlement_created_on ON settlement USING btree (created_on);
CREATE INDEX IF NOT EXISTS idx_settlement_interval_end ON settlement USING btree (interval_end);
CREATE INDEX IF NOT EXISTS idx_settlement_interval_start ON settlement USING btree (interval_start);
CREATE INDEX IF NOT EXISTS idx_settlement_resource_type ON settlement USING btree (resource_type_id);


CREATE TABLE IF NOT EXISTS asset_market_product_xref (
    id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    asset_id int NOT NULL,
    market_product_id int NOT NULL,
    valid_start timestamptz NOT NULL DEFAULT '2009-12-31 21:00:00-03',
    valid_end timestamptz NOT NULL DEFAULT '9998-12-31 21:00:00-03',
    created_by int NOT NULL,
    created_on timestamptz NOT NULL DEFAULT now(),
    modified_by int NOT NULL,
    modified_on timestamptz NOT NULL DEFAULT now(),
    FOREIGN KEY (asset_id)
        REFERENCES asset(id),
    FOREIGN KEY (created_by)
        REFERENCES users(id),
    FOREIGN KEY (market_product_id)
        REFERENCES market_product_xref(id),
    FOREIGN KEY (modified_by)
        REFERENCES users(id)
);

COMMENT ON TABLE asset_market_product_xref
    IS 'This table records which products the asset enrolled into.';


CREATE TABLE IF NOT EXISTS resource (
    id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name varchar NOT NULL UNIQUE,
    resource_type_id smallint NOT NULL,
    market_agent_id smallint NOT NULL,
    asset_id int NOT NULL,
    created_by smallint NOT NULL,
    created_on timestamptz NOT NULL DEFAULT now(),
    last_modified_by smallint NOT NULL,
    last_modified_on timestamptz NOT NULL DEFAULT now(),
    FOREIGN KEY (resource_type_id)
        REFERENCES resource_type(id),
    FOREIGN KEY (market_agent_id)
        REFERENCES market_agent(id),
    FOREIGN KEY (asset_id)
        REFERENCES asset(id)
);

COMMENT ON TABLE resource
    IS 'This table stores all the resources registered in the ISO/RTO that we are providing service with.';


COMMIT;