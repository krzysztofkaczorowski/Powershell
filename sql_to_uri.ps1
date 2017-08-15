$params="db_name='AdventureWorks2014'","url='https://qazxswedcvfrtgb.blob.core.windows.net/backupcontainer/'","path_to_mdf=''","path_to_ldf=''"
$query_backup="BACKUP DATABASE `$(db_name)
TO URL = '`$(url)';  
GO "
Invoke-Sqlcmd -Query $query_backup -Variable $params


$query_restore="USE [master]
ALTER DATABASE [AdventureWorks2014] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
RESTORE DATABASE [AdventureWorks2014] FROM  URL = N'https://testsqldiag606.blob.core.windows.net/backupcontainer/adventureworks2014_backup_2017_08_15_104335.bak' WITH  FILE = 1,
NOUNLOAD,  REPLACE,  STATS = 5
ALTER DATABASE [AdventureWorks2014] SET MULTI_USER
GO
"
Invoke-Sqlcmd -Query $query_restore -Variable $params