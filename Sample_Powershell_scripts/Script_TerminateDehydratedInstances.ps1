import-Module Microsoft.PowerShell.Management
$username = "Domain\UserName"  <#Please provide the service account credentials#>
$password = "ABC1236890"  <#Please provide the password#>
$password_base64 = ConvertTo-SecureString $password -AsPlainText -Force  
$creds = New-Object System.Management.Automation.PSCredential ($username, $password_base64)
<#Please provide your environment id in the id column below#>
$body_ExecuteServiceInstanceQuery='{
  "context":{
    "callerReference":"REST-SAMPLE",
    "environmentSettings":{
      "id":"3beb9328-c435-47ed-8c51-a406117e632b",
      "licenseEdition":0
    }
  },
  "query":{
    "compositeFilter":{
      "filterDescriptorCollection":[
        {
          "member":"Instance Status",
          "filterAvailableMember":[
            {
              "name":"Application",
              "alias":"Application Name",
              "dataType": 1,
              "isList":true,
              "isAutoComplete":false
            },
            {
              "name":"CreationTime",
              "alias":"Creation Time",
              "dataType":0,
              "isList":false,
              "isAutoComplete":false
            },
            {
              "name":"GroupResultsBy",
              "alias": "Group Results By",
              "dataType": 1,
              "isList": true,
              "isAutoComplete": false
            },
            {
              "name": "HostName",
              "alias": "Host Name",
              "dataType": 1,
              "isList": true,
              "isAutoComplete": false
            },
            {
              "name": "InstanceStatus",
              "alias": "Instance Status",
              "dataType": 1,
              "isList": true,
              "isAutoComplete": false
            },
            {
              "name": "ServiceClass",
              "alias": "Service Class",
              "dataType": 1,
              "isList": true,
              "isAutoComplete": false
            },
            {
              "name": "ServiceInstanceID",
              "alias": "Service Instance ID",
              "dataType": 1,
              "isList": false,
              "isAutoComplete": false
            },
            {
              "name": "ServiceName",
              "alias": "Service Name",
              "dataType": 1,
              "isList": true,
              "isAutoComplete": false
            },
            {
              "name": "ServiceTypeID",
              "alias": "ServiceType ID",
              "dataType": 1,
              "isList": false,
              "isAutoComplete": false
            }
          ],
          "memberType": 1,
          "filterOperator": 2,
          "value": "Dehydrated",
          "progressIndicator": false,
          "validationError": "",
          "isValid": true,
          "tempValue": ""
        }
      ]
    },
    "maxMatches": "10",
    "queryType": 0
  },
  "maxMatches": "10"
}'

$headers=@{"Content-Type"="application/json"}
$uri="http://BT360SUP03/BizTalk360/Services.REST/BizTalkQueryService.svc/ExecuteServiceInstanceQuery"  <#The URL needs to be modified as per your BizTalk360 URL#>
$response = Invoke-WebRequest -Uri $uri -Headers $headers -Method Post -Body $body_ExecuteServiceInstanceQuery -Credential $creds

$ExecuteServiceInstanceQueryobj = ConvertFrom-Json $response

if (!$ExecuteServiceInstanceQueryobj.serviceInstances) {write-Host "There are no dehydrated service instances for termination"}

<#Please provide your environment id in the id column below#>
foreach ($serviceinstance in $ExecuteServiceInstanceQueryobj.serviceInstances)
{
$body_ExecuteServiceInstanceOperation='{
  "context":{
    "callerReference":"REST-SAMPLE",
    "environmentSettings":{
      "id":"3beb9328-c435-47ed-8c51-a406117e632b",
      "licenseEdition":0
    }
  },
  "serviceInstances":[
  {
    "ServiceName": "'+$($serviceinstance.ServiceName)+'",
    "ServiceClass": "Orchestration",
      "StatusDisplayText": "Dehydrated",
      "Application":"'+$($serviceinstance.application)+'",
      "ServiceInstanceID":"'+$($serviceinstance.serviceInstanceID)+'"
      
  }
  ],
   "operation": 1
   }'

$headers1=@{"Content-Type"="application/json"}
$uri1="http://localhost/BizTalk360//Services.REST/BizTalkQueryService.svc/ExecuteServiceInstanceOperation"  <#The URL needs to be modified as per your BizTalk360 URL#>
$response1 = Invoke-WebRequest -Uri $uri1 -Headers $headers1 -Method Post -Body $body_ExecuteServiceInstanceOperation -Credential $creds

$ExecuteServiceInstanceQueryobj = ConvertFrom-Json $response

}





