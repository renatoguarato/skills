#!/usr/bin/env bash

set -euo pipefail

REPO_URL="${1:-https://github.com/renatoguarato/skills.git}"
INSTALL_DIR="${HOME}/.agent-skills"

echo "Instalando skills de: ${REPO_URL}"

if [ -d "$INSTALL_DIR/.git" ]; then
  echo "Atualizando repositório existente..."
  git -C "$INSTALL_DIR" pull
else
  echo "Clonando repositório..."
  git clone "$REPO_URL" "$INSTALL_DIR"
fi

echo "Instalando..."
mkdir -p "${HOME}/.agents/skills"
ln -sfn "${INSTALL_DIR}/repo-health-audit" "${HOME}/.agents/skills/repo-health-audit"

mkdir -p "${HOME}/.claude/skills"
ln -sfn "${INSTALL_DIR}/repo-health-audit" "${HOME}/.claude/skills/repo-health-audit"

chmod +x "${INSTALL_DIR}/repo-health-audit/scripts/"*.sh 2>/dev/null || true

echo "Instalação concluída."