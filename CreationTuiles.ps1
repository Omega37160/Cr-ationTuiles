Add-Type -AssemblyName System.Drawing

# --- Configuration ---
$sourceFile = "C:\temp\Fonds.png"
$outputBaseFolder = "C:\temp\CreationTiles"
$tileSize = 256 # Taille standard d'une tuile

# Création du dossier racine
if (-not (Test-Path $outputBaseFolder)) { New-Item -ItemType Directory -Path $outputBaseFolder }

# Charger l'image originale
$originalImg = [System.Drawing.Image]::FromFile($sourceFile)
$originalWidth = $originalImg.Width
$originalHeight = $originalImg.Height

Write-Host "Image chargée : $($originalWidth)x$($originalHeight)" -ForegroundColor Cyan

# --- Boucle sur les niveaux de zoom (0 à 5) ---
for ($zoom = 0; $zoom -le 5; $zoom++) {
    Write-Host "Traitement du niveau de zoom : $zoom..." -ForegroundColor Yellow
    
    # Calcul de la taille de l'image pour ce niveau de zoom
    # Au zoom 5 (max), on garde la taille originale. Au zoom 0, elle est très petite.
    $scale = [math]::Pow(2, $zoom - 5)
    $targetWidth = [int]($originalWidth * $scale)
    $targetHeight = [int]($originalHeight * $scale)
    
    # Redimensionnement de l'image pour le niveau actuel
    $canvas = New-Object System.Drawing.Bitmap($targetWidth, $targetHeight)
    $graphics = [System.Drawing.Graphics]::FromImage($canvas)
    $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $graphics.DrawImage($originalImg, 0, 0, $targetWidth, $targetHeight)
    
    # Nombre de tuiles en X et Y
    $tilesX = [math]::Ceiling($targetWidth / $tileSize)
    $tilesY = [math]::Ceiling($targetHeight / $tileSize)

    for ($y = 0; $y -lt $tilesY; $y++) {
        # Création du dossier pour l'axe Y (votre structure : \zoom\Y\Z.png)
        $yFolder = Join-Path $outputBaseFolder "$zoom\$y"
        if (-not (Test-Path $yFolder)) { New-Item -ItemType Directory -Path $yFolder -Force | Out-Null }

        for ($x = 0; $x -lt $tilesX; $x++) {
            # Calcul de la zone à découper
            $rectX = $x * $tileSize
            $rectY = $y * $tileSize
            $width = [math]::Min($tileSize, $targetWidth - $rectX)
            $height = [math]::Min($tileSize, $targetHeight - $rectY)

            $tileRect = New-Object System.Drawing.Rectangle($rectX, $rectY, $width, $height)
            $tileBitmap = $canvas.Clone($tileRect, $canvas.PixelFormat)
            
            # Sauvegarde de la tuile (nommée selon l'axe X dans votre logique, ici "Z")
            $tilePath = Join-Path $yFolder "$x.png"
            $tileBitmap.Save($tilePath, [System.Drawing.Imaging.ImageFormat]::Png)
            
            $tileBitmap.Dispose()
        }
    }
    $graphics.Dispose()
    $canvas.Dispose()
}

$originalImg.Dispose()
Write-Host "Terminé ! Les tuiles sont dans $outputBaseFolder" -ForegroundColor Green
