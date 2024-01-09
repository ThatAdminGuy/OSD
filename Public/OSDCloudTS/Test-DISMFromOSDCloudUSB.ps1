﻿Function Test-DISMFromOSDCloudUSB {

    $OSDCloudUSB = Get-Volume.usb | Where-Object {($_.FileSystemLabel -match 'OSDCloud') -or ($_.FileSystemLabel -match 'BHIMAGE')} | Select-Object -First 1
    $ComputerProduct = (Get-MyComputerProduct)
    $DriverPack = Get-OSDCloudDriverPack -Product $ComputerProduct
    $PackageID = $DriverPack.PackageID
    $ComputerManufacturer = (Get-MyComputerManufacturer -Brief)
    $DriverPathProduct = "$($OSDCloudUSB.DriveLetter):\OSDCloud\DriverPacks\DISM\$ComputerManufacturer\$ComputerProduct"
    $DriverPathPackageID = "$($OSDCloudUSB.DriveLetter):\OSDCloud\DriverPacks\DISM\$ComputerManufacturer\$PackageID"
    if (Test-Path $DriverPathProduct){Return $true}
    elseif (Test-Path $DriverPathPackageID){Return $true}
    else { Return $false}
}
