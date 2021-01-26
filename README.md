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
$ mix schema.diff one.json two.json
one.json <> two.json
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
$ mix schema.diff_all data/examples
 data/examples/1.json <> data/examples/2.json
 {
   "sub_type": {
-    "a": "number"
+    "a": "string"
   },
   "type": "object"
 }
data/examples/1.json <> data/examples/3.json
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
data/examples/2.json <> data/examples/3.json
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
