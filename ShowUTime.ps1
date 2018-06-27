#Requires –Version 3
#Author GhostSnow
#若系统禁止执行PS脚本，请以管理员权限在PS中执行:set-ExecutionPolicy RemoteSigned 设置 Y

#region
$logFile = 'papa.txt'
Start-Transcript $logFile -Append -Force
echo `n `n`n `n"脚本正在执行，请稍后..."

<#创建文件
#new-item -Path ./papa.txt -type file -force
#>

echo `n `n-------计算机名称--------

#计算机名称
Get-WmiObject -Class Win32_ComputerSystem 
echo -------ip地址、mac-------- 

#ip地址、mac
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=TRUE -ComputerName . | Format-Table -Property IPAddress 
 
echo -------当前登陆用户--------  

#当前登陆用户
Get-WmiObject -Class Win32_ComputerSystem | Select-object -ExpandProperty UserName

echo `n `n-------系统账户信息-------- 
#计算机账户信息
Get-WmiObject -Class Win32_UserAccount  #所有账户
sleep -Milliseconds 500
echo `n `n-------系统端口连接信息--------  

#获取端口情况（可获取pid）
netstat -ano
sleep -Milliseconds 300
echo `n `n-------系统正在运行的进程--------

#获取正在运行的进程
Get-Process
sleep -Milliseconds 300
echo `n `n-------系统正在运行的服务--------

#获取正在运行的服务
Get-Service
sleep -Milliseconds 300

<#
#根据pid查看所属进程进程
tasklist | findstr 'pid'

#获取进程所有者
$ProcessName = 'explorer.exe'
(Get-WmiObject –Query "select * from Win32_Process where name='$ProcessName'").GetOwner().User 
#>

echo `n `n-------本地路由表信息--------  
netstat -r 

echo `n `n-------本地ARP表信息--------  
arp -a 

echo `n `n-------计算机注册表（关键位置）--------  
#获取计算机注册表（关键位置）
Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run  #自启动 
Get-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Run  #当前登陆用户的自启动 

echo `n `n-------已安装的补丁列表--------  
#获取已安装的补丁列表
Get-WmiObject -Class Win32_QuickFixEngineering -ComputerName . 

echo `n `n-------已安装的应用列表--------  
#获取应用列表
Get-WmiObject -Class Win32_Product -ComputerName . | Format-Wide -Column 1 

echo `n `n-------系统本地磁盘信息--------  
#获取计算机磁盘信息
Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType=3" -ComputerName . 
sleep -Milliseconds 200
<#
echo -------计算机关键日志（日志日期需要手动设定）need UAC--------  
#获取计算机日志（登陆日志、安全日志）
get-eventlog -log Security -After "2018-6-27"   #提取日志日期需要手动设定 
#>
write-output `n `n-------系统隐藏文件--------

#显示系统隐藏文件(windows and system32)
Get-ChildItem C:\Windows -Attributes h
sleep -Milliseconds 200
Get-ChildItem C:\Windows\system32 -Attributes h
sleep -Milliseconds 200

write-output `n `n-------系统开机启动程序--------

#获取计算机开机启动程序 
Get-WmiObject -Class Win32_StartupCommand | Sort-Object -Property Caption | Format-Table -Property Caption, Command, User -AutoSize
sleep -Milliseconds 200
Stop-Transcript
#endregion
