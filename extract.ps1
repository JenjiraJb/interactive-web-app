Add-Type -AssemblyName System.IO.Compression.FileSystem

$docx = (Get-ChildItem -Filter *.docx | Select-Object -First 1).FullName
Write-Host "Reading file: $docx"

$zip = [System.IO.Compression.ZipFile]::OpenRead($docx)
$entry = $zip.GetEntry('word/document.xml')
$stream = $entry.Open()
$reader = New-Object System.IO.StreamReader($stream, [System.Text.Encoding]::UTF8)
$xmlText = $reader.ReadToEnd()
$reader.Close()
$zip.Dispose()

[xml]$doc = $xmlText
$nsManager = New-Object System.Xml.XmlNamespaceManager($doc.NameTable)
$nsManager.AddNamespace('w', 'http://schemas.openxmlformats.org/wordprocessingml/2006/main')

$paragraphs = $doc.SelectNodes('//w:p', $nsManager)
$lines = @()
foreach ($p in $paragraphs) {
    $nodes = $p.SelectNodes('.//w:t', $nsManager)
    if ($nodes -and $nodes.Count -gt 0) {
        $text = ($nodes | ForEach-Object { $_.InnerText }) -join ''
        if ($text.Trim() -ne '') {
            $lines += $text
        }
    }
}

$lines | Out-File -FilePath 'extracted_doc.txt' -Encoding utf8
Write-Host "Successfully extracted $($lines.Count) lines to extracted_doc.txt"
