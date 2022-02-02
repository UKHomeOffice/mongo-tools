#!/bin/bash

go get .
./make build

echo "APPS BUILT AND AVAILABLE IN /app/bin (where ever that is mounted)"
