#!/bin/bash

set -o pipefail
set -e

echo "${1} <> ${2}"
diff -u <(mix schema $1) <(mix schema $2) | tail -n +4 || true
