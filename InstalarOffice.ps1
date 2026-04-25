# ============================================================
#  INSTALADOR OFFICE - by Derik Oliveira
#  github.com/derikolis/Pacote-Office
#  Versao: 1.0.0
#  Licenca: MIT License
#  Copyright (c) 2026 Derik Oliveira
# ============================================================


# ============================================================
#  MENUS DE SELECAO
# ============================================================

function Escolher-Versao {

    Write-Host ""
    Write-Host "  Qual versao do Office deseja instalar?" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  [1] Office 2024" -ForegroundColor Yellow
    Write-Host "  [2] Office 2021" -ForegroundColor Yellow
    Write-Host "  [3] Office 2019" -ForegroundColor Yellow
    Write-Host ""

    do {
        $opcao = Read-Host "  Digite um numero"
    } while ($opcao -ne "1" -and $opcao -ne "2" -and $opcao -ne "3")

    switch ($opcao) {
        "1" { return "ProPlus2024Retail" }
        "2" { return "ProPlus2021Retail" }
        "3" { return "ProPlus2019Retail" }
    }
}

function Escolher-Arquitetura {

    Write-Host ""
    Write-Host "  Qual arquitetura deseja usar?" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  [1] 64-bit (Recomendado)" -ForegroundColor Yellow
    Write-Host "  [2] 32-bit"               -ForegroundColor Yellow
    Write-Host ""

    do {
        $opcao = Read-Host "  Digite um numero"
    } while ($opcao -ne "1" -and $opcao -ne "2")

    switch ($opcao) {
        "1" { return "64" }
        "2" { return "32" }
    }
}

function Escolher-Idioma {

    Write-Host ""
    Write-Host "  Qual idioma deseja usar?" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  [1] Portugues (Brasil)" -ForegroundColor Yellow
    Write-Host "  [2] Ingles"             -ForegroundColor Yellow
    Write-Host "  [3] Espanhol"           -ForegroundColor Yellow
    Write-Host ""

    do {
        $opcao = Read-Host "  Digite um numero"
    } while ($opcao -ne "1" -and $opcao -ne "2" -and $opcao -ne "3")

    switch ($opcao) {
        "1" { return "pt-br" }
        "2" { return "en-us" }
        "3" { return "es-es" }
    }
}

function Escolher-Canal {

    Write-Host ""
    Write-Host "  Qual canal de atualizacao deseja usar?" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  [1] Canal Atual (atualizacoes frequentes)" -ForegroundColor Yellow
    Write-Host "  [2] Canal Empresarial (mais estavel)"      -ForegroundColor Yellow
    Write-Host ""

    do {
        $opcao = Read-Host "  Digite um numero"
    } while ($opcao -ne "1" -and $opcao -ne "2")

    switch ($opcao) {
        "1" { return "Current"     }
        "2" { return "SemiAnnual"  }
    }
}


# ============================================================
#  GERACAO DO XML
# ============================================================

function Gerar-XML($versao, $arch, $idioma, $canal) {

    $xml = @"
<Configuration>
  <Add OfficeClientEdition="$arch" Channel="$canal">
    <Product ID="$versao">
      <Language ID="$idioma" />
    </Product>
  </Add>
  <Updates Enabled="TRUE" />
  <Display Level="Full" AcceptEULA="TRUE" />
</Configuration>
"@

    if (-not (Test-Path "C:\MSOfficeSetup")) {
        New-Item -ItemType Directory -Path "C:\MSOfficeSetup" | Out-Null
    }

    $xml | Out-File -FilePath "C:\MSOfficeSetup\Configuracao.xml" -Encoding UTF8

    Write-Host ""
    Write-Host "  Arquivo de configuracao salvo em:" -ForegroundColor Green
    Write-Host "  C:\MSOfficeSetup\Configuracao.xml"  -ForegroundColor White

    return $xml
}


# ============================================================
#  INSTALACAO
# ============================================================

function Iniciar-Instalacao {

    $pasta   = "C:\MSOfficeSetup"
    $odtUrl  = "https://download.microsoft.com/download/2/7/A/27AF1BE6-DD20-4CB4-B154-EBAB8A7D4A7E/officedeploymenttool_17531-20046.exe"
    $odtPath = "$pasta\ODTSetup.exe"

    Write-Host ""
    Write-Host "  Baixando Office Deployment Tool..." -ForegroundColor Yellow
    $wc = New-Object System.Net.WebClient
    $wc.DownloadFile($odtUrl, $odtPath)
    Write-Host "  Download concluido!"                -ForegroundColor Green

    Write-Host "  Extraindo arquivos..."              -ForegroundColor Yellow
    Start-Process -FilePath $odtPath -ArgumentList "/quiet /extract:`"$pasta`"" -Wait
    Write-Host "  Arquivos extraidos!"                -ForegroundColor Green

    Write-Host ""
    Write-Host "  Iniciando instalacao do Office..."          -ForegroundColor Yellow
    Write-Host "  Isso pode demorar de 10 a 30 minutos..."    -ForegroundColor Yellow
    Start-Process -FilePath "$pasta\setup.exe" -ArgumentList "/configure `"$pasta\Configuracao.xml`"" -Wait

    Write-Host ""
    Write-Host "  ============================================" -ForegroundColor Green
    Write-Host "   Instalacao concluida com sucesso!"          -ForegroundColor Green
    Write-Host "  ============================================" -ForegroundColor Green
    Write-Host ""
}


# ============================================================
#  EXECUCAO PRINCIPAL
# ============================================================

$versao = Escolher-Versao
$arch   = Escolher-Arquitetura
$idioma = Escolher-Idioma
$canal  = Escolher-Canal
$xml    = Gerar-XML $versao $arch $idioma $canal

Write-Host ""
Write-Host "  ============================================" -ForegroundColor Cyan
Write-Host "  Resumo da instalacao:"                        -ForegroundColor Cyan
Write-Host "  ============================================" -ForegroundColor Cyan
Write-Host "  Versao      : $versao"
Write-Host "  Arquitetura : $arch-bit"
Write-Host "  Idioma      : $idioma"
Write-Host "  Canal       : $canal"
Write-Host "  ============================================" -ForegroundColor Cyan
Write-Host ""

$confirmar = Read-Host "  Deseja iniciar a instalacao? (S/N)"

if ($confirmar -match "^[Ss]") {
    Iniciar-Instalacao
} else {
    Write-Host ""
    Write-Host "  Instalacao cancelada." -ForegroundColor Red
    Write-Host ""
}