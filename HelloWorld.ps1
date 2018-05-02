Import-Module $PSScriptRoot\Functions.psm1

Get-PdfFieldNames -FilePath "$PSScriptRoot\Resources\sheet.pdf" -ITextLibraryPath "$PSScriptRoot\Resources\itextsharp.dll"