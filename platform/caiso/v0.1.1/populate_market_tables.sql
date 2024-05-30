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
    (71,'Athos III',96,'{"has_itc": true, "has_poi": true, "is_live": true, "latitude": 33.7083615, "longitude": -116.0500255, "asset_type": "battery_ifom", "tag_prefix": "battery", "customer_id": 3856, "data_sources": {"OMS": {"environment": "production"}, "CMRI": {"lookback": 0, "description": "", "environment": "production"}, "telemetry_source": {}}, "can_charge_from": [120], "poi_capacity_kw": 224000, "number_batteries": 1, "number_inverters": 1, "spin_capacity_kw": 224000, "parasitic_load_kw": 0, "battery_capacity_kwh": 448000, "degradation_cost_kwh": 0, "inverter_charge_rate": 112000, "commercial_online_date": "2023-02-17", "inverter_discharge_rate": 112000, "lower_regulating_limit_kw": 112000, "regulation_up_capacity_kw": 224000, "upper_regulating_limit_kw": 112000, "regulation_down_capacity_kw": 224000}',3856, 1, 1, 1),
    (59,'LAB',89,'{"has_itc": true, "has_poi": false, "is_live": true, "latitude": 34.6885197, "longitude": -118.3092997, "asset_type": "battery_ifom", "tag_prefix": "battery", "customer_id": 3848, "data_sources": {"OMS": {"environment": "production"}, "CMRI": {"lookback": 3, "description": "", "environment": "production"}, "telemetry_source": {}}, "can_charge_from": [98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113], "number_batteries": 1, "number_inverters": 1, "spin_capacity_kw": 254000, "parasitic_load_kw": 0, "battery_capacity_kwh": 508000, "degradation_cost_kwh": 0, "inverter_charge_rate": 127000, "commercial_online_date": "2022-09-26", "inverter_discharge_rate": 127000, "lower_regulating_limit_kw": 127000, "regulation_up_capacity_kw": 254000, "upper_regulating_limit_kw": 127000, "regulation_down_capacity_kw": 254000}',3848, 1, 1, 1)
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
        p.name = 'energy'
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


COMMIT;
