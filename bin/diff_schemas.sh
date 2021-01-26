#!/bin/bash

set -o pipefail
set -e

diff -u <(mix schema $1) <(mix schema $2) || true
