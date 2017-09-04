#!/bin/sh
# Example ip-detect script using an external authority
# Uses the AWS Metadata Service to get the node's internal
# ipv4 address
set -o nounset -o errexit

curl -fsSL http://169.254.169.254/latest/meta-data/local-ipv4
