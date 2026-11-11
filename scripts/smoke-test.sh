#!/usr/bin/env bash
# Boot check: Jenkins is up, JCasC applied security and generated the jobs.
set -euo pipefail
cd "$(dirname "$0")/.."
URL="${JENKINS_URL:-http://localhost:8080}"
USER_ID="${JENKINS_ADMIN_ID:-admin}"
PASS="$(cat secrets/jenkins_admin_password)"

fail() { echo "FAIL: $*" >&2; exit 1; }
code() { curl -s -o /dev/null -w '%{http_code}' "$@" || true; }

echo "Waiting for Jenkins at $URL ..."
for _ in $(seq 1 60); do
  [[ "$(code "$URL/login")" == "200" ]] && break
  sleep 5
done
[[ "$(code "$URL/login")" == "200" ]] || fail "Jenkins did not come up"

[[ "$(code "$URL/api/json")" == "403" ]] || fail "anonymous users can read the API"
echo "ok - anonymous access is denied"

[[ "$(code -u "$USER_ID:$PASS" "$URL/api/json")" == "200" ]] || fail "admin login from JCasC failed"
echo "ok - admin user from JCasC can log in"

jobs="$(curl -fsS -u "$USER_ID:$PASS" "$URL/job/platform/api/json?tree=jobs[name]")"
grep -q '"sample-service"' <<<"$jobs" || fail "Job DSL did not create platform/sample-service"
echo "ok - Job DSL created platform/sample-service"

executors="$(curl -fsS -u "$USER_ID:$PASS" "$URL/computer/api/json?tree=computer[numExecutors]")"
grep -q '"numExecutors":0' <<<"$executors" || fail "controller has executors"
echo "ok - controller runs no builds"

echo "All smoke tests passed"
