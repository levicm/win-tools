$shell = New-Object -ComObject Shell.Application; 
$shell.MinimizeAll(); 
Start-Sleep -Seconds 1; 
$shell.UndoMinimizeAll();
