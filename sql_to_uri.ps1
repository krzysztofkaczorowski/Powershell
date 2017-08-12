$params="db_name='AdventureWorks2014'","url='https://qazxswedcvfrtgb.blob.core.windows.net/backupcontainer/'","path_to_mdf=''","path_to_ldf=''"
$query_backup="BACKUP DATABASE `$(db_name)
TO URL = '`$(url)';  
GO "
Invoke-Sqlcmd -Query $query_backup -Variable $params


$query_restore="USE [master]
GO
ALTER DATABASE [`$(db_name)] SET  SINGLE_USER WITH ROLLBACK IMMEDIATE
GO
USE [master]
GO
EXEC master.dbo.sp_detach_db @dbname = N'`$(db_name)'
GO
RESTORE DATABASE `$(db_name) FROM URL = '`$(url)'
with
replace
GO"
Invoke-Sqlcmd -Query $query_restore -Variable $params