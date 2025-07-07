<powershell>
# Set preference to silently continue
$progressPreference = 'silentlyContinue'

# Update SSM Agent
$dir = $env:TEMP + "\ssm"
New-Item -ItemType directory -Path $dir -Force
cd $dir
(New-Object System.Net.WebClient).DownloadFile("https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/windows_amd64/AmazonSSMAgentSetup.exe", $dir + "\AmazonSSMAgentSetup.exe")
Start-Process .\AmazonSSMAgentSetup.exe -ArgumentList @("/q", "/log", "install.log") -Wait

# Import the ECSTools module
Import-Module ECSTools

# Set environment variables for ECS
[Environment]::SetEnvironmentVariable("ECS_CLUSTER", "${cluster_name}", "Machine")
[Environment]::SetEnvironmentVariable("ECS_ENABLE_AWSLOGS_EXECUTIONROLE_OVERRIDE", "true", "Machine")
[Environment]::SetEnvironmentVariable("ECS_ENABLE_TASK_ENI", "true", "Machine")
[Environment]::SetEnvironmentVariable("ECS_AVAILABLE_LOGGING_DRIVERS", '["json-file","awslogs"]', "Machine")
[Environment]::SetEnvironmentVariable("ECS_ENABLE_TASK_IAM_ROLE", "true", "Machine")

# Initialize the ECS agent with specific parameters
Initialize-ECSAgent -Cluster ${cluster_name} -EnableTaskIAMRole -EnableTaskENI -AwsvpcBlockIMDS
</powershell>