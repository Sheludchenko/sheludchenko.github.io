Title: Add KeyVault certificate to VMSS 
Published: 02/26/2020
Tags:
    - Azure
    - KeyVault
    - VMSS
    - Certificate
---

    $KeyVaultName = "KeyVaultName"
    $CertificateName = "CertificateName"
    $VMSSName = "VMSSName"
    $VMSSResourceGroupName = "VMSSResourceGroupName"


    $KeyVault = Get-AzKeyVault -VaultName $KeyVaultName
    $KeyVaultCertificate = Get-AzKeyVaultCertificate -VaultName $KeyVaultName -Name $CertificateName
    $VMSS = Get-AzVmss -VMScaleSetName $VMSSName -ResourceGroupName $VMSSResourceGroupName

    $SourceVaultAlreadyExist = $false
    $CertificateAlreadyExist = $false

    $VMSS.VirtualMachineProfile.OsProfile.Secrets | % {
        if ($_.SourceVault.Id -eq $KeyVault.ResourceId) {
            $SourceVaultAlreadyExist = $true
            $SourceVaultId = $VMSS.VirtualMachineProfile.OsProfile.Secrets.IndexOf($_)

            $_.VaultCertificates | % {
                if ($_.CertificateUrl -eq $KeyVaultCertificate.SecretId) {
                    $CertificateAlreadyExist = $true
                }
            }

            if (!$CertificateAlreadyExist) {
                $Certificate = New-Object Microsoft.Azure.Management.Compute.Models.VaultCertificate
                $Certificate.CertificateStore = "My"
                $Certificate.CertificateUrl = $KeyVaultCertificate.SecretId
                $VMSS.VirtualMachineProfile.OsProfile.Secrets[$SourceVaultId].VaultCertificates.Add($Certificate)
            }
        }
    }

    if (!$SourceVaultAlreadyExist -and !$CertificateAlreadyExist) {
        $Secrets = New-Object System.Collections.Generic.List[Microsoft.Azure.Management.Compute.Models.VaultSecretGroup]
        $Secret = New-Object Microsoft.Azure.Management.Compute.Models.VaultSecretGroup
        $Secret.SourceVault = $KeyVault.ResourceId
        $Certificates = New-Object System.Collections.Generic.List[Microsoft.Azure.Management.Compute.Models.VaultCertificate]
        $Certificate = New-Object Microsoft.Azure.Management.Compute.Models.VaultCertificate
        $Certificate.CertificateStore = "My"
        $Certificate.CertificateUrl = $KeyVaultCertificate.SecretId
        $Certificates.Add($Certificate)
        $Secret.VaultCertificates = $Certificates
        $Secrets.Add($Secret)
        $VMSS.VirtualMachineProfile.OsProfile.Secrets = $Secrets
    }

    $VMSS.VirtualMachineProfile.OsProfile.Secrets | ConvertTo-Json -Depth 10
    $VMSS | Update-AzVmss
