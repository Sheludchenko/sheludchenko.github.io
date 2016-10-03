	[CmdletBinding()]
	param(
	    [Parameter(Mandatory=$false)]
	    [string]$ResourceGroup,
	    [Parameter(Mandatory=$false)]
	    [string]$Location,
	    [Parameter(Mandatory=$false)]
	    [string]$VMName,
	    [Parameter(Mandatory=$false)]
	    [string]$VMSize,
	    [Parameter(Mandatory=$false)]
	    [string]$StorageAccountURI,
	    [Parameter(Mandatory=$false)]
	    [string]$SubscriptionName,
	    [Parameter(Mandatory=$false)]
	    [string]$VirtualNetworkName
	)
	
	Login-AzureRmAccount
	Set-AzureRmContext -SubscriptionName $SubscriptionName
	
	$Network = Get-AzureRmVirtualNetwork -Name $VirtualNetworkName `
	                                     -ResourceGroupName $ResourceGroup
	
	Try { 
	    $NetworkSecurityGroup = Get-AzureRmNetworkSecurityGroup `
	        -Name "$VMName-NetworkSecurityGroup" `
	        -ResourceGroupName $ResourceGroup `
	        -WarningAction Stop `
	        -ErrorAction Stop 
	}
	Catch { 
	    $NetworkSecurityGroup = New-AzureRmNetworkSecurityGroup `
	        -Name "$VMName-NetworkSecurityGroup" `
	        -ResourceGroupName $ResourceGroup `
	        -Location $Location 
	}
	
	Try { 
	    $PublicIp = Get-AzureRmPublicIpAddress `
	        -Name "$VMName-PublicNetworkInterface-01" `
	        -ResourceGroupName $ResourceGroup `
	        -WarningAction Stop `
	        -ErrorAction Stop 
	} 
	Catch { 
	    $PublicIp = New-AzureRmPublicIpAddress `
	        -Name "$VMName-PublicNetworkInterface-01" `
	        -ResourceGroupName $ResourceGroup `
	        -Location $Location `
	        -AllocationMethod Static 
	}
	
	Try { 
	    $Nic = Get-AzureRmNetworkInterface `
	        -Name "$VMName-PrivateNetworkInterface-01" `
	        -ResourceGroupName $ResourceGroup 
	} 
	Catch { 
	    $Nic =  New-AzureRmNetworkInterface `
	        -Name "$VMName-PrivateNetworkInterface-01" `
	        -ResourceGroupName $ResourceGroup `
	        -Location $Location `
	        -Subnet $Network.Subnets[0] `
	        -PublicIpAddress $PublicIp `
	        -NetworkSecurityGroup $NetworkSecurityGroup
	}
	
	$VMConfig = New-AzureRmVMConfig `
	                -VMName $VMName `
	                -VMSize $VMSize `
	                -Verbose | `
	            Add-AzureRmVMNetworkInterface -Id $Nic.Id | `
	            Set-AzureRmVMOSDisk `
	                -VhdUri $StorageAccountURI `
	                -Name "$($VMName)OSDisk" `
	                -CreateOption attach `
	                -Windows `
	                -Caching ReadWrite
	
	New-AzureRmVM -ResourceGroupName $ResourceGroup `
	              -Location $Location `
	              -VM $VMConfig `
	              -Verbose