Import-Module .\Functions.psm1

#region XAML assemblies
function Get-Homexaml{
Add-Type -AssemblyName PresentationFramework
[xml]$HomeXaml = Get-Content -Path "$PSScriptRoot\Views\PowerDM.xaml"
$Homexamlreader = New-Object System.Xml.XmlNodeReader $HomeXaml
$Global:Homewindow = [Windows.Markup.XamlReader]::Load($Homexamlreader)
Write-Verbose $Homewindow
}

function Get-CharWizard{
[xml]$CreateCharXaml = Get-Content -Path "$PSScriptRoot\Views\CreateChar.xaml"
$CreateCharXamlReader = New-Object System.Xml.XmlNodeReader $CreateCharXaml
$Global:CreateChar = [Windows.Markup.XamlReader]::Load($CreateCharXamlReader)
Write-Verbose $CreateChar
}

#endregion

Get-Homexaml
function Add-HomeControlVariables {
	New-Variable -Name 'btnNewChar' -Value $Homewindow.FindName('btnNewChar') -Scope 1 -Force
	New-Variable -Name 'btnnLoadChar' -Value $Homewindow.FindName('btnLoadChar') -Scope 1 -Force
}

Add-HomeControlVariables

$btnNewChar.add_Click({
	Get-CharWizard
	$CreateChar.ShowDialog()
})

$Homewindow.ShowDialog()