# OSD PowerShell Module

## Release Notes Start Date: 24.01.02

Note from Gary Blok (@gwblok) 

I know that OSDCloud has been around awhile, and has a ton of changes over the past couple years.  I'm starting this now so I can better keep track of changes I create, and other contributors.

Note, the changes I make won't go into effect until the next module release date, so if you see changes here, and the date is newer then the module date, then they haven't taken effect.

## Changes

### 24.2.7 (not yet implememnted)
- Fixes for when you call OSDCloudGUI via command line with preset variables.  This was not a use case I had tested for and had totally missed implementing all of the ground work for the recent functions added to OSDCloudGUIDev to work in this manner.
  - Thanks @PatrickThomasD2 for bringing this to my attention.
- Started basic code updates to support ARM64.  No plans to go "production" for a very long time.
  - Attempting to create the code requirements to have it create ARM64 WinPE with the OSDCloudTemplate functions

### 24.1.22 (implemented in OSD Module 24.2.4.1)
- Added Function: New-OSDCloudUSBSetupCompleteTemplate
  - This creates the Setup Complete files for you on your OSDCloudUSB drive (\OSDCloud\Config\Scripts\SetupComplete)
  - You can then modify the SetupComplete.ps1 file to match your needs, or leave alone and look at the logs later to see how it worked.
- Updated Start-OSDCloudGUIDev
  - Include the HP Tools
    - Using HPIA to Update Drivers, Firmware, Software, or All (During SetupComplete)
    - Update TPM (During Specialize)
    - Update BIOS (During WinPE)
  - Include SetupComplete commands
    - Windows Updates (No Drivers)
    - Windows Update (Drivers Only)
    - Windows Defender Updates
    - Apply Key from UEFI
      - This will attempt to lookup the Windows Code in UEFI and Apply to Windows
    - Setup Complete Shutdown
      - This will Shutdown the computer at the end of Setup Complete, leaving it at the OOBE the next time the device is turned on
  - Please Note, all of these are already available today via variables you can call before triggering OSDCloud.  This is just adding to the GUI Dev front end for testing, then eventually be promoted into the production front end (Start-OSDCloudGUI)

### 24.1.17 (implemented in OSD Module 24.2.4.1)
- Fixed issue in Save-FeatureUpdate function [Issue 106](https://github.com/OSDeploy/OSD/issues/106)
- Continue to deal with Intel's changing catalogs for WiFi drivers
  - Modifications to Get-IntelWirelessDriverPack to GUESS the correct URL
    - Thanks christiandekker for some ideas and code [Issue 101](https://github.com/OSDeploy/OSD/issues/101)
- Update to OSDCloudGUI (Start-OSDCLoudGUI)
  - Added support to show ESD files & SWM files in the drop down list to choose from [Issue 99](https://github.com/OSDeploy/OSD/issues/99) [Issue 85](https://github.com/OSDeploy/OSD/issues/85) 
  - promoted from DEV.  Was orginally in the 24.1.11.1 release (Start-OSDCLOUDGUIDev)

### 24.1.9 (implemented in OSD Module 24.1.11.1)
- Integrated Test-DISMFromOSDCloudUSB & Start-DISMFromOSDCloudUSB into the main OSDCloud Process
  - This will look at the OSDCloudUSB and if it detects the driverpack already expanded, proceeds to DISM the drivers into the Offline OS
    - OSDCloudUSB\OSDCloud\DriverPacks\DISM\$ComputerManufacturer\$PackageID
    - EX E:\OSDCloud\DriverPacks\DISM\HP\SP149133
    - OSDCloudUSB\OSDCloud\DriverPacks\DISM\$ComputerManufacturer\$ComputerProduct
    - EX E:\OSDCloud\DriverPacks\DISM\HP\8870
  - This allows you to pre-download driver packs and extract to those locations before running OSDCloud providing a few benifits
    - Saves time downloading driver pack over internet
    - Saves storage on device, as drivers are not copied over to C:\
    - Drivers are DISM in offline, so all drivers are present when the device reboots, reducing risk of missing storage / network
    - Allows you to choose specific drivers by placing in the "ComputerProduct" folder for specific models of PCs
- Dism log is copied from X:\Windows\Logs\DISM\dism.log to C:\OSDCloud\Logs\WinPE-DISM.log at the end of OSDCloud WinPE stage

### 24.1.3 (implemented in OSD Module 24.1.11.1)
- Added support for Split WIMS (.swm). [Issue 99](https://github.com/OSDeploy/OSD/issues/99)  
- Tested with MS Surface Book 2 MS Recovery Media
  - Download the Recovery Image, extract the swm files to OSDCloudUSB\OSDCloud\OS\%RecoveryImageName%
  - Example 
    - D:\OSDCloud\OS\SurfaceBook2_BMR_15_11.8.2\install.swm
    - D:\OSDCloud\OS\SurfaceBook2_BMR_15_11.8.2\install2.swm
    - D:\OSDCloud\OS\SurfaceBook2_BMR_15_11.8.2\install3.swm
  - use Start-OSDCloud -FindImageFile or Start-OSDCloudGUIDev

### 24.1.2 (implemented in OSD Module 24.1.3.1)
- Modified Intel Wireless Function [Get-IntelWirelessDriverPack] to use Intel's Driver and Support Assistant Catalog after previous method has been blocked by Intel, To resolve [Issue 101](https://github.com/OSDeploy/OSD/issues/101)
- Modified IntelWirelessDriverPack.json catalog with updated drivers, removed support for older OSes and 32bit
- Added support for custom ESD files on flash drive in OSDCloud\OS folder per Request [Issue 85](https://github.com/OSDeploy/OSD/issues/85)
  - They will show up in Start-OSDCloudGUIDev or use Variables
  - $Global:MyOSDCloud.ImageFileItem
  - $Global:MyOSDCloud.ImageFileName
  - $Global:MyOSDCloud.ImageFileFullName
  - See an example here: https://github.com/gwblok/garytown/blob/master/Dev/CloudScripts/SettingOSDCloudVarsSample.ps1
- Modifications to MS Catalog Driver Update Process
  - When using MS Updates for Drivers while in WinPE, it will check the OSDCloudUSB drive in \OSDCloud\MsUpCatDrivers and copy those local if needed.
  - You can enable the MS Update Catalog drivers to sync from C back to the USB Drive by setting a variable
    - SyncMSUpCatDriverUSB = [bool]$true
    - Note that default behavior as of now is disabled [$false] 
- SetupComplete Phase
  - OSDCloud by default creates SetupComplete.cmd & SetupComplete.ps1 to run addtional tasks during SetupComplete in C:\Windows\Setup\scripts
  - OSDCloud will look for OSDCloudUSB\OSDCloud\Config\Scripts\SetupComplete\SetupComplete.cmd.  If found, the contents of that entire folder are copied to C:\OSDCloud\Scripts\SetupComplete and OSDCloud will trigger your custom SetupComplete.cmd file at the end of it's own SetupComplete processes
  - Ability to Shutdown Computer at the end of SetupComplete Phase by setting variable [Issue 96](https://github.com/OSDeploy/OSD/issues/96)
    - ShutdownSetupComplete = [bool]$true 
- #### HP Enterprise Class device specific updates
  - These Updates happen in various phases
  - Update BIOS by setting Variable - WinPE Phase
    -  $Global:MyOSDCloud.HPBIOSUpdate
  - Update TPM by setting Variable - Specialize Phase
    - $Global:MyOSDCloud.HPTPMUpdate
  - Use HPIA by setting Variable - SetupComplete Phase
    - $Global:MyOSDCloud.HPIAALL | Runs HPIA in "All" mode (Software, Accesories, BIOS, Drivers, Firmware)
    - $Global:MyOSDCloud.HPIADrivers | Runs HPIA in "Drivers" mode (Drivers Only)
  - Created & Updated serveral HP Specific functions to support these options
    - For complete list of Functions run: Get-Command -Module "OSD" | Where-Object {$_.Name -match "-HP"}

### 23.12.1
- Moved ESD file references in catalog form using WSUS data to using Microsoft Creation Tool catalogs
- Catalog File: https://github.com/OSDeploy/OSD/blob/master/Catalogs/CloudOperatingSystems.json
- Process to create Catalog File: https://github.com/OSDeploy/OSD/blob/master/build/Build-OSDCloudOperatingSystemsv3.ps1