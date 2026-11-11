#!/usr/bin/env bash
# Generate the admin password once. secrets/ is git-ignored.
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p secrets
chmod 700 secrets
if [[ ! -s secrets/jenkins_admin_password ]]; then
  openssl rand -base64 24 | tr -d '\n' > secrets/jenkins_admin_password
  echo "Generated secrets/jenkins_admin_password"
fi
# Readable by the container's jenkins user; the directory itself stays private.
chmod 644 secrets/jenkins_admin_password
