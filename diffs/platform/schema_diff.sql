--- backup/platform/snapshot.sql	2024-05-29 15:28:58.638174898 +0000
+++ snapshots/platform/snapshot.sql	2024-05-29 15:28:51.000000000 +0000
@@ -0,0 +1,135 @@
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
+SET default_tablespace = '';
+
+SET default_table_access_method = heap;
+
+--
+-- Name: refers; Type: TABLE; Schema: platform; Owner: -
+--
+
+CREATE TABLE platform.refers (
+    id integer NOT NULL,
+    name character varying(100) NOT NULL,
+    description character varying(250)
+);
+
+
+--
+-- Name: refers_id_seq; Type: SEQUENCE; Schema: platform; Owner: -
+--
+
+CREATE SEQUENCE platform.refers_id_seq
+    AS integer
+    START WITH 1
+    INCREMENT BY 1
+    NO MINVALUE
+    NO MAXVALUE
+    CACHE 1;
+
+
+--
+-- Name: refers_id_seq; Type: SEQUENCE OWNED BY; Schema: platform; Owner: -
+--
+
+ALTER SEQUENCE platform.refers_id_seq OWNED BY platform.refers.id;
+
+
+--
+-- Name: users; Type: TABLE; Schema: platform; Owner: -
+--
+
+CREATE TABLE platform.users (
+    id integer NOT NULL,
+    name character varying(100) NOT NULL,
+    email character varying(100) NOT NULL,
+    created_on timestamp with time zone DEFAULT now() NOT NULL,
+    is_admin boolean DEFAULT false NOT NULL
+);
+
+
+--
+-- Name: users_id_seq; Type: SEQUENCE; Schema: platform; Owner: -
+--
+
+CREATE SEQUENCE platform.users_id_seq
+    AS integer
+    START WITH 1
+    INCREMENT BY 1
+    NO MINVALUE
+    NO MAXVALUE
+    CACHE 1;
+
+
+--
+-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: platform; Owner: -
+--
+
+ALTER SEQUENCE platform.users_id_seq OWNED BY platform.users.id;
+
+
+--
+-- Name: refers id; Type: DEFAULT; Schema: platform; Owner: -
+--
+
+ALTER TABLE ONLY platform.refers ALTER COLUMN id SET DEFAULT nextval('platform.refers_id_seq'::regclass);
+
+
+--
+-- Name: users id; Type: DEFAULT; Schema: platform; Owner: -
+--
+
+ALTER TABLE ONLY platform.users ALTER COLUMN id SET DEFAULT nextval('platform.users_id_seq'::regclass);
+
+
+--
+-- Name: refers refers_pkey; Type: CONSTRAINT; Schema: platform; Owner: -
+--
+
+ALTER TABLE ONLY platform.refers
+    ADD CONSTRAINT refers_pkey PRIMARY KEY (id);
+
+
+--
+-- Name: users users_email_key; Type: CONSTRAINT; Schema: platform; Owner: -
+--
+
+ALTER TABLE ONLY platform.users
+    ADD CONSTRAINT users_email_key UNIQUE (email);
+
+
+--
+-- Name: users users_pkey; Type: CONSTRAINT; Schema: platform; Owner: -
+--
+
+ALTER TABLE ONLY platform.users
+    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
+
+
+--
+-- PostgreSQL database dump complete
+--
+
