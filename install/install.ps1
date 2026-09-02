#Requires -Version 5.1
<#
.SYNOPSIS
  Instala Aquelarre en un proyecto consumidor (Cursor y/o Antigravity).

.PARAMETER Dest
  Ruta del proyecto destino. Default: directorio actual. También acepta posición 0.

.PARAMETER Ide
  cursor | antigravity | all (default: all)

.PARAMETER DryRun
  Muestra acciones sin copiar archivos.

.PARAMETER Force
  Sobrescribe docs, rules y plantillas ya instalados.

.EXAMPLE
  .\install.ps1 -Dest ..\mi-proyecto
  .\install.ps1 -Dest ..\mi-proyecto -Ide cursor
#>
[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [string]$Dest = '.',

    [ValidateSet('cursor', 'antigravity', 'all')]
    [string]$Ide = 'all',

    [switch]$DryRun,

    [switch]$Force
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Write-Step([string]$Message) {
    Write-Host ('-> ' + $Message) -ForegroundColor Cyan
}

function Write-Ok([string]$Message) {
    Write-Host ('  OK ' + $Message) -ForegroundColor Green
}

function Write-Skip([string]$Message) {
    Write-Host ('  .. ' + $Message) -ForegroundColor DarkGray
}

function Ensure-Dir([string]$Path) {
    if (-not (Test-Path -LiteralPath $Path)) {
        if ($DryRun) {
            Write-Step ('mkdir ' + $Path)
        } else {
            New-Item -ItemType Directory -Path $Path -Force | Out-Null
        }
    }
}

function Copy-AquelarreSkills([string]$From, [string]$To) {
    Ensure-Dir $To
    $dirs = @(Get-ChildItem -LiteralPath $From -Directory -Filter 'aquelarre-*')
    if ($dirs.Count -eq 0) {
        throw ('No hay skills aquelarre-* en ' + $From)
    }
    foreach ($d in $dirs) {
        $dest = Join-Path $To $d.Name
        if ($DryRun) {
            Write-Step ('skill ' + $d.Name + ' -> ' + $dest)
        } else {
            if (Test-Path -LiteralPath $dest) {
                Remove-Item -LiteralPath $dest -Recurse -Force
            }
            Copy-Item -LiteralPath $d.FullName -Destination $dest -Recurse -Force
            Write-Ok ('skill ' + $d.Name)
        }
    }
}

function Copy-AquelarreFile([string]$From, [string]$To) {
    if (-not (Test-Path -LiteralPath $From)) {
        Write-Skip ('origen ausente: ' + $From)
        return
    }
    Ensure-Dir (Split-Path $To -Parent)
    if ((Test-Path -LiteralPath $To) -and -not $Force) {
        Write-Skip ((Split-Path $To -Leaf) + ' (usa -Force)')
        return
    }
    if ($DryRun) {
        Write-Step ('copy ' + $From + ' -> ' + $To)
    } else {
        Copy-Item -LiteralPath $From -Destination $To -Force:$Force
        Write-Ok (Split-Path $To -Leaf)
    }
}

# --- Rutas ---

$Harness = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
Ensure-Dir $Dest
$Dest = (Resolve-Path -LiteralPath $Dest).Path

$wantCursor = ($Ide -eq 'all') -or ($Ide -eq 'cursor')
$wantAgents = ($Ide -eq 'all') -or ($Ide -eq 'antigravity')

Write-Host ''
Write-Host 'Aquelarre - instalador' -ForegroundColor Yellow
Write-Host ('  Harness: ' + $Harness)
Write-Host ('  Destino: ' + $Dest)
Write-Host ('  IDE:     ' + $Ide)
if ($DryRun) { Write-Host '  Modo:    dry-run' -ForegroundColor DarkYellow }
Write-Host ''

# --- Skills ---

if ($wantCursor) {
    Write-Step 'Skills -> .cursor/skills/'
    Copy-AquelarreSkills (Join-Path $Harness 'skills') (Join-Path $Dest '.cursor\skills')
}

if ($wantAgents) {
    Write-Step 'Skills -> .agents/skills/'
    Copy-AquelarreSkills (Join-Path $Harness 'skills') (Join-Path $Dest '.agents\skills')
}

function Copy-AquelarreWorkflows([string]$From, [string]$To) {
    $wfSrc = Join-Path $From 'workflows'
    if (-not (Test-Path -LiteralPath $wfSrc)) {
        Write-Skip 'sin carpeta templates/workflows'
        return
    }
    Ensure-Dir $To
    foreach ($wf in @(Get-ChildItem -LiteralPath $wfSrc -Filter '*.md' -File)) {
        $dest = Join-Path $To $wf.Name
        if ($DryRun) {
            Write-Step ('workflow ' + $wf.Name + ' -> ' + $dest)
        } else {
            Copy-Item -LiteralPath $wf.FullName -Destination $dest -Force
            Write-Ok ('workflow ' + $wf.Name)
        }
    }
}

# --- Rules (Cursor) ---

if ($wantCursor) {
    Write-Step 'Rules -> .cursor/rules/'
    $rulesDest = Join-Path $Dest '.cursor\rules'
    Ensure-Dir $rulesDest
    foreach ($rule in @(Get-ChildItem -LiteralPath (Join-Path $Harness 'rules') -Filter '*.mdc' -File -ErrorAction SilentlyContinue)) {
        Copy-AquelarreFile $rule.FullName (Join-Path $rulesDest $rule.Name)
    }
}

if ($wantAgents) {
    Write-Skip 'Rules Antigravity: sin ruta estandar aun'
    Write-Step 'Workflows -> .agents/workflows/'
    Copy-AquelarreWorkflows (Join-Path $Harness 'templates') (Join-Path $Dest '.agents\workflows')
    Copy-AquelarreFile (Join-Path $Harness 'templates\AGENTS-antigravity.md') (Join-Path $Dest '.agents\AGENTS.md')
}

# --- Plantillas ---

Write-Step 'Plantillas -> templates/'
$tplDest = Join-Path $Dest 'templates'
Ensure-Dir $tplDest
if ($DryRun) {
    Write-Step ('copy tree ' + (Join-Path $Harness 'templates') + ' -> ' + $tplDest)
} else {
    Copy-Item -Path (Join-Path $Harness 'templates\*') -Destination $tplDest -Recurse -Force:$Force
    Write-Ok 'plantillas'
}

# --- Docs base ---

Write-Step 'Documentacion -> docs/'
Copy-AquelarreFile (Join-Path $Harness 'docs\AI_WORKFLOW_SKILLS_SPEC.md') (Join-Path $Dest 'docs\AI_WORKFLOW_SKILLS_SPEC.md')
Copy-AquelarreFile (Join-Path $Harness 'docs\ARTIFACT_PATHS.md') (Join-Path $Dest 'docs\ARTIFACT_PATHS.md')
Copy-AquelarreFile (Join-Path $Harness 'docs\WORKFLOW_COMMANDS.md') (Join-Path $Dest 'docs\WORKFLOW_COMMANDS.md')
Copy-AquelarreFile (Join-Path $Harness 'docs\testing\EVIDENCE_LOCAL.md') (Join-Path $Dest 'docs\testing\EVIDENCE_LOCAL.md')
Copy-AquelarreFile (Join-Path $Harness 'templates\PROJECT-CONTEXT.md') (Join-Path $Dest 'docs\project-context.md')

# --- Scaffold ---

Write-Step 'Scaffold docs/workflow'
$dirs = @(
    'docs\workflow\tasks', 'docs\workflow\epics', 'docs\workflow\stories',
    'docs\workflow\sprints',
    'docs\discovery', 'docs\discovery\external-apis',
    'docs\architecture\api-contracts',
    'docs\ux\specs', 'docs\adr', 'docs\qa\test-plans',
    'docs\testing\evidence', 'docs\product\briefs', 'docs\db\schema-changes',
    'docs\supabase', 'docs\spikes', 'docs\tech-debt\refactor-plans'
)
foreach ($rel in $dirs) {
    $full = Join-Path $Dest $rel
    if (-not (Test-Path -LiteralPath $full)) {
        Ensure-Dir $full
        if (-not $DryRun) { Write-Ok ('creado ' + $rel) }
    } else {
        Write-Skip ($rel + ' (ya existe)')
    }
}

$gi = Join-Path $Dest 'docs\testing\evidence\.gitignore'
if (-not (Test-Path -LiteralPath $gi)) {
    if ($DryRun) {
        Write-Step 'crear docs/testing/evidence/.gitignore'
    } else {
        @(
            '# Evidencia visual QA - no versionar (ver docs/testing/EVIDENCE_LOCAL.md)',
            '*',
            '!.gitignore'
        ) | Set-Content -LiteralPath $gi -Encoding UTF8
        Write-Ok 'evidence/.gitignore'
    }
}

# --- Manifiesto ---

$skillCount = @(Get-ChildItem -LiteralPath (Join-Path $Harness 'skills') -Directory -Filter 'aquelarre-*').Count
$manifest = @{
    version     = '0.2.0'
    installedAt = (Get-Date).ToString('o')
    harnessRoot = $Harness
    ide         = $Ide
    skillsCount = $skillCount
} | ConvertTo-Json -Depth 3

$manifestFile = Join-Path $Dest '.aquelarre-install.json'
if ($DryRun) {
    Write-Step ('manifest -> ' + $manifestFile)
} else {
    Set-Content -LiteralPath $manifestFile -Value $manifest -Encoding UTF8
    Write-Ok '.aquelarre-install.json'
}

Write-Host ''
Write-Host 'Instalacion completada.' -ForegroundColor Green
Write-Host 'Siguiente: aquelarre-discovery o crear el primer TASK desde templates/TASK.md'
Write-Host ''
