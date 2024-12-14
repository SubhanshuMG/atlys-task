#!/bin/bash
set -e
# Add support for AWS secret scan
git secrets --register-aws --global
# Scan the latest git push
git secrets --scan