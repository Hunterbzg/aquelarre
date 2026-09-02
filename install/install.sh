#!/usr/bin/env bash
# Instala Aquelarre en un proyecto consumidor (Cursor y/o Antigravity).
# Uso: ./install.sh [--target PATH] [--ide cursor|antigravity|all] [--dry-run] [--force]

set -euo pipefail

TARGET="."
IDE="all"
DRY_RUN=0
FORCE=0

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HARNESS_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

usage() {
  cat <<'EOF'
Aquelarre — instalador

Uso:
  ./install.sh [--target PATH] [--ide cursor|antigravity|all] [--dry-run] [--force]

Opciones:
  --target PATH   Proyecto destino (default: .)
  --ide IDE       cursor | antigravity | all (default: all)
  --dry-run       Mostrar acciones sin copiar
  --force         Sobrescribir docs/rules/templates existentes
  -h, --help      Esta ayuda
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target) TARGET="$2"; shift 2 ;;
    --ide) IDE="$2"; shift 2 ;;
    --dry-run) DRY_RUN=1; shift ;;
    --force) FORCE=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Opcion desconocida: $1" >&2; usage; exit 1 ;;
  esac
done

case "$IDE" in
  cursor|antigravity|all) ;;
  *) echo "IDE invalido: $IDE" >&2; exit 1 ;;
esac

TARGET="$(cd "$TARGET" && pwd)"
SOURCE_SKILLS="$HARNESS_ROOT/skills"
SOURCE_RULES="$HARNESS_ROOT/rules"
SOURCE_TEMPLATES="$HARNESS_ROOT/templates"
SOURCE_DOCS="$HARNESS_ROOT/docs"

step() { echo "→ $*"; }
ok() { echo "  ✓ $*"; }
skip() { echo "  ○ $*"; }

mkdir_p() {
  if [[ $DRY_RUN -eq 1 ]]; then
    step "mkdir $1"
  else
    mkdir -p "$1"
  fi
}

copy_file() {
  local src="$1" dest="$2"
  if [[ -f "$dest" && $FORCE -eq 0 ]]; then
    skip "ya existe (usa --force): $dest"
    return
  fi
  if [[ $DRY_RUN -eq 1 ]]; then
    step "copy $src -> $dest"
  else
    mkdir -p "$(dirname "$dest")"
    cp "$src" "$dest"
    ok "$(basename "$dest")"
  fi
}

install_skills_to() {
  local dest_root="$1"
  mkdir_p "$dest_root"
  local count=0
  for dir in "$SOURCE_SKILLS"/aquelarre-*; do
    [[ -d "$dir" ]] || continue
    local name
    name="$(basename "$dir")"
    if [[ $DRY_RUN -eq 1 ]]; then
      step "skills: $name -> $dest_root/$name"
    else
      rm -rf "$dest_root/$name"
      cp -R "$dir" "$dest_root/$name"
      ok "skill $name"
    fi
    count=$((count + 1))
  done
  if [[ $count -eq 0 ]]; then
    echo "No se encontraron skills aquelarre-* en $SOURCE_SKILLS" >&2
    exit 1
  fi
}

echo ""
echo "Aquelarre — instalador"
echo "  Harness: $HARNESS_ROOT"
echo "  Destino: $TARGET"
echo "  IDE:     $IDE"
[[ $DRY_RUN -eq 1 ]] && echo "  Modo:    dry-run"
echo ""

if [[ "$IDE" == "cursor" || "$IDE" == "all" ]]; then
  step "Skills → .cursor/skills/"
  install_skills_to "$TARGET/.cursor/skills"
fi

if [[ "$IDE" == "antigravity" || "$IDE" == "all" ]]; then
  step "Skills → .agents/skills/"
  install_skills_to "$TARGET/.agents/skills"
fi

if [[ "$IDE" == "cursor" || "$IDE" == "all" ]]; then
  step "Rules → .cursor/rules/"
  mkdir_p "$TARGET/.cursor/rules"
  for rule in "$SOURCE_RULES"/*.mdc; do
    [[ -f "$rule" ]] || continue
    copy_file "$rule" "$TARGET/.cursor/rules/$(basename "$rule")"
  done
fi

if [[ "$IDE" == "antigravity" || "$IDE" == "all" ]]; then
  skip "Rules Antigravity: sin ruta estandar aun"
  step "Workflows → .agents/workflows/"
  mkdir_p "$TARGET/.agents/workflows"
  if [[ $DRY_RUN -eq 1 ]]; then
    step "copy workflows $SOURCE_TEMPLATES/workflows -> $TARGET/.agents/workflows"
  else
    cp -R "$SOURCE_TEMPLATES/workflows/." "$TARGET/.agents/workflows/"
    ok "workflows Antigravity"
  fi
  copy_file "$SOURCE_TEMPLATES/AGENTS-antigravity.md" "$TARGET/.agents/AGENTS.md"
fi

step "Plantillas → templates/"
mkdir_p "$TARGET/templates"
if [[ $DRY_RUN -eq 1 ]]; then
  step "copy tree $SOURCE_TEMPLATES -> $TARGET/templates"
else
  cp -R "$SOURCE_TEMPLATES/." "$TARGET/templates/"
  ok "plantillas"
fi

step "Documentacion base → docs/"
copy_file "$SOURCE_DOCS/AI_WORKFLOW_SKILLS_SPEC.md" "$TARGET/docs/AI_WORKFLOW_SKILLS_SPEC.md"
copy_file "$SOURCE_DOCS/ARTIFACT_PATHS.md" "$TARGET/docs/ARTIFACT_PATHS.md"
copy_file "$SOURCE_DOCS/WORKFLOW_COMMANDS.md" "$TARGET/docs/WORKFLOW_COMMANDS.md"
copy_file "$SOURCE_DOCS/testing/EVIDENCE_LOCAL.md" "$TARGET/docs/testing/EVIDENCE_LOCAL.md"
copy_file "$SOURCE_TEMPLATES/PROJECT-CONTEXT.md" "$TARGET/docs/project-context.md"

step "Scaffold docs/workflow"
scaffold_dirs=(
  docs/workflow/tasks
  docs/workflow/epics
  docs/workflow/stories
  docs/workflow/sprints
  docs/discovery
  docs/discovery/external-apis
  docs/architecture/api-contracts
  docs/ux/specs
  docs/adr
  docs/qa/test-plans
  docs/testing/evidence
  docs/product/briefs
  docs/db/schema-changes
  docs/supabase
  docs/spikes
  docs/tech-debt/refactor-plans
)
for rel in "${scaffold_dirs[@]}"; do
  if [[ ! -d "$TARGET/$rel" ]]; then
  mkdir_p "$TARGET/$rel"
  [[ $DRY_RUN -eq 0 ]] && ok "creado $rel"
  else
    skip "$rel (ya existe)"
  fi
done

GI="$TARGET/docs/testing/evidence/.gitignore"
if [[ ! -f "$GI" ]]; then
  if [[ $DRY_RUN -eq 1 ]]; then
    step "crear docs/testing/evidence/.gitignore"
  else
    cat > "$GI" <<'GITIGNORE'
# Evidencia visual QA — no versionar (ver docs/testing/EVIDENCE_LOCAL.md)
*
!.gitignore
GITIGNORE
    ok "docs/testing/evidence/.gitignore"
  fi
fi

SKILL_COUNT=$(find "$SOURCE_SKILLS" -maxdepth 1 -type d -name 'aquelarre-*' | wc -l | tr -d ' ')
MANIFEST="$TARGET/.aquelarre-install.json"
if [[ $DRY_RUN -eq 1 ]]; then
  step "manifest -> $MANIFEST"
else
  cat > "$MANIFEST" <<EOF
{
  "version": "0.2.0",
  "installedAt": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "harnessRoot": "$HARNESS_ROOT",
  "ide": "$IDE",
  "skillsCount": $SKILL_COUNT
}
EOF
  ok ".aquelarre-install.json"
fi

echo ""
echo "Instalacion completada."
echo "Siguiente: ejecutar aquelarre-discovery en el proyecto o crear el primer TASK."
echo ""
