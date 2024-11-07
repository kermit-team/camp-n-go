#!/usr/bin/env sh

set -o errexit
set -o nounset

pyclean () {
  find . | grep -E '(__pycache__|\.py[cod]$)' | xargs rm -rf
}

run_check () {
  echo flake8...
  flake8 .

  echo xenon...
  xenon --max-absolute A --max-modules A --max-average A server -i 'test*'

  echo security...
  pip-audit --desc on --ignore-vuln GHSA-8fww-64cx-x8p5

  echo bandit...
  bandit -ii -ll -r /code/server

  echo mypy...
  mypy . --install-types --non-interactive --config-file setup.cfg
}

# Remove any cache before the script:
pyclean

# Clean everything up:
trap pyclean EXIT INT TERM

# Run the CI process:
run_check
