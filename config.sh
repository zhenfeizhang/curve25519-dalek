#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SPPARK_DIR="${ROOT_DIR}/sppark"
REMOTE_URL="https://github.com/zhenfeizhang/sppark.git"
REMOTE_BRANCH="ed25519"

if [[ -d "${SPPARK_DIR}/.git" ]]; then
  echo "Updating sppark in ${SPPARK_DIR}"
  git -C "${SPPARK_DIR}" remote set-url origin "${REMOTE_URL}" >/dev/null 2>&1 || true
  git -C "${SPPARK_DIR}" fetch origin
  git -C "${SPPARK_DIR}" checkout "${REMOTE_BRANCH}"
  git -C "${SPPARK_DIR}" pull --ff-only origin "${REMOTE_BRANCH}"
elif [[ -d "${SPPARK_DIR}" ]]; then
  ts="$(date +%Y%m%d_%H%M%S)"
  backup="${SPPARK_DIR}.backup.${ts}"
  echo "Existing sppark directory found. Moving to ${backup}"
  mv "${SPPARK_DIR}" "${backup}"
  git clone --branch "${REMOTE_BRANCH}" --depth 1 "${REMOTE_URL}" "${SPPARK_DIR}"
else
  git clone --branch "${REMOTE_BRANCH}" --depth 1 "${REMOTE_URL}" "${SPPARK_DIR}"
fi

echo "sppark ready at ${SPPARK_DIR}"
