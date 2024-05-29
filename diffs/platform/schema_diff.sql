--- backup/platform/snapshot.sql	2024-05-29 15:37:03.021118128 +0000
+++ snapshots/platform/snapshot.sql	2024-05-29 15:36:57.000000000 +0000
@@ -0,0 +1,29 @@
+--
+-- PostgreSQL database dump
+--
+
+-- Dumped from database version 16.2 (Debian 16.2-1.pgdg120+2)
+-- Dumped by pg_dump version 16.3 (Debian 16.3-1.pgdg110+1)
+
+SET statement_timeout = 0;
+SET lock_timeout = 0;
+SET idle_in_transaction_session_timeout = 0;
+SET client_encoding = 'UTF8';
+SET standard_conforming_strings = on;
+SELECT pg_catalog.set_config('search_path', '', false);
+SET check_function_bodies = false;
+SET xmloption = content;
+SET client_min_messages = warning;
+SET row_security = off;
+
+--
+-- Name: platform; Type: SCHEMA; Schema: -; Owner: -
+--
+
+CREATE SCHEMA platform;
+
+
+--
+-- PostgreSQL database dump complete
+--
+
