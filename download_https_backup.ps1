$targetPath = "C:\hongsen_ai"

Write-Host ""
Write-Host "=== Please enter yes ===" -ForegroundColor Yellow
Write-Host ""

# 確保主資料夾存在
if (-Not (Test-Path $targetPath)) {
    Write-Host "folder not found!! please use exe file first" -ForegroundColor Red
    exit 1
}

# 切換到指定資料夾
Set-Location $targetPath

# 定義要 clone 的 repo
$repos = @(
    @{ url = "https://github.com/wileyliao/hsai_hos_config_branch.git"; folder = "hsai_hos_config_branch" },
    @{ url = "https://github.com/wileyliao/hsai_hos_config_project.git"; folder = "hsai_hos_config_project" },
    @{ url = "https://github.com/wileyliao/hsai_hos_nginx.git"; folder = "hsai_hos_nginx" }
)

$all_success = $true

# 逐一處理每個 repo
foreach ($repo in $repos) {
    $repoPath = Join-Path $targetPath $repo.folder
    if (Test-Path $repoPath) {
        Write-Host "[$($repo.folder)] already exists, pulling latest changes..." -ForegroundColor Yellow
        Set-Location $repoPath
        git pull
        if ($LASTEXITCODE -ne 0) {
            Write-Host "git pull failed for [$($repo.folder)]!" -ForegroundColor Red
            $all_success = $false
            break
        }
        Set-Location $targetPath
    } else {
        Write-Host "Cloning [$($repo.folder)] ..." -ForegroundColor Cyan
        git clone $repo.url
        if ($LASTEXITCODE -ne 0) {
            Write-Host "git clone failed for [$($repo.folder)]!" -ForegroundColor Red
            $all_success = $false
            break
        }
    }
}

Write-Host ""

if ($all_success) {
    Write-Host "Download successful ..." -ForegroundColor Green
} else {
    Write-Host "Download failed!" -ForegroundColor Red
}

Write-Host "Press any key to continue..."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
