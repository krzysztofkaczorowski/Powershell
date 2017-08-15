$db_name='AdventureWorks2014'
$url_to_bak_file_backup=('https://testsqldiag606.blob.core.windows.net/backupcontainer/' +($db_name.ToLower())+ '_backup_' + (get-date -Format yyyy_MM_dd_HHmmss) + '.bak')
$path_to_mdf_file
$path_to_ldf_file
$url_to_bak_file_restore='https://testsqldiag606.blob.core.windows.net/backupcontainer/' + 'adventureworks2014_backup_2017_16_15_141602.bak'

$params="db_name=$db_name","url_to_bak_file_backup=$url_to_bak_file_backup"#,"path_to_mdf=$path_to_mdf_file","path_to_ldf=$path_to_ldf_file"
$query_backup="BACKUP DATABASE `$(db_name)
TO URL = '`$(url_to_bak_file_backup)';  
GO "
Invoke-Sqlcmd -Query $query_backup -Variable $params

$params="db_name=$db_name","url_to_bak_file_restore=$url_to_bak_file_restore"
$query_restore="USE [master]
ALTER DATABASE [`$(db_name)] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
RESTORE DATABASE [`$(db_name)] FROM  URL = N'`$(url_to_bak_file_restore)' WITH  FILE = 1,
NOUNLOAD,  REPLACE,  STATS = 5
ALTER DATABASE [`$(db_name)] SET MULTI_USER
GO
"
Invoke-Sqlcmd -Query $query_restore -Variable $params