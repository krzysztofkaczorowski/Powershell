# adds an authenticated Azure account for use in the session   
Login-AzureRmAccount
$subscriptionName = 'Developer Program Benefit'
$resourceGroupName = 'test-sql'
$locationName = 'West Europe'
# set the tenant, subscription and environment for use in the rest of   
Set-AzureRmContext -SubscriptionName $subscriptionName   

<# create a new resource group - comment out this line to use an existing resource group  
New-AzureRmResourceGroup -Name $resourceGroupName -Location $locationName   

# Create a new ARM storage account - comment out this line to use an existing ARM storage account  
New-AzureRmStorageAccount -Name $storageAccountName -ResourceGroupName $resourceGroupName -Type Standard_RAGRS -Location $locationName   
#>
# Get the access keys for the ARM storage account  
$storageAccountName = (Get-AzureRmStorageAccount -ResourceGroupName $resourceGroupName).StorageAccountName
$accountKeys = Get-AzureRmStorageAccountKey -ResourceGroupName $resourceGroupName -Name $storageAccountName  

# Create a new storage account context using an ARM storage account  
$storageContext = New-AzureStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $accountKeys[0].Value
# Creates a new container in blob storage  
$container = Get-AzureStorageContainer -Context $storageContext -Name 'backupcontainer'
$cbc = $container.CloudBlobContainer  

# Sets up a Stored Access Policy and a Shared Access Signature for the new container  
$permissions = $cbc.GetPermissions();  
$policyName = 'Policy1' 
$policy = new-object 'Microsoft.WindowsAzure.Storage.Blob.SharedAccessBlobPolicy'  
$policy.SharedAccessStartTime = $(Get-Date).ToUniversalTime().AddMinutes(-5)  
$policy.SharedAccessExpiryTime = $(Get-Date).ToUniversalTime().AddYears(10)  
$policy.Permissions = "Read,Write,List,Delete"  
$permissions.SharedAccessPolicies.Add($policyName, $policy)  
$cbc.SetPermissions($permissions);  

# Gets the Shared Access Signature for the policy  
$policy = new-object 'Microsoft.WindowsAzure.Storage.Blob.SharedAccessBlobPolicy'  
$sas = $cbc.GetSharedAccessSignature($policy, $policyName)  
$sas_token = $sas.Substring(1)

$container_name = $container.Name
$link1="https://storageAccountName.blob.core.windows.net/$container_name"
$Params =@("link1=$link1","sas_token=$sas_token")
$query = "IF NOT EXISTS  
(SELECT * FROM sys.credentials   
WHERE name = `$(link1))
CREATE CREDENTIAL `$(link1) WITH IDENTITY = 'SHARED ACCESS SIGNATURE'  
,SECRET = `$(sas_token));"
Invoke-Sqlcmd -Query $query -Variable $Params -ServerInstance (HOSTNAME.EXE) -QueryTimeout 666


Get-AzureStorageBlob -Container $cbc.Name -Context $storageContext|sort LastModified|select Name