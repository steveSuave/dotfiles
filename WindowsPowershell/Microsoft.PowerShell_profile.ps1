# $oldpath = (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).path
# $newpath = "$oldpath;c:\path\to\folder"
# Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH -Value $newPath
#
# ($env:path).split(";")

$env:path += ";D:\emacs\bin"
$env:path += ";C:\Program Files (x86)\Vim\vim81"

sal less "C:\Program Files\Git\usr\bin\less.exe"
sal vi gvim

function sh {
    bash.exe -c "$($args)"
}

function sonar {
    cd "$($args)"
	maven sonar:sonar -Dsonar.analysis.mode=preview -Dsonar.issuesReport.console.enable=true -Dsonar.issuesReport.html.enable=true
}

function glog {
 cat C:\glassfish3\glassfish\domains\domain1\logs\server.log -wait
}

