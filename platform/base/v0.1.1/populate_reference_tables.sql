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
    (5, 'SIMULATED', 'Simulated or model-generated values')
    ON CONFLICT DO NOTHING;


INSERT INTO product_type
    (id, name, description)
VALUES
    (1, 'Energy', 'Energy'),
    (2, 'Anciliary Service', 'Anciliary Service')
    ON CONFLICT DO NOTHING;


INSERT INTO registration_type
    (id, name, description)
VALUES
    (1, 'asset_group', 'asset_group'),
    (2, 'asset', 'asset'),
    (3, 'resource', 'resource')
    ON CONFLICT DO NOTHING;


INSERT INTO resource_type
    (id, name, description)
VALUES
    (1, 'GEN', 'generation'),
    (2, 'LOAD', 'load')
    ON CONFLICT DO NOTHING;


INSERT INTO asset_data_type
    (id, name, description, schema, asset_type_id)
VALUES
    (1, 'strategy', 'strategy', '{"schema":"schema"}', 1)
    ON CONFLICT DO NOTHING;


INSERT INTO asset_meter_type 
    (id, name, description)
VALUES
    (1, 'SCADA', 'Supervisory Control and Data Acquisition system integration.'),
    (2, 'BEES', 'Biodiversity and Ecosystem Evaluation System.'),
    (3, 'third_party', 'Integration with third-party system meters.')
    ON CONFLICT DO NOTHING;


INSERT INTO cop_limit_type
    (id, name, description)
VALUES
    (1, 'HSL', 'HSL'),
    (2, 'LSL', 'LSL'),
    (3, 'HEL', 'HEL'),
    (4, 'LEL', 'LEL')
    ON CONFLICT DO NOTHING;


INSERT INTO cop_status_type
    (id, name, description)
VALUES
    (1, 'ONTEST', 'ONTEST')
    ON CONFLICT DO NOTHING;
 

INSERT INTO market_job_type 
    (id, name, description)
VALUES
    (1, 'ISO_PRIVATE_DATA_ETL', 'ISO_PRIVATE_DATA_ETL')
    ON CONFLICT DO NOTHING;


INSERT INTO market_type 
    (id, name, description)
VALUES
    (1, 'DAM', 'Dayahead Market Type'),
    (2, 'FMM', 'Fifteen-Minute Market Market Type'),
    (3, 'RTM', 'Realtime Market Type')
    ON CONFLICT DO NOTHING;


INSERT INTO offer_type
    (id, name, description)
VALUES
    (1, 'BID', 'Buy proposal at specified price.'),
    (2, 'OFFER', 'Sell proposal at specified price.'),
    (3, 'SCHEDULE', 'Planned energy generation/consumption.')
    ON CONFLICT DO NOTHING;


INSERT INTO soc_type
    (id, name, description)
VALUES
    (1, 'initial_soc', 'initial_soc'),
    (2, 'final_soc', 'final_soc')
    ON CONFLICT DO NOTHING;


INSERT INTO task_type
    (id, name, description)
VALUES
    (1, 'ISO_COP_ETL', 'ETL of the Current Operating Plan'),
    (2, 'ISO_AWARD_ETL', 'ETL of the Awards')
    ON CONFLICT DO NOTHING;


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
    (9, 'state of charge', 'The current energy level of the system as a percentage of its total capacity.')
    ON CONFLICT DO NOTHING;


INSERT INTO asset_type
    (id, name, description)
VALUES
    (1, 'bess', 'battery energy storage system')
    ON CONFLICT DO NOTHING;


INSERT INTO asset_mode
    (id, name, description)
VALUES
    (1, 'simulated', 'simulated'),
    (2, 'live', 'live')
    ON CONFLICT DO NOTHING;


INSERT INTO telemetry_value_type
    (id, name, created_on)
VALUES
    (1, 'state of charge', '2022-12-05 06:48:03.14035+00'),
    (2, 'power in/out (mw)', '2022-12-05 06:48:03.14035+00'),
    (3, 'state of health', '2022-12-05 06:48:03.14035+00'),
    (4,	'available charge (mw)', '2022-12-05 06:48:03.14035+00'),
    (5,	'available charge (mwh)', '2022-12-05 06:48:03.14035+00'),
    (6,	'available discharge (mw)', '2022-12-05 06:48:03.14035+00'),
    (7, 'available discharge (mwh)', '2022-12-05 06:48:03.14035+00'),
    (8,	'commanded power (mw)', '2022-12-05 06:48:03.14035+00'),
    (9,	'system heartbeat', '2022-12-05 06:48:03.14035+00')
    ON CONFLICT DO NOTHING;


COMMIT;
