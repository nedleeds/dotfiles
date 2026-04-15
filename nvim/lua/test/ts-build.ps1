# ts-build.ps1
# nvim-treesitter parser 자동 설치 스크립트 (사내 보안망 환경용)
# 요구사항: clang, curl (Windows 내장), nvim-treesitter (lazy.nvim)

$ErrorActionPreference = "Stop"

# =============================================
# 설치할 parser 목록 (필요에 따라 추가/제거)
# =============================================
$PARSERS = @(
    "yaml", "bash", "html", "python", "cpp",
    "css", "javascript", "rust", "zig", "powershell",
    "lua", "vim", "vimdoc", "query",
    "json", "toml", "markdown", "markdown_inline"
)

# =============================================
# 경로 설정
# =============================================
$NVIM_DATA       = "$env:LOCALAPPDATA\nvim-data"
$PLUGIN_DIR      = "$NVIM_DATA\lazy\nvim-treesitter"
$PARSER_DIR      = "$PLUGIN_DIR\parser"
$INSTALL_LUA     = "$PLUGIN_DIR\lua\nvim-treesitter\install.lua"
$PARSERS_LUA     = "$PLUGIN_DIR\lua\nvim-treesitter\parsers.lua"
$TEMP_DIR        = "$env:TEMP\nvim"

# =============================================
# 유틸리티 함수
# =============================================
function Write-Step($msg) { Write-Host "`n[*] $msg" -ForegroundColor Cyan }
function Write-Ok($msg)   { Write-Host "    OK: $msg" -ForegroundColor Green }
function Write-Err($msg)  { Write-Host "    ERROR: $msg" -ForegroundColor Red }
function Write-Warn($msg) { Write-Host "    WARN: $msg" -ForegroundColor Yellow }

# =============================================
# 1. clang 확인
# =============================================
Write-Step "clang 확인..."
try {
    $clangVer = clang --version 2>&1 | Select-String "clang version"
    Write-Ok $clangVer
} catch {
    Write-Err "clang 을 찾을 수 없습니다. clang 을 설치 후 다시 실행하세요."
    exit 1
}

# =============================================
# 2. install.lua 에 --ssl-no-revoke 추가
# =============================================
Write-Step "install.lua --ssl-no-revoke 확인..."
if (Test-Path $INSTALL_LUA) {
    $content = Get-Content $INSTALL_LUA -Raw
    if ($content -notmatch "--ssl-no-revoke") {
        $content = $content -replace "('--silent',)", "'--silent',`n      '--ssl-no-revoke',"
        Set-Content $INSTALL_LUA $content -Encoding UTF8
        Write-Ok "--ssl-no-revoke 추가 완료"
    } else {
        Write-Ok "--ssl-no-revoke 이미 존재"
    }
} else {
    Write-Err "install.lua 를 찾을 수 없습니다: $INSTALL_LUA"
    exit 1
}

# =============================================
# 3. parser 디렉토리 생성
# =============================================
Write-Step "parser 디렉토리 확인..."
if (-not (Test-Path $PARSER_DIR)) {
    New-Item -ItemType Directory -Path $PARSER_DIR | Out-Null
    Write-Ok "생성: $PARSER_DIR"
} else {
    Write-Ok "존재: $PARSER_DIR"
}

# =============================================
# 4. parsers.lua 에서 url, revision 파싱
# =============================================
Write-Step "parsers.lua 에서 parser 정보 파싱..."
$parsersContent = Get-Content $PARSERS_LUA -Raw

function Get-ParserInfo($lang) {
    # url 추출 - 정확한 키 매칭
    if ($parsersContent -match "(?s)\b$lang\s*=\s*\{.*?url\s*=\s*'([^']+)'") {
        $url = $Matches[1]
    } else {
        return $null
    }
    # revision 추출
    if ($parsersContent -match "(?s)\b$lang\s*=\s*\{.*?revision\s*=\s*'([^']+)'") {
        $revision = $Matches[1]
    } else {
        return $null
    }
    return @{ url = $url; revision = $revision }
}

# =============================================
# 5. 각 parser 다운로드 → 컴파일 → 복사
# =============================================
Write-Step "parser 설치 시작..."

foreach ($lang in $PARSERS) {
    Write-Host "`n  [$lang]" -ForegroundColor Magenta

    # parser 정보 가져오기
    $info = Get-ParserInfo $lang
    if (-not $info) {
        Write-Warn "$lang 정보를 parsers.lua 에서 찾을 수 없습니다. 건너뜁니다."
        continue
    }

    $url      = $info.url
    $revision = $info.revision
    $zipUrl   = "$url/archive/$revision.zip"
    $repoName = ($url -split "/")[-1]
    $extractDir = "$TEMP_DIR\$repoName"
    $zipPath    = "$TEMP_DIR\$repoName.zip"

    Write-Host "    URL: $url" -ForegroundColor DarkGray
    Write-Host "    Rev: $revision" -ForegroundColor DarkGray

    # 다운로드
    Write-Host "    Downloading..." -NoNewline
    try {
        & curl.exe --silent --ssl-no-revoke --fail -L $zipUrl --output $zipPath
        if ($LASTEXITCODE -ne 0 -or -not (Test-Path $zipPath)) {
            Write-Err "다운로드 실패: $zipUrl"
            continue
        }
        Write-Host " done" -ForegroundColor Green
    } catch {
        Write-Err "다운로드 실패: $zipUrl"
        continue
    }

    # 압축 해제
    Write-Host "    Extracting..." -NoNewline
    if (Test-Path $extractDir) {
        Remove-Item $extractDir -Recurse -Force
    }
    try {
        Expand-Archive -Path $zipPath -DestinationPath $TEMP_DIR -Force
        # 압축 해제 시 폴더명이 repoName-revision 또는 repoName-revision(v 제거) 형태
        $revisionStripped = $revision -replace '^v', ''
        $extractedFolder = "$TEMP_DIR\$repoName-$revision"
        $extractedFolderStripped = "$TEMP_DIR\$repoName-$revisionStripped"
        $actualFolder = if (Test-Path $extractedFolder) { $extractedFolder }
                        elseif (Test-Path $extractedFolderStripped) { $extractedFolderStripped }
                        else { $null }
        if ($actualFolder) {
            if (Test-Path $extractDir) { Remove-Item $extractDir -Recurse -Force }
            Rename-Item $actualFolder $extractDir
        }
        Write-Host " done" -ForegroundColor Green
    } catch {
        Write-Err "압축 해제 실패"
        continue
    }

    # src 폴더 확인 (markdown 은 서브 디렉토리 구조)
    if ($lang -eq "markdown") {
        $srcDir = "$extractDir\tree-sitter-markdown\src"
    } elseif ($lang -eq "markdown_inline") {
        $srcDir = "$extractDir\tree-sitter-markdown-inline\src"
    } else {
        $srcDir = "$extractDir\src"
    }
    if (-not (Test-Path $srcDir)) {
        Write-Err "src 폴더를 찾을 수 없습니다: $srcDir"
        continue
    }

    # .c / .cc 파일 수집
    $cFiles   = Get-ChildItem "$srcDir\*.c"  -ErrorAction SilentlyContinue | ForEach-Object { $_.FullName }
    $cppFiles = Get-ChildItem "$srcDir\*.cc" -ErrorAction SilentlyContinue | ForEach-Object { $_.FullName }
    if ($cFiles.Count -eq 0 -and $cppFiles.Count -eq 0) {
        Write-Err ".c/.cc 파일을 찾을 수 없습니다"
        continue
    }
    # 컴파일
    Write-Host "    Compiling..." -NoNewline
    $outputDll = "$extractDir\parser.dll"
    $cObj   = @()
    $cppObj = @()
    foreach ($f in $cFiles) {
        $obj = "$f.o"
        Write-Host "obj path: $obj"
        & clang -c -O2 -I $srcDir -D_CRT_SECURE_NO_WARNINGS -DTREE_SITTER_LANGUAGE_VERSION=15 $f -o $obj 2>&1
        if ($LASTEXITCODE -ne 0) { Write-Err "컴파일 실패: $f"; continue }
        $cObj += $obj
    }
    foreach ($f in $cppFiles) {
        $obj = "$f.o"
        & clang++ -c -O2 -I $srcDir -D_CRT_SECURE_NO_WARNINGS -DTREE_SITTER_LANGUAGE_VERSION=15 $f -o $obj 2>&1
        if ($LASTEXITCODE -ne 0) { Write-Err "컴파일 실패: $f"; continue }
        $cppObj += $obj
    }
    $allObjs = $cObj + $cppObj
    & clang++ -shared -fuse-ld=lld -o $outputDll $allObjs 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Err "링크 실패"
        continue
    }
    Write-Host " done" -ForegroundColor Green

    # 복사
    $dest = "$PARSER_DIR\$lang.dll"
    Copy-Item $outputDll $dest -Force
    Write-Ok "$lang.dll → $PARSER_DIR"
}

# =============================================
# 완료
# =============================================
Write-Host "`n======================================" -ForegroundColor Cyan
Write-Host "  완료! nvim 을 재시작하세요." -ForegroundColor Cyan
Write-Host "======================================`n" -ForegroundColor Cyan
