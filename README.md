# SchemaDiff

SchemaDiff is a set of mix tasks for comparing the structure of JSON payloads. It does this by converting a JSON payload into a schema, and then running a diff algorithm on it.

# Usage

## schema
Generate a schema from a file, prints to STDOUT

Accepts the following extensions:
* `.ex`
* `.exs`
* `.json`
* `.schema`

### Example
``` bash
$ echo '{"a": 1}' > one.json
$ mix schema ./one.json
{
  "sub_type": {
    "a": "number"
  },
  "type": "object"
}

```

## schema.diff
Diffs two files

### Example
``` bash
$ echo '{"a": 1}' > one.json
$ echo '{"a": "hello"}' > two.json
$ mix schema.diff ./one.json ./two.json
--- /dev/fd/63	2021-01-26 13:38:13.000000000 -0500
+++ /dev/fd/62	2021-01-26 13:38:13.000000000 -0500
@@ -1,6 +1,6 @@
 {
   "sub_type": {
-    "a": "number"
+    "a": "string"
   },
   "type": "object"
 }
```


## schema.diff_all
If you have a directory of files that you would like to compare, diffing is simple.

### Example
``` bash
$ mix schema.diff_all ./my_directory
--- /dev/fd/63	2021-01-26 13:38:13.000000000 -0500
+++ /dev/fd/62	2021-01-26 13:38:13.000000000 -0500
@@ -1,6 +1,6 @@
 {
   "sub_type": {
-    "a": "number"
+    "a": "string"
   },
   "type": "object"
 }
--- /dev/fd/63	2021-01-26 13:38:14.000000000 -0500
+++ /dev/fd/62	2021-01-26 13:38:14.000000000 -0500
@@ -1,6 +1,11 @@
 {
   "sub_type": {
-    "a": "number"
+    "a": {
+      "sub_type": {
+        "b": "number"
+      },
+      "type": "object"
+    }
   },
   "type": "object"
 }
--- /dev/fd/63	2021-01-26 13:38:14.000000000 -0500
+++ /dev/fd/62	2021-01-26 13:38:14.000000000 -0500
@@ -1,6 +1,11 @@
 {
   "sub_type": {
-    "a": "string"
+    "a": {
+      "sub_type": {
+        "b": "number"
+      },
+      "type": "object"
+    }
   },
   "type": "object"
 }
```

## schema.diff
Diffs two files

### Example
``` bash
$ mix schema.diff ./one.json ./two.json
--- /dev/fd/63	2021-01-26 13:38:13.000000000 -0500
+++ /dev/fd/62	2021-01-26 13:38:13.000000000 -0500
@@ -1,6 +1,6 @@
 {
   "sub_type": {
-    "a": "number"
+    "a": "string"
   },
   "type": "object"
 }
```
