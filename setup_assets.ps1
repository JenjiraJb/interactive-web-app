$assetsDir = Join-Path $PSScriptRoot "assets"
if (-not (Test-Path $assetsDir)) { 
    New-Item -ItemType Directory -Path $assetsDir | Out-Null
}

$logoSrc = "C:\Users\USER\.gemini\antigravity\brain\ff9fd69b-2f9a-43d4-980f-31ef4cf52b3a\gruru_logo_1791621253211.jpg"
$hallSrc = "C:\Users\USER\.gemini\antigravity\brain\ff9fd69b-2f9a-43d4-980f-31ef4cf52b3a\gruru_exhibition_hall_1791621285963.jpg"

if (Test-Path $logoSrc) { Copy-Item $logoSrc (Join-Path $assetsDir "gruru_logo.jpg") -Force }
if (Test-Path $hallSrc) { Copy-Item $hallSrc (Join-Path $assetsDir "gruru_museum_hall.jpg") -Force }

# Copy existing PNGs
$images = Get-ChildItem -Path $PSScriptRoot -Filter "ChatGPT Image*.png"
foreach ($img in $images) {
    if ($img.Name -match "-(\d+)\.png$") {
        $dest = Join-Path $assetsDir ("knowledge_graph_" + $matches[1] + ".png")
        Copy-Item $img.FullName $dest -Force
    }
}

Get-ChildItem $assetsDir | Select-Object Name, Length
