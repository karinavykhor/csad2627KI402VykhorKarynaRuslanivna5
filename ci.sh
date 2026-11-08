#!/usr/bin/env bash
set -euo pipefail

mvn -B -ntp verify
mkdir -p dist
cp target/hello.jar dist/hello.jar
