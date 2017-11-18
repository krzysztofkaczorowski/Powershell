Remove-Module Pester
Import-Module Pester
function InstallUpdtaes () {
    $date = Get-Date
    if($date.DayOfWeek -eq 'Tuesday' -and $date.Day -ge 7){
        Install-Package "\\wsus-server\updates\*"
    }
    else
    {
        return $false
    }
}


Describe 'Windows Update function'{
    Context 'Verify'{
        mock get-date {return $2nd_Tuesday= New-Object DateTime(2017,11,7)}
        mock Install-Package {return $true}
        it 'checks if computer won`t set on fire'{
            InstallUpdtaes|Should be $true
        }
    }
}