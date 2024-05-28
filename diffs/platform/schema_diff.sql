--- backup/platform/snapshot.sql	2024-05-28 20:27:26.824865575 +0000
+++ snapshots/platform/snapshot.sql	2024-05-28 20:27:21.000000000 +0000
@@ -23,6 +23,111 @@
 CREATE SCHEMA platform;
 
 
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
+    created_on timestamp with time zone DEFAULT now() NOT NULL
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
 --
 -- PostgreSQL database dump complete
 --
