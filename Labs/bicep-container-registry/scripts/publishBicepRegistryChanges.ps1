# This script will scan your checkin for Bicep files and publish them to your container registry if they are new or updated
# Local Test: ./publishBicepRegistryChanges.ps1 -registryName "myRegistryName" -modulePrefix "bicep/" -sourceVersion "xxxxx" -buildId "999"

param(
    [Parameter(Mandatory = $true)] [string] $registryName,
    [Parameter(Mandatory = $true)] [string] $modulePrefix,
    [Parameter(Mandatory = $true)] [string] $sourceVersion,
    [Parameter(Mandatory = $true)] [string] $buildId,
    [Parameter(Mandatory = $true)] [string] $logFileName
)

Function PublishUpdatedBicepModules
{
  $moduleCount = 0
  $modulesAdded = 0
  $modulesUpdated = 0
  $version = (Get-Date -f 'yyyy-MM-dd') + ".$buildId"
  
  Write-Host "Publishing new and updated modules as version $version"
  Write-Host $modulePrefix
  Write-Host "Updating Registry: $registryName"
  Write-Host "Scanning for modulePrefix: $modulePrefix"
  Write-Host "SourceVersion: $sourceVersion"
  Write-Host "BuildId: $buildId"
  Write-Host "Tag Version: $version"

  Write-Host "-------------------------------------------------------------"
  Write-Host "List of modules currently in the registry:"
  Write-Host "-------------------------------------------------------------"
  Write-Host "az acr repository list --name $registryName --query ''[?contains(@, '$modulePrefix')]'' -o tsv"
  az acr repository list --name $registryName --query "[?contains(@, '$modulePrefix')]" -o tsv

  Write-Host "-------------------------------------------------------------"
  Write-Host "Searching for new modules to add..."
  Write-Host "-------------------------------------------------------------"
  $publishedModules = $(az acr repository list --name $registryName --query "[?contains(@, '$modulePrefix')]" -o tsv)
  Get-ChildItem -Recurse -Path ./bicep/*.bicep | Foreach-Object {
    $moduleCount += 1
    $filename = ($_ | Resolve-Path -Relative) -replace "^./" -replace '\..*'
    $lowerfilename = $filename.ToLower().replace("bicep/", "").replace("Bicep/", "").replace("modules/", "")
    Write-Host "-- Checking for existing registry entry: $lowerfileName"
    If (-not ($publishedModules ?? @()).Contains(("bicep/" + $lowerfilename))) {
      Write-Host "  *** $lowerfilename doesn't exist - adding version $version"
      Write-Output "ADD: $lowerfilename doesn't exist - adding version $version" >> $logfileName
      $modulesAdded += 1
      PublishOneBicepModule -registryName $registryName -filePath $_ -fileName $lowerfilename -version $version -image "bicep/$lowerfilename`:$version"
    }
  }

  Write-Host "-------------------------------------------------------------"
  Write-Host "Searching commit for existing modules to update for commit $sourceVersion..."
  Write-Host "-------------------------------------------------------------"
  git diff-tree --no-commit-id --name-only --diff-filter=ad -r -m $sourceVersion | Where-Object {$_.EndsWith('.bicep')} | Foreach-Object {
    $moduleName = ($_ | Resolve-Path -Relative) -replace "^./" -replace '\..*'
    If (-not ($moduleName ?? @()).Contains(('main.bicep'))) {
      $lowerfilename = $moduleName.ToLower().replace("bicep/", "").replace("modules/", "")
      Write-Host "-- Checking for existing registry entry: $lowerfileName"
      If (($publishedModules ?? @()).Contains("bicep/" + $lowerfilename)) {
        Write-Host "  *** Updating existing module $lowerfilename with version $version"
        Write-Output "UPDATE: $lowerfilename exists - updating to version $version" >> $logfileName
        $modulesUpdated += 1
        PublishOneBicepModule -registryName $registryName -filePath $_ -fileName $lowerfilename -version $version -image "bicep/$lowerfilename`:$version"
      }
    }
  }

  Write-Host "-------------------------------------------------------------"
  Write-Host "Total Modules in repository:   $moduleCount" 
  Write-Host "  Modules added to registry:   $modulesAdded"
  Write-Host "  Modules updated in registry: $modulesUpdated"
  Write-Output "-------------------------------------------------------------" >> $logfileName
  Write-Output "Total Modules in repository:   $moduleCount"  >> $logfileName
  Write-Output "  Modules added to registry:   $modulesAdded" >> $logfileName
  Write-Output "  Modules updated in registry: $modulesUpdated" >> $logfileName
}

Function PublishOneBicepModule
{
  param(
    [Parameter(Mandatory = $true)] [string] $registryName,
    [Parameter(Mandatory = $true)] [string] $filePath,
    [Parameter(Mandatory = $true)] [string] $fileName,
    [Parameter(Mandatory = $true)] [string] $version,
    [Parameter(Mandatory = $true)] [string] $image
  )
  Write-Host "    az bicep publish --file $filePath --target br:$registryName.azurecr.io/bicep/${fileName}:${version}"
  Write-Output "    az bicep publish --file $filePath --target br:$registryName.azurecr.io/bicep/${fileName}:${version}" >> $logfileName
  az bicep publish --file $filePath --target br:$registryName.azurecr.io/bicep/${fileName}:${version}

  # This acr import command is having problems... I need to figure out why this is failing...
  # If I run this locally, it succeeds...   is it a security issue...?
  #     az acr import --name <myRegistryName> --source <myRegistryName>.azurecr.io/bicep/computervision:2024-10-01.794 --image bicep/computervision:LATEST --force
  #       ERROR: Source cannot be found. Please provide a valid image and source registry or a fully qualified source.
  #Write-Host "    az acr import --name $registryName --source $registryName.azurecr.io/bicep/${fileName}:${version} --image bicep/${fileName}:LATEST --force"
  #az acr import --name $registryName --source $registryName.azurecr.io/bicep/${fileName}:${version} --image bicep/${fileName}:LATEST --force

  # This works, but if you do 2 PUBLISH commands, then the SHAs are different so that's not as good...
  Write-Host "    az bicep publish --file $filePath --target br:$registryName.azurecr.io/bicep/${fileName}:LATEST --force"
  Write-Output "    az bicep publish --file $filePath --target br:$registryName.azurecr.io/bicep/${fileName}:LATEST --force" >> $logfileName
  az bicep publish --file $filePath --target br:$registryName.azurecr.io/bicep/${fileName}:LATEST --force

  Write-Host "    Marking module $image as read-only"
  Write-Output "    Marking module $image as read-only" >> $logfileName
  Write-Host "    az acr repository update --name $registryName --image $image --write-enabled false"
  Write-Output "    az acr repository update --name $registryName --image $image --write-enabled false" >> $logfileName
  az acr repository update --name $registryName --image $image --write-enabled false
}

PublishUpdatedBicepModules
