# Bicep Container Registry Commands

## List Contents of a BCR

To list the contents of all the registry images and their tags:

``` bash
$registryName = 'yourRegistryName'
$modulePrefix = 'bicep/'
Write-Host "Scanning for repository tags in $registryName"
az acr repository list --name $registryName --query "[?contains(@, '${modulePrefix}')]" -o tsv | Foreach-Object { 
    $thisModule = $_
    az acr repository show-tags --name $registryName --repository $_ --output tsv  | Foreach-Object { 
      Write-Host "$thisModule`:$_"
    }
}
```

## Removing a BCR Entry

With these scripts, the entries are locked, so they are not easily removed. To remove a repository entry from the registry, you need to unlock it, then delete it:

``` bash
$registryName = 'yourRegistryName'
$repositoryEntry = 'bicep/sample3:2022-08-24.259'
az acr repository update --name $registryName --image $repositoryEntry --write-enabled true
az acr repository delete --name $registryName --image $repositoryEntry 
```

## Removing all BCR Entries in One Path

With these scripts, the entries are locked, so they are not easily removed. To remove a repository entry from the registry, you need to unlock them, then delete them:

``` bash
$registryName = 'yourRegistryName'
$repositoryEntry = 'bicep/sample3:2022-08-24.259'
Write-Host "Scanning for repository tags in $registryName"
az acr repository list --name $registryName --query "[?contains(@, '${modulePrefix}')]" -o tsv | Foreach-Object { 
  $thisModule = $_
  az acr repository show-tags --name $registryName --repository $_ --output tsv  | Foreach-Object { 
    $repositoryEntry = "$thisModule`:$_"
    Write-Host "Changing $repositoryEntry to write-enabled"
    az acr repository update --name $registryName --image $repositoryEntry --write-enabled true
  }
}

az acr repository list --name $registryName --query "[?contains(@, '${modulePrefix}')]" -o tsv | Foreach-Object { 
  $thisModule = $_
  az acr repository show-tags --name $registryName --repository $_ --output tsv  | Foreach-Object { 
    $repositoryEntry = "$thisModule`:$_"
    # When you delete one version, it will delete every other version also, 
    # so just look for one tag...
    if ($repositoryEntry.EndsWith(":LATEST")) {
      Write-Host "Starting delete of: $repositoryEntry"
      # add the --yes prompt if you want to skip the prompt and delete everything without asking
      az acr repository delete --name $registryName --image $repositoryEntry --yes
      #az acr repository delete --name $registryName --image $repositoryEntry
    }
  }
}

```
