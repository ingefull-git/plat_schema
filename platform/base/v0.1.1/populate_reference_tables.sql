-- kind: plan
-- schema: platform
-- version: v0.1.1

BEGIN;

SET search_path TO platform;


INSERT INTO process_type
    (id, name, description)
VALUES
    (1, 'ACTUAL', 'Actual observed values'),
    (2, 'FORECAST', 'Forecasted future values'),
    (3, 'ACTUAL_BASELINE', 'Baseline for actual values'),
    (4, 'FORECAST_BASELINE', 'Baseline for forecast values'),
    (5, 'SIMULATED', 'Simulated or model-generated values');


INSERT INTO product_type
    (id, name, description)
VALUES
    (1, 'Energy', 'Energy'),
    (2, 'Anciliary Service', 'Anciliary Service');


INSERT INTO registration_type
    (id, name, description)
VALUES
    (1, 'asset_group', 'asset_group'),
    (1, 'asset', 'asset'),
    (1, 'resource', 'resource');


INSERT INTO resource_type
    (id, name, description)
VALUES
    (1, 'GEN', 'generation'),
    (1, 'LOAD', 'load');


INSERT INTO asset_data_type
    (id, name, description, schema, asset_type_id)
VALUES
    (1, 'strategy', 'strategy', '{"schema":"schema"}', 1);


INSERT INTO asset_meter_type 
    (id, name, description)
VALUES
    (1, 'SCADA', 'Supervisory Control and Data Acquisition system integration.'),
    (2, 'BEES', 'Biodiversity and Ecosystem Evaluation System.'),
    (3, 'third_party', 'Integration with third-party system meters.');


INSERT INTO cop_limit_type
    (id, name, description)
VALUES
    (1, 'HSL', 'HSL'),
    (1, 'LSL', 'LSL'),
    (1, 'HEL', 'HEL'),
    (1, 'LEL', 'LEL');


INSERT INTO cop_status_type
    (id, name, description)
VALUES
    (1, 'ONTEST', 'ONTEST');
 

INSERT INTO market_job_type 
    (id, name, description)
VALUES
    (1, 'ISO_PRIVATE_DATA_ETL', 'ISO_PRIVATE_DATA_ETL');


INSERT INTO market_type 
    (id, name, description)
VALUES
    (1, 'DAM', 'Dayahead Market Type'),
    (2, 'FMM', 'Fifteen-Minute Market Market Type'),
    (3, 'RTM', 'Realtime Market Type');


INSERT INTO offer_type
    (id, name, description)
VALUES
    (1, 'BID', 'Buy proposal at specified price.'),
    (2, 'OFFER', 'Sell proposal at specified price.'),
    (3, 'SCHEDULE', 'Planned energy generation/consumption.');


INSERT INTO soc_type
    (id, name, description)
VALUES
    (1, 'initial_soc', 'initial_soc'),
    (2, 'final_soc', 'final_soc');


INSERT INTO task_type
    (id, name, description)
VALUES
    (1, 'ISO_COP_ETL', 'ETL of the Current Operating Plan'),
    (2, 'ISO_AWARD_ETL', 'ETL of the Awards');


INSERT INTO telemetry_value_type
    (id, name, description)
VALUES
    (1, 'power in/out (mw)', 'Measures the power flowing in or out of the system in megawatts.'),
    (2, 'state of health', 'Indicates the overall health status of the system.'),
    (3, 'available charge (mw)', 'The current charging capacity available in megawatts.'),
    (4, 'available charge (mwh)', 'The current charging capacity available in megawatt-hours.'),
    (5, 'available discharge (mw)', 'The current discharging capacity available in megawatts.'),
    (6, 'available discharge (mwh)', 'The current discharging capacity available in megawatt-hours.'),
    (7, 'commanded power (mw)', 'The power output or input commanded to the system in megawatts.'),
    (8, 'system heartbeat', 'A regular signal sent to indicate system status and connectivity.'),
    (9, 'state of charge', 'The current energy level of the system as a percentage of its total capacity.');


INSERT INTO asset_type
    (id, name, description)
VALUES
    (1, 'bess', 'battery energy storage system');


INSERT INTO asset_mode
    (id, name, description)
VALUES
    (1, 'simulated', 'simulated'),
    (2, 'live', 'live');



COMMIT;
