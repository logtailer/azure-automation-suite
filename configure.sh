#!/usr/bin/env bash
# configure.sh — one-time setup: patches all dev-minimal.tfvars + writes .env
# Run this before your first deploy:  ./configure.sh && ./scripts/deploy-all.sh --auto-approve

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
TF="$REPO_ROOT/terraform"

# ── helpers ─────────────────────────────────────────────────────────────────

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'

ask() {
  local prompt="$1" default="${2:-}" var
  if [[ -n "$default" ]]; then
    printf "${CYAN}%s${NC} [%s]: " "$prompt" "$default"
  else
    printf "${CYAN}%s${NC}: " "$prompt"
  fi
  read -r var
  echo "${var:-$default}"
}

ask_secret() {
  local prompt="$1" var
  printf "${CYAN}%s${NC} (hidden): " "$prompt"
  read -rs var
  echo
  echo "$var"
}

patch() {
  # patch <file> <old_pattern> <new_value>
  # Replaces the value on the line matching old_pattern (key = "...") with new_value.
  local file="$1" pattern="$2" new_val="$3"
  # Escape special chars in new_val for sed replacement string
  local escaped
  escaped=$(printf '%s\n' "$new_val" | sed 's/[[\.*^$()+?{|]/\\&/g')
  sed -i.bak -E "s|^(${pattern}[[:space:]]*=[[:space:]]*).*|\1\"${escaped}\"|" "$file"
}

patch_num() {
  local file="$1" pattern="$2" new_val="$3"
  sed -i.bak -E "s|^(${pattern}[[:space:]]*=[[:space:]]*).*|\1${new_val}|" "$file"
}

patch_email_list() {
  # Replace single-element list:  key = ["old@example.com"]
  local file="$1" pattern="$2" email="$3"
  local escaped
  escaped=$(printf '%s\n' "$email" | sed 's/[[\.*^$()+?{|]/\\&/g')
  sed -i.bak -E "s|^(${pattern}[[:space:]]*=[[:space:]]*).*|\1[\"${escaped}\"]|" "$file"
}

patch_location_list() {
  # Replace allowed_locations = ["centralindia"] style entries
  local file="$1" region_lower="$2"
  sed -i.bak -E "s|^(allowed_locations[[:space:]]*=[[:space:]]*).*|\1[\"${region_lower}\"]|" "$file"
}

cleanup_bak() {
  find "$TF" -name "*.tfvars.bak" -delete
}

# ── banner ───────────────────────────────────────────────────────────────────

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Azure Platform Engineering Suite — first-time setup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "This patches all dev-minimal.tfvars files and writes .env"
echo "with your Azure credentials. Nothing is deployed yet."
echo ""

# ── section 1: Azure credentials ────────────────────────────────────────────

echo -e "${YELLOW}── Azure credentials ──────────────────────────────────────${NC}"
ARM_CLIENT_ID=$(ask       "Service principal client ID")
ARM_CLIENT_SECRET=$(ask_secret "Service principal client secret")
ARM_SUBSCRIPTION_ID=$(ask "Subscription ID")
ARM_TENANT_ID=$(ask       "Tenant ID")
echo ""

# ── section 2: basic preferences ────────────────────────────────────────────

echo -e "${YELLOW}── Preferences ────────────────────────────────────────────${NC}"
ALERT_EMAIL=$(ask   "Alert / notification email" "anandsumit2000@gmail.com")
BUDGET=$(ask        "Monthly budget cap (USD)"   "20")
LOCATION=$(ask      "Azure region"               "Central India")
# Derive the lowercase no-space form used in allowed_locations / backend keys
LOCATION_LOWER=$(echo "$LOCATION" | tr '[:upper:]' '[:lower:]' | tr -d ' ')
echo ""

# ── section 3: GitHub ────────────────────────────────────────────────────────

echo -e "${YELLOW}── GitHub ──────────────────────────────────────────────────${NC}"
GITHUB_ORG=$(ask        "GitHub username / org")
GITHUB_TOKEN=$(ask_secret "GitHub PAT (needs repo + write:packages)")
GITHUB_WEBHOOK_SECRET=$(ask_secret "GitHub webhook secret (for ARC runners, can be random)")
echo ""

# ── section 4: Backstage / IDP (optional) ───────────────────────────────────

echo -e "${YELLOW}── Backstage IDP (leave blank to skip) ────────────────────${NC}"
GITHUB_CLIENT_ID=$(ask     "GitHub OAuth App client ID     (07-idp)")
GITHUB_CLIENT_SECRET=$(ask_secret "GitHub OAuth App client secret (07-idp)")
echo ""

# ── section 5: Database passwords ───────────────────────────────────────────

echo -e "${YELLOW}── Database passwords ──────────────────────────────────────${NC}"
DB_PASSWORD=$(ask_secret "PostgreSQL admin password (07-idp + 14-database, min 8 chars)")
echo ""

# ── section 6: SSH public key ────────────────────────────────────────────────

echo -e "${YELLOW}── SSH public key (03-security) ────────────────────────────${NC}"
SSH_DEFAULT=""
if [[ -f "$HOME/.ssh/id_rsa.pub" ]]; then
  SSH_DEFAULT="$HOME/.ssh/id_rsa.pub"
elif [[ -f "$HOME/.ssh/id_ed25519.pub" ]]; then
  SSH_DEFAULT="$HOME/.ssh/id_ed25519.pub"
fi

if [[ -n "$SSH_DEFAULT" ]]; then
  USE_DEFAULT=$(ask "Use $SSH_DEFAULT? (y/n)" "y")
  if [[ "$USE_DEFAULT" =~ ^[Yy]$ ]]; then
    SSH_PUBLIC_KEY=$(cat "$SSH_DEFAULT")
  else
    SSH_PUBLIC_KEY=$(ask "Paste your SSH public key")
  fi
else
  SSH_PUBLIC_KEY=$(ask "Paste your SSH public key (ssh-rsa … or ssh-ed25519 …)")
fi
echo ""

# ── write .env ───────────────────────────────────────────────────────────────

ENV_FILE="$REPO_ROOT/.env"
cat > "$ENV_FILE" <<EOF
ARM_CLIENT_ID=$ARM_CLIENT_ID
ARM_CLIENT_SECRET=$ARM_CLIENT_SECRET
ARM_SUBSCRIPTION_ID=$ARM_SUBSCRIPTION_ID
ARM_TENANT_ID=$ARM_TENANT_ID
EOF
echo -e "${GREEN}✓ wrote .env${NC}"

# ── patch tfvars ──────────────────────────────────────────────────────────────

echo ""
echo -e "${YELLOW}── Patching dev-minimal.tfvars ─────────────────────────────${NC}"

# Helper: patch location in every module tfvars
for f in "$TF"/*/dev-minimal.tfvars; do
  patch         "$f" "location"                 "$LOCATION"
  patch_num     "$f" "monthly_budget_amount"     "$BUDGET"
  patch_num     "$f" "component_budget_amount"   "$BUDGET"
  patch_email_list "$f" "alert_email"            "$ALERT_EMAIL"
  patch_email_list "$f" "cost_alert_emails"      "$ALERT_EMAIL"
  patch_email_list "$f" "admin_email"            "$ALERT_EMAIL"
  patch_email_list "$f" "warning_alert_emails"   "$ALERT_EMAIL"
  patch_email_list "$f" "critical_alert_emails"  "$ALERT_EMAIL"
  patch_location_list "$f"                       "$LOCATION_LOWER"
done
echo -e "  location, budget, emails — all modules"

# 03-security — SSH key
patch "$TF/03-security/dev-minimal.tfvars" "ssh_public_key" "$SSH_PUBLIC_KEY"
echo -e "  ssh_public_key — 03-security"

# 06-cicd — GitHub
patch "$TF/06-cicd/dev-minimal.tfvars" "github_token"            "$GITHUB_TOKEN"
patch "$TF/06-cicd/dev-minimal.tfvars" "github_webhook_secret"   "$GITHUB_WEBHOOK_SECRET"
patch "$TF/06-cicd/dev-minimal.tfvars" "github_repository_owner" "$GITHUB_ORG"
echo -e "  github_token, github_webhook_secret, github_repository_owner — 06-cicd"

# 07-idp — GitHub OAuth + DB password
patch "$TF/07-idp/dev-minimal.tfvars" "github_token"         "$GITHUB_TOKEN"
patch "$TF/07-idp/dev-minimal.tfvars" "github_organization"  "$GITHUB_ORG"
if [[ -n "$GITHUB_CLIENT_ID" ]]; then
  patch "$TF/07-idp/dev-minimal.tfvars" "github_client_id"     "$GITHUB_CLIENT_ID"
fi
if [[ -n "$GITHUB_CLIENT_SECRET" ]]; then
  patch "$TF/07-idp/dev-minimal.tfvars" "github_client_secret" "$GITHUB_CLIENT_SECRET"
fi
patch "$TF/07-idp/dev-minimal.tfvars" "db_admin_password"    "$DB_PASSWORD"
echo -e "  github_*, db_admin_password — 07-idp"

# 09-governance — subscription ID
patch "$TF/09-governance/dev-minimal.tfvars" "subscription_id" "$ARM_SUBSCRIPTION_ID"
echo -e "  subscription_id — 09-governance"

# 14-database — DB password
patch "$TF/14-database/dev-minimal.tfvars" "postgresql_admin_password" "$DB_PASSWORD"
echo -e "  postgresql_admin_password — 14-database"

# 10-cost-management — alert_email is a bare string, not a list
sed -i.bak -E "s|^(alert_email[[:space:]]*=[[:space:]]*).*|\1\"${ALERT_EMAIL}\"|" \
  "$TF/10-cost-management/dev-minimal.tfvars"
echo -e "  alert_email — 10-cost-management"

cleanup_bak

# ── summary ───────────────────────────────────────────────────────────────────

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${GREEN}  Setup complete.${NC}"
echo ""
echo "  Next: run bootstrap once, then deploy:"
echo "    cd terraform/01-foundation && bash bootstrap.sh dev"
echo "    cd $REPO_ROOT"
echo "    ./scripts/deploy-all.sh --auto-approve"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
