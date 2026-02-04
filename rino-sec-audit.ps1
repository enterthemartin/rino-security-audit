<#
Windows Security Audit Toolkit
Autor: Martin Dessimoni
Version: 1.0
Descripcion: Auditoria basica de seguridad para Windows Server / Desktop
#>


Clear-Host


# ==============================
# CONFIGURACION
# ==============================
$AppName = "Windows Security Audit Toolkit"
$Version = "1.0"
$ReportPath = "$PSScriptRoot\\SecurityAuditReport_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"


# ==============================
# FUNCIONES UTILIDAD
# ==============================


function Write-Section {
param([string]$Title)


Add-Content $ReportPath "================================="
Add-Content $ReportPath " $Title"
Add-Content $ReportPath "================================="
}


function Write-Line {
param([string]$Text)


Add-Content $ReportPath $Text
}


function Pause {
Read-Host "Presione ENTER para continuar"
}


# ==============================
# AUDITORIAS
# ==============================


function Check-Firewall {
Write-Host "Revisando Firewall..." -ForegroundColor Cyan


Write-Section "FIREWALL"


Get-NetFirewallProfile | ForEach-Object {
Write-Line "Perfil: $($_.Name) | Habilitado: $($_.Enabled)"
}
}


function Check-OpenPorts {
Write-Host "Revisando puertos abiertos..." -ForegroundColor Cyan


Write-Section "PUERTOS ABIERTOS"


Get-NetTCPConnection -State Listen | Select-Object LocalAddress, LocalPort, OwningProcess | ForEach-Object {
$proc = Get-Process -Id $_.OwningProcess -ErrorAction SilentlyContinue
Write-Line "Puerto: $($_.LocalPort) | Proceso: $($proc.ProcessName)"
}
}


function Check-AdminUsers {
Write-Host "Revisando usuarios administradores..." -ForegroundColor Cyan


Write-Section "USUARIOS ADMIN"


Get-LocalGroupMember -Group "Administrators" | ForEach-Object {
Write-Line "Usuario: $($_.Name)"
}
}


function Check-WindowsUpdate {
Write-Host "Revisando estado de actualizaciones..." -ForegroundColor Cyan


Write-Section "WINDOWS UPDATE"


$service = Get-Service wuauserv -ErrorAction SilentlyContinue


if ($service) {
Write-Line "Servicio Windows Update: $($service.Status)"
} else {
Write-Line "Servicio Windows Update no encontrado"
}
}


function Check-RemoteAccess {
Write-Host "Revisando accesos remotos..." -ForegroundColor Cyan

