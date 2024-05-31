-- kind: plan
-- schema: platform
-- version: v0.1.1


BEGIN;

SET search_path TO platform;


INSERT INTO users
    (id, name, email, title, preferences) 
VALUES
    (1,'SystemUser', 'admin@example.com', 'Administrator', '{}'::jsonb)
    ON CONFLICT DO NOTHING;


INSERT INTO iso
    (id, name, display_name, time_zone, created_by, last_modified_by) 
VALUES
    (11,'CAISO', 'California ISO', 'America/Los_Angeles', 1, 1)
    ON CONFLICT DO NOTHING;


INSERT INTO region
    (id, name, iso_id, data)
VALUES
    (89,'BIGSKGN1134_7_N026',11,'{"as_nodes": ["AS_CAISO", "AS_CAISO_EXP", "AS_SP26", "AS_SP26_EXP"], "lmp_nodes": ["BIGSKGN1134_7_N026"], "mileage_nodes": ["AS_CAISO_EXP"], "as_price_forecast_node": "SP26", "lmp_price_forecast_node": "BIGSKGN1134_7_N026", "mileage_price_forecast_node": "SP26"}'),
    (96,'CENTPD_2_BMSX2-APND',11,'{"as_nodes": ["AS_CAISO", "AS_CAISO_EXP", "AS_SP26", "AS_SP26_EXP"], "lmp_nodes": ["CENTPD_2_BMSX2-APND"], "mileage_nodes": ["AS_CAISO_EXP"], "as_price_forecast_node": "SP26", "lmp_price_forecast_node": "CENTPD_2_BMSX2-APND", "mileage_price_forecast_node": "SP26"}')
    ON CONFLICT DO NOTHING;


INSERT INTO host_customer
    (id, name)
VALUES
    (3848,'AES'),
    (3856,'Intersect')
    ON CONFLICT DO NOTHING;


INSERT INTO asset
    (id, name, region_id, data, customer_id, asset_type_id, created_by, asset_mode_id)
VALUES
    (59,'LAB',89,'{"has_itc": true, "has_poi": false, "is_live": true, "latitude": 34.6885197, "longitude": -118.3092997, "asset_type": "battery_ifom", "tag_prefix": "battery", "customer_id": 3848, "data_sources": {"OMS": {"environment": "production"}, "CMRI": {"lookback": 3, "description": "", "environment": "production"}, "telemetry_source": {}}, "can_charge_from": [98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113], "number_batteries": 1, "number_inverters": 1, "spin_capacity_kw": 254000, "parasitic_load_kw": 0, "battery_capacity_kwh": 508000, "degradation_cost_kwh": 0, "inverter_charge_rate": 127000, "commercial_online_date": "2022-09-26", "inverter_discharge_rate": 127000, "lower_regulating_limit_kw": 127000, "regulation_up_capacity_kw": 254000, "upper_regulating_limit_kw": 127000, "regulation_down_capacity_kw": 254000}',3848, 1, 1, 1),
    (71,'Athos III',96,'{"has_itc": true, "has_poi": true, "is_live": true, "latitude": 33.7083615, "longitude": -116.0500255, "asset_type": "battery_ifom", "tag_prefix": "battery", "customer_id": 3856, "data_sources": {"OMS": {"environment": "production"}, "CMRI": {"lookback": 0, "description": "", "environment": "production"}, "telemetry_source": {}}, "can_charge_from": [120], "poi_capacity_kw": 224000, "number_batteries": 1, "number_inverters": 1, "spin_capacity_kw": 224000, "parasitic_load_kw": 0, "battery_capacity_kwh": 448000, "degradation_cost_kwh": 0, "inverter_charge_rate": 112000, "commercial_online_date": "2023-02-17", "inverter_discharge_rate": 112000, "lower_regulating_limit_kw": 112000, "regulation_up_capacity_kw": 224000, "upper_regulating_limit_kw": 112000, "regulation_down_capacity_kw": 224000}',3856, 1, 1, 1)
    ON CONFLICT DO NOTHING;


INSERT INTO market
    (id, name, data, description, market_type_id)
VALUES
    (1, 'DAM', '{}', 'Dayahead Market Type', 1),
    (2, 'FMM', '{}', 'Fifteen-Minute Market Market Type', 2),
    (3, 'RTM', '{}', 'Realtime Market Type', 3)
    ON CONFLICT DO NOTHING;


INSERT INTO market_agent
    (id, name, iso_id, description, market_agent_code, level, created_by, last_modified_by)
VALUES
    (898, 'test_qse', 11, 'Test QSE', 'FAKEQSE', 1, 1, 1)
    ON CONFLICT DO NOTHING;


INSERT INTO resource
    (id, name, resource_type_id, market_agent_id, asset_id, created_by, last_modified_by)
VALUES
    (1, 'TEST_BESS_GEN', 1, 898, 59, 1, 1),
    (2, 'TEST_BESS_LOAD', 2, 898, 71, 1, 1)
    ON CONFLICT DO NOTHING;


INSERT INTO product
    (id, name, market_id, product_type_id)
VALUES
    (1, 'ENERGY', 1, 1),
    (2, 'AS', 2, 2),
    (3, 'NR', 2, 2),
    (4, 'RD', 2, 2),
    (5, 'RMD', 2, 2),
    (6, 'RMU', 2, 2),
    (7, 'RU', 2, 2),
    (8, 'SR', 2, 2)
    ON CONFLICT DO NOTHING;


INSERT INTO asset_data
    (id, asset_id, tag, data, start_time, created_by, deleted)
VALUES
    (3396,59,'strategy','{"market": "RTM", "deviation_charge": 50, "daily_cycle_limit": 1.25, "deviation_discharge": 50, "risk_rtm_energy_charge": 20, "risk_rtm_energy_discharge": 20, "limit_charging_bid_capacity": false, "throughput_opportunity_cost": 0, "renewable_forecast_adjustment_itc": 100}','2024-01-25 18:00:00.000000 +00:00',1,false),
    (3324,71,'strategy','{"market": "DAM", "risk_spin": 0, "bidding_strategy": "OPTIMAL_REVENUE", "daily_cycle_limit": 1, "risk_regulation_up": 100, "risk_regulation_down": 100, "optimization_algorithm": "STOCHASTIC", "risk_dam_energy_charge": 40, "risk_dam_energy_discharge": 20, "limit_charging_bid_capacity": false, "throughput_opportunity_cost": 0, "limit_discharging_bid_capacity": false, "renewable_forecast_adjustment_itc": 70, "renewable_forecast_adjustment_poi": 110}','2023-10-24 07:00:00.000000 +00:00',1,false)
    ON CONFLICT DO NOTHING;


INSERT INTO market_product_xref
    (name, iso_id, market_id, product_id)
    -- DAM
    SELECT 
        p.name,
        p.iso_id,
        mk.id, 
        p.id
    FROM 
        product p
    JOIN 
        market mk ON mk.name = 'DAM'

    UNION

     -- FMM
    SELECT 
        p.name,
        p.iso_id,
        mk.id, 
        p.id
    FROM 
        product p
    JOIN 
        market mk ON mk.name = 'FMM'

    UNION

    -- RTM
    SELECT 
        p.name,
        p.iso_id,
        mk.id, 
        p.id
    FROM 
        product p
    JOIN 
        market mk ON mk.name = 'RTM'
    WHERE
        p.name = 'ENERGY'
    ON CONFLICT DO NOTHING;


INSERT INTO configuration
    (asset_id, market_id, hour_ending, start_time, data, created_by, deleted, deleted_by)
VALUES
    (59,1,0,'2024-03-20 07:00:00.000000 +00:00','{"ramp_rate": 0, "min_soe_eod": 0, "charging_efficiency": 0.878, "max_daily_average_soc": 1, "round_trip_efficiency": 0.878, "discharging_efficiency": 1}',1,false,1),
    (59,1,1,'2024-03-20 07:00:00.000000 +00:00','{"ramp_rate": 0, "min_soe_eod": 0, "charging_efficiency": 0.878, "max_daily_average_soc": 1, "round_trip_efficiency": 0.878, "discharging_efficiency": 1}',1,false,1),
    (59,1,2,'2024-03-20 07:00:00.000000 +00:00','{"ramp_rate": 0, "min_soe_eod": 0, "charging_efficiency": 0.878, "max_daily_average_soc": 1, "round_trip_efficiency": 0.878, "discharging_efficiency": 1}',1,false,1),
    (59,1,3,'2024-03-20 07:00:00.000000 +00:00','{"ramp_rate": 0, "min_soe_eod": 0, "charging_efficiency": 0.878, "max_daily_average_soc": 1, "round_trip_efficiency": 0.878, "discharging_efficiency": 1}',1,false,1),
    (71,1,0,'2022-09-16 07:00:00.000000 +00:00','{"lower_soe_kwh": 0, "upper_soe_kwh": 448000, "max_charge_power": 112000, "max_discharge_power": 112000, "regulation_up_throughput": 0.021, "regulation_down_throughput": 0.177}',1,false,1),
    (71,1,1,'2022-09-16 07:00:00.000000 +00:00','{"lower_soe_kwh": 0, "upper_soe_kwh": 448000, "max_charge_power": 112000, "max_discharge_power": 112000, "regulation_up_throughput": 0.021, "regulation_down_throughput": 0.177}',1,false,1),
    (71,1,2,'2022-09-16 07:00:00.000000 +00:00','{"lower_soe_kwh": 0, "upper_soe_kwh": 448000, "max_charge_power": 112000, "max_discharge_power": 112000, "regulation_up_throughput": 0.021, "regulation_down_throughput": 0.177}',1,false,1),
    (71,1,3,'2022-09-16 07:00:00.000000 +00:00','{"lower_soe_kwh": 0, "upper_soe_kwh": 448000, "max_charge_power": 112000, "max_discharge_power": 112000, "regulation_up_throughput": 0.021, "regulation_down_throughput": 0.177}',1,false,1)
    ON CONFLICT DO NOTHING;


INSERT INTO asset_meter
    (id, name, asset_id, asset_meter_type_id, meter_reading_frequency, meter_upload_frequency, effective_time, expiration_time, status, created_by, created_on)
VALUES
    (1, 'meter_1', 59, 1, 4, 60, '2023-01-01 00:00:00+00', '9999-01-01 00:00:00+00', 1, 1, '2023-01-14 00:08:45.752719+00'),
    (2, 'meter_2', 71, 1, 4, 60, '2023-01-01 00:00:00+00', '9999-01-01 00:00:00+00', 1, 1, '2023-01-16 00:08:45.752719+00'),
    (3, 'meter_3', 59, 1, 4, 60, '2023-01-01 00:00:00+00', '9999-01-01 00:00:00+00', 1, 1, '2023-01-16 00:08:45.752719+00'),
    (4, 'meter_4', 71, 1, 4, 60, '2023-01-01 00:00:00+00', '9999-01-01 00:00:00+00', 1, 1, '2023-01-16 00:08:45.752719+00')
    ON CONFLICT DO NOTHING;


INSERT INTO asset_telemetry_data
    (id, asset_meter_id, telemetry_value_type_id, process_type_id, read_time, value, created_on)
VALUES
    (1, 1, 1, 1, '2023-01-26 03:51:15.63+00', 50.3, '2023-01-26 03:51:31.885+00'),
    (2, 1, 2, 1, '2023-01-26 03:51:15.63+00', 60.5, '2023-01-26 03:51:31.891+00'),
    (3, 1, 1, 1, '2023-01-26 03:51:15.63+00', 51.3, '2023-01-26 03:52:12.847+00'),
    (4, 1, 2, 1, '2023-01-26 03:51:15.63+00', 67.5, '2023-01-26 03:52:12.85+00'),
    (5, 1, 1, 1, '2023-01-26 03:52:15.63+00', 51.3, '2023-01-26 03:53:25.413+00'),
    (6, 1, 2, 1, '2023-01-26 03:52:15.63+00', 67.5, '2023-01-26 03:53:25.416+00'),
    (7, 1, 1, 1, '2023-01-30 00:00:00+00', 10, '2023-01-26 21:58:05.944+00'),
    (8, 1, 2, 1, '2023-01-30 00:00:00+00', 50, '2023-01-26 21:58:05.948+00'),
    (9, 1, 1, 1, '2023-01-30 00:00:00+00', 10, '2023-01-26 22:08:09.897+00'),
    (10, 1, 2, 1, '2023-01-30 00:00:00+00', 50, '2023-01-26 22:08:09.899+00'),
    (11, 1, 1, 1, '2023-01-30 00:00:00+00', 10, '2023-01-27 01:13:50.475+00'),
    (12, 1, 2, 1, '2023-01-30 00:00:00+00', 50, '2023-01-27 01:13:50.481+00'),
    (13, 1, 1, 1, '2023-01-30 00:00:00+00', 10, '2023-01-27 01:18:11.221+00'),
    (14, 1, 2, 1, '2023-01-30 00:00:00+00', 50, '2023-01-27 01:18:11.223+00'),
    (15, 1, 1, 1, '2023-01-25 06:00:00+00', 50.43, '2023-01-27 01:30:33.45+00'),
    (16, 1, 2, 1, '2023-01-25 06:00:00+00', 43, '2023-01-27 01:30:33.452+00'),
    (17, 1, 1, 1, '2023-01-25 06:00:00+00', 50.43, '2023-01-27 01:33:18.858+00'),
    (18, 1, 2, 1, '2023-01-25 06:00:00+00', 43, '2023-01-27 01:33:18.86+00'),
    (19, 1, 1, 1, '2023-01-25 06:00:00+00', 50.43, '2023-01-27 01:36:44.383+00'),
    (20, 1, 2, 1, '2023-01-25 06:00:00+00', 43, '2023-01-27 01:36:44.385+00'),
    (21, 1, 1, 1, '2023-01-27 01:42:33.008+00', 50.43, '2023-01-27 01:43:25.249+00'),
    (22, 1, 2, 1, '2023-01-27 01:42:33.008+00', 43, '2023-01-27 01:43:25.251+00'),
    (23, 1, 1, 1, '2023-01-27 02:15:30.165+00', 50.43, '2023-01-27 02:16:22.431+00'),
    (24, 1, 2, 1, '2023-01-27 02:15:30.165+00', 43, '2023-01-27 02:16:22.432+00'),
    (25, 1, 1, 1, '2023-01-27 03:32:12.633+00', 50.43, '2023-01-27 03:33:04.909+00'),
    (26, 1, 2, 1, '2023-01-27 03:32:12.633+00', 43, '2023-01-27 03:33:04.911+00'),
    (27, 1, 1, 1, '2023-01-27 05:14:46.888+00', 50.43, '2023-01-27 05:15:59.172+00'),
    (28, 1, 2, 1, '2023-01-27 05:14:46.888+00', 43, '2023-01-27 05:15:59.174+00'),
    (29, 1, 1, 1, '2023-01-27 05:19:14.075+00', 50.43, '2023-01-27 05:20:14.78+00'),
    (30, 1, 2, 1, '2023-01-27 05:19:14.075+00', 43, '2023-01-27 05:20:14.782+00'),
    (31, 1, 1, 1, '2023-01-27 05:29:25.536+00', 50.43, '2023-01-27 05:30:26.089+00'),
    (32, 1, 2, 1, '2023-01-27 05:29:25.536+00', 43, '2023-01-27 05:30:26.091+00'),
    (33, 1, 1, 1, '2023-01-25 07:00:00+00', 50.7, '2023-01-27 06:03:32.901+00'),
    (34, 1, 2, 1, '2023-01-25 07:00:00+00', -0.778, '2023-01-27 06:03:32.903+00'),
    (35, 1, 1, 1, '2023-01-25 07:00:00+00', 50.7, '2023-01-27 06:08:29.146+00'),
    (36, 1, 2, 1, '2023-01-25 07:00:00+00', -0.778, '2023-01-27 06:08:29.148+00'),
    (37, 1, 1, 1, '2023-01-25 07:00:00+00', 50.7, '2023-01-27 09:35:13.941+00'),
    (38, 1, 2, 1, '2023-01-25 07:00:00+00', -0.778, '2023-01-27 09:35:13.943+00'),
    (39, 1, 1, 1, '2023-01-25 06:00:00+00', 80, '2023-01-27 09:49:35.665+00'),
    (40, 1, 2, 1, '2023-01-25 06:00:00+00', 50, '2023-01-27 09:49:35.666+00'),
    (41, 1, 1, 1, '2023-01-25 06:00:00+00', 80, '2023-01-27 09:51:08.211+00'),
    (42, 1, 2, 1, '2023-01-25 06:00:00+00', 50, '2023-01-27 09:51:08.212+00'),
    (43, 1, 1, 1, '2023-01-25 08:00:00+00', 53.4, '2023-01-27 13:10:56.152+00'),
    (44, 1, 2, 1, '2023-01-25 08:00:00+00', -3, '2023-01-27 13:10:56.154+00'),
    (45, 1, 1, 1, '2023-01-25 08:00:00+00', 53.4, '2023-01-27 13:12:45.661+00'),
    (46, 1, 2, 1, '2023-01-25 08:00:00+00', -3, '2023-01-27 13:12:45.662+00'),
    (47, 1, 1, 1, '2023-01-25 08:00:00+00', 53.4, '2023-01-27 13:20:01.729+00'),
    (48, 1, 2, 1, '2023-01-25 08:00:00+00', -3, '2023-01-27 13:20:01.73+00'),
    (49, 1, 1, 1, '2023-01-26 07:00:00+00', 50, '2023-01-28 00:28:37.723+00'),
    (50, 1, 2, 1, '2023-01-26 07:00:00+00', 0, '2023-01-28 00:28:37.726+00')
    ON CONFLICT DO NOTHING;

COMMIT;
