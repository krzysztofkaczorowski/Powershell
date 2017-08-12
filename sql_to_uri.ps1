$db_name=''
$uri=''
$path_to_mdf=''
$path_to_ldf=''
$query_backup="BACKUP DATABASE AdventureWorks2014   
TO URL = 'https://qazxswedcvfrtgb.blob.core.windows.net/backupcontainer/AdventureWorks2014_ps_backup';  
GO "
Invoke-Sqlcmd -Query $query_backup


$query_restore="USE [master]
GO
ALTER DATABASE [AdventureWorks2014] SET  SINGLE_USER WITH ROLLBACK IMMEDIATE
GO
USE [master]
GO
EXEC master.dbo.sp_detach_db @dbname = N'AdventureWorks2014'
GO
RESTORE DATABASE AdventureWorks2014 FROM URL = 'https://qazxswedcvfrtgb.blob.core.windows.net/backupcontainer/AdventureWorks2014_ps_backup'
with
replace
GO"
Invoke-Sqlcmd -Query $query_restore 