# blink-build.ps1
# blink.cmp 사전 빌드 바이너리 수동 설치 스크립트 (사내 보안망 환경용)
# 요구사항: curl (Windows 내장), git, nvim-treesitter (lazy.nvim)

$ErrorActionPreference = "Stop"

# =============================================
# 경로 설정
# =============================================
$NVIM_DATA    = "$env:LOCALAPPDATA\nvim-data"
$PLUGIN_DIR   = "$NVIM_DATA\lazy\blink.cmp"
$RELEASE_DIR  = "$PLUGIN_DIR\target\release"
$DLL_NAME     = "libblink_cmp_fuzzy.dll"
$SHA256_NAME  = "libblink_cmp_fuzzy.dll.sha256"
$VERSION_FILE = "$RELEASE_DIR\version"

# =============================================
# 유틸리티 함수
# =============================================
function Write-Step($msg) { Write-Host "`n[*] $msg" -ForegroundColor Cyan }
function Write-Ok($msg)   { Write-Host "    OK: $msg" -ForegroundColor Green }
function Write-Err($msg)  { Write-Host "    ERROR: $msg" -ForegroundColor Red }

# =============================================
# 1. blink.cmp 버전 확인 (git tag)
# =============================================
Write-Step "blink.cmp 버전 확인..."
try {
    $tag = git -C $PLUGIN_DIR tag --points-at HEAD 2>&1
    if (-not $tag) {
        Write-Err "git tag를 찾을 수 없습니다."
        exit 1
    }
    Write-Ok "버전: $tag"
} catch {
    Write-Err "git 실행 실패. git이 PATH에 있는지 확인하세요."
    exit 1
}

# =============================================
# 2. release 디렉토리 생성
# =============================================
Write-Step "release 디렉토리 확인..."
if (-not (Test-Path $RELEASE_DIR)) {
    New-Item -ItemType Directory -Path $RELEASE_DIR | Out-Null
    Write-Ok "생성: $RELEASE_DIR"
} else {
    Write-Ok "존재: $RELEASE_DIR"
}

# =============================================
# 3. DLL 다운로드
# =============================================
Write-Step "DLL 다운로드..."
$dllUrl = "https://github.com/saghen/blink.cmp/releases/download/$tag/x86_64-pc-windows-msvc.dll"
$dllDest = "$RELEASE_DIR\$DLL_NAME"

Write-Host "    URL: $dllUrl" -ForegroundColor DarkGray
Write-Host "    Downloading DLL..." -NoNewline
try {
    & curl.exe --silent --ssl-no-revoke --fail -L $dllUrl --output $dllDest
    Write-Host " done" -ForegroundColor Green
} catch {
    Write-Err "DLL 다운로드 실패: $dllUrl"
    exit 1
}

# =============================================
# 4. SHA256 다운로드 및 형식 수정
# =============================================
Write-Step "SHA256 다운로드..."
$sha256Url = "https://github.com/saghen/blink.cmp/releases/download/$tag/x86_64-pc-windows-msvc.dll.sha256"
$sha256Dest = "$RELEASE_DIR\$SHA256_NAME"
$sha256Temp = "$RELEASE_DIR\sha256.tmp"

Write-Host "    URL: $sha256Url" -ForegroundColor DarkGray
Write-Host "    Downloading SHA256..." -NoNewline
try {
    & curl.exe --silent --ssl-no-revoke --fail -L $sha256Url --output $sha256Temp
    Write-Host " done" -ForegroundColor Green
} catch {
    Write-Err "SHA256 다운로드 실패: $sha256Url"
    exit 1
}

# sha256 파일에서 hash 값만 추출 후 올바른 형식으로 저장
$sha256Content = Get-Content $sha256Temp -Raw
$hash = ($sha256Content -split '\s+')[0]
"$hash  $DLL_NAME" | Out-File -FilePath $sha256Dest -Encoding utf8 -NoNewline
Remove-Item $sha256Temp -Force
Write-Ok "SHA256: $hash"

# =============================================
# 5. version 파일 삭제 (v0.0.0 초기화 방지)
# =============================================
Write-Step "version 파일 처리..."
if (Test-Path $VERSION_FILE) {
    Remove-Item $VERSION_FILE -Force
    Write-Ok "version 파일 삭제 완료"
} else {
    Write-Ok "version 파일 없음 (건너뜀)"
}

# =============================================
# 완료
# =============================================
Write-Host "`n======================================" -ForegroundColor Cyan
Write-Host "  완료! nvim 을 재시작하세요." -ForegroundColor Cyan
Write-Host "======================================`n" -ForegroundColor Cyan
