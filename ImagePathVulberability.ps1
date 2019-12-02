$services = Get-ChildItem -path HKLM:\SYSTEM\CurrentControlSet\Services 

function fixPath([string]$path){
    $path = $path.trim()
    if($path.Contains(' ')){
        $path = '"' + $path + '"'
        Write-Host "Path corrected" $path
    }
    $path
}

function border(){
    Write-Host "================="
}

$services = $services | Where-Object -FilterScript { 

    $key = Get-Item $_.pspath 
    if($key.GetValueNames() -contains "ImagePath"){
        $_
    }

}

foreach($service in $services){

    border

    $imagePath = Get-ItemPropertyValue -path $service.pspath -Name ImagePath
    $processed = 0
    $fullPath = ""
    Write-Host "Original Path:" $imagePath
   
    #$path, $args = $imagePath.Split("(.*?)(-.*)")

    Select-String -Pattern '(.*? .*?)(-.+)' -InputObject $imagePath |
        Foreach-Object {
            $path, $args = $_.Matches[0].Groups[1..2].Value
            Write-Host "path:" $path
            $path = fixPath($path)
            $fullPath = $path + ' ' + $args
            $processed = 1
        }

        if(!$processed){
            $fullPath = fixPath($imagePath)
        }

        Write-Host 'The full path is: ' $fullPath

        border
}

#Get-WmiObject win32_service |select name, pathname



#$services | Where-Object -FilterScript { 

    #$key = Get-Item $_.pspath 
   # if($key.GetValueNames() -contains "ImagePath"){
  #      $_
 #   }

#}