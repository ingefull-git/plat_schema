--- backup/platform/snapshot.sql	2024-05-28 20:09:54.634709269 +0000
+++ snapshots/platform/snapshot.sql	2024-05-28 20:09:43.000000000 +0000
@@ -66,7 +66,8 @@
     id integer NOT NULL,
     name character varying(100) NOT NULL,
     email character varying(100) NOT NULL,
-    created_on timestamp with time zone DEFAULT now() NOT NULL
+    created_on timestamp with time zone DEFAULT now() NOT NULL,
+    is_admin boolean DEFAULT false NOT NULL
 );
 
 
