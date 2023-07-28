# Connect to Azure
Connect-AzAccount

# Select subscription
Set-AzContext -SubscriptionId '<SubscriptionId>'

# Resource group and DNS zone
$resourceGroup = '<ResourceGroupName>'
$dnsZone = '<DnsZoneName>'

# Get all record sets in the DNS zone
$recordSets = Get-AzDnsRecordSet -ZoneName $dnsZone -ResourceGroupName $resourceGroup

# Loop through each record set
foreach ($recordSet in $recordSets)
{
    # Check if it's not a CNAME or A record, or if the record set already has a TTL of 1 hour (3600 seconds)
    if (($recordSet.RecordType -eq 'CNAME' -or $recordSet.RecordType -eq 'A') -and $recordSet.Ttl -ne 3600)
    {
        Write-Host "Updating TTL for record set $($recordSet.Name) of type $($recordSet.RecordType)"
        
        # Update TTL to 1 hour
        $recordSet.Ttl = 3600

        # Save changes
        Set-AzDnsRecordSet -RecordSet $recordSet -Overwrite
    }
}
