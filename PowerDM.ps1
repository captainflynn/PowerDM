<#
	.NOTES
	===========================================================================
	 Created with: 	Visual Studio Code
	 Created on:   	1-5-2018 15:41
	 Created by:    Vincent Nuszbaum
	 Organization: 	Artemis Corp
	 Filename:     	PowerDM.PS1
	===========================================================================
	.DESCRIPTION
		The main code behind
#>

Import-Module .\Functions.psm1
Write-HOst "Test"
#region XAML initialization
<#
.DESCRIPTION
		Required for generating image location in XAML
#>
$FindString = '$Location$'
$inputFile = "$PSScriptRoot\Views\Source\PowerDMSource.xaml"
$outfile = "$PSScriptRoot\Views\PowerDM.xaml"
(Get-Content $inputFile) | ForEach-Object {$_.replace($findString,$PSScriptRoot)} | Out-File -FilePath $outfile

#endregion

#region XAML assemblies
<#
.DESCRIPTION
		Xaml Assemblies
#>
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

function Get-LoginScreen{
	[xml]$LoginXaml = Get-Content -Path "$PSScriptRoot\Views\Login.xaml"
	$LoginXamlReader = New-Object System.Xml.XmlNodeReader $LoginXaml
	$Global:LoginScreen = [Windows.Markup.XamlReader]::Load($LoginXamlReader)
	Write-Verbose $LoginScreen
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