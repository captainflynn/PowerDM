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
Add-Type -AssemblyName PresentationFramework
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
function Get-Homexaml{
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

function Get-LoadChar{
[xml]$LoadCharXaml = Get-Content -Path "$PSScriptRoot\Views\LoadChar.xaml"
$LoadCharXamlReader = New-Object System.Xml.XmlNodeReader $LoadCharXaml
$Global:LoadChar = [Windows.Markup.XamlReader]::Load($LoadCharXamlReader)
Write-Verbose $LoadChar
}

function Get-CharacterSheet{
	[xml]$CharacterSheetXaml = Get-Content -Path "$PSScriptRoot\Views\CharacterSheet.xaml"
	$CharacterSheetXamlReader = New-Object System.Xml.XmlNodeReader $CharacterSheetXaml
	$Global:CharacterSheet = [Windows.Markup.XamlReader]::Load($CharacterSheetXamlReader)
	Write-Verbose $CharacterSheet
	}

#endregion

#region XAML Control Variables
function Add-HomeControlVariables {
	New-Variable -Name 'btnNewChar' -Value $Homewindow.FindName('btnNewChar') -Scope 1 -Force
	New-Variable -Name 'btnLoadChar' -Value $Homewindow.FindName('btnLoadChar') -Scope 1 -Force
}

function Add-LoginControlVariables {
	New-Variable -Name 'txtUsername' -Value $LoginScreen.FindName('txtUsername') -Scope 1 -Force
	New-Variable -Name 'txtPassword' -Value $LoginScreen.FindName('txtPassword') -Scope 1 -Force
	New-Variable -Name 'btnLogin' -Value $LoginScreen.FindName('btnLogin') -Scope 1 -Force
}

function Add-LoadCharControlVariables {
	New-Variable -Name 'gridCharView' -Value $LoadChar.FindName('gridCharView') -Scope 1 -Force
	New-Variable -Name 'btnLoadCharPro' -Value $LoadChar.FindName('btnLoadCharPro') -Scope 1 -Force
	New-Variable -Name 'btnCloseLoad' -Value $LoadChar.FindName('btnCloseLoad') -Scope 1 -Force
}

function Add-CharacterSheetControlVariables {
	New-Variable -Name 'txtName' -Value $LoadChar.FindName('txtName') -Scope 1 -Force
}
#endregion

$characters = Import-Csv -LiteralPath "$PSScriptRoot\Resources\characters.csv" -Delimiter ";"

Get-LoginScreen
Get-Homexaml
Get-CharWizard
Get-LoadChar
Get-CharacterSheet
Add-HomeControlVariables
Add-LoginControlVariables
Add-LoadCharControlVariables
Add-CharacterSheetControlVariables

$btnLogin.add_Click({
	$usertest = $txtUsername.Text
	$passtest = $txtPassword.Password
	if ($usertest -eq "vincent" -and $passtest -eq "test")
	{
		$LoginScreen.Visibility = "Hidden"
		$Homewindow.ShowDialog()
	}
})

$btnNewChar.add_Click({
	Get-CharWizard
	$CreateChar.ShowDialog()
})

$btnLoadChar.add_Click({
	Get-LoadChar
	Add-LoadCharControlVariables
	$gridCharView.ItemsSource = @($characters)
	$LoadChar.ShowDialog()
})

$btnLoadCharPro.add_Click({
	return $gridCharView.SelectedItems
})

$LoginScreen.ShowDialog()