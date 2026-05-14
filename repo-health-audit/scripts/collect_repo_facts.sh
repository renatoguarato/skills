#!/usr/bin/env bash

set -euo pipefail

echo "## Repository files"
find . \
  -path './.git' -prune -o \
  -path './node_modules' -prune -o \
  -path './target' -prune -o \
  -path './build' -prune -o \
  -type f -maxdepth 4 -print | sort | head -500

echo ""
echo "## Important manifests"
find . \
  -path './.git' -prune -o \
  -path './node_modules' -prune -o \
  -type f \( \
    -iname 'README*' -o \
    -iname 'package.json' -o \
    -iname 'pom.xml' -o \
    -iname 'build.gradle' -o \
    -iname 'build.gradle.kts' -o \
    -iname 'settings.gradle' -o \
    -iname 'settings.gradle.kts' -o \
    -iname 'go.mod' -o \
    -iname 'pyproject.toml' -o \
    -iname 'requirements.txt' -o \
    -iname 'Dockerfile' -o \
    -iname 'docker-compose.yml' -o \
    -iname 'sonar-project.properties' \
  \) -print | sort

echo ""
echo "## TODO / FIXME / HACK"
grep -RIn \
  --exclude-dir=.git \
  --exclude-dir=node_modules \
  --exclude-dir=target \
  --exclude-dir=build \
  "TODO\|FIXME\|HACK\|workaround\|temporary\|deprecated" . || true

echo ""
echo "## Observability indicators"
grep -RIn \
  --exclude-dir=.git \
  --exclude-dir=node_modules \
  --exclude-dir=target \
  --exclude-dir=build \
  "OpenTelemetry\|otel\|traceId\|correlation\|Correlation\|Prometheus\|Micrometer\|Datadog\|NewRelic\|CloudWatch\|Splunk\|logger\|log\|health\|readiness\|liveness" . || true

echo ""
echo "## Potential secret indicators"
grep -RIn \
  --exclude-dir=.git \
  --exclude-dir=node_modules \
  --exclude-dir=target \
  --exclude-dir=build \
  "password\|passwd\|secret\|token\|api_key\|apikey\|Authorization\|Bearer\|private_key\|BEGIN RSA\|aws_access_key\|aws_secret" . || true