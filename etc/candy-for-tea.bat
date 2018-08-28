<# :
@echo off
setlocal
set "POWERSHELL_BAT_ARGS=%*"
if defined POWERSHELL_BAT_ARGS set "POWERSHELL_BAT_ARGS=%POWERSHELL_BAT_ARGS:"=\"%"
endlocal & powershell -NoLogo -NoProfile -Command "$_ = $input; Invoke-Expression $( '$input = $_; $_ = \"\"; $args = @( &{ $args } %POWERSHELL_BAT_ARGS% );' + [String]::Join( [char]10, $( Get-Content \"%~f0\" ) ) )"
goto :EOF
#>

$packages = @(

	@{
		"name" = "7-zip";
		"home" = "http://7-zip.org/";
		"url" = "http://downloads.sourceforge.net/sevenzip/7za920.zip";
		"dir" = "7za";
		"postinstall" = {
			$dir = $args[0];
			$script:7zip_exe = "$dir\7za.exe";
		};
	}

	@{
		"name" = "ConEmu";
		"home" = "https://github.com/Maximus5/ConEmu/";
		"url" = "https://github.com/Maximus5/ConEmu/releases/download/v16.03.13/ConEmuPack.160313.7z";
		"dir" = "ConEmu";
	}

	@{
		"Skip" = $True;
		"name" = "ConsoleZ";
		"home" = "https://github.com/cbucher/console";
		# "url" = "https://github.com/cbucher/console/releases/download/1.16.0/ConsoleZ.x86.1.16.0.16038.zip";
		# "url" = "https://github.com/cbucher/console/releases/download/1.16.0/ConsoleZ.x64.1.16.0.16038.zip";
		# "url" = "https://github.com/cbucher/console/releases/download/1.18.0/ConsoleZ.x64.1.18.0.17048.zip";
		# "url" = "https://github.com/cbucher/console/releases/download/1.18.0/ConsoleZ.x86.1.18.0.17048.zip";
		"dir" = "ConsoleZ";
	}

	@{
		"name" = "Clink";
		"home" = "http://mridgers.github.io/clink";
		"url" = "https://github.com/mridgers/clink/releases/download/0.4.8/clink_0.4.8.zip";
		"dir" = "clink";
		"onlyFiles" = $True;
		"postinstall" = {
			$dir = $args[0];
			ls $dir | 
			? { $_.Attributes -eq "Directory" } | 
			% { rmdir -Force -Path "$dir\$_"; };
		};
	}

	@{
		"name" = "Far3";
		"home" = "http://www.farmanager.com/";
		"url" = "https://farmanager.com/files/Far30b5225.x86.20180604.7z";
		"dir" = "Far3";
	}

	@{
		"skip" = $True;
		"name" = "Far3bis";
		"home" = "http://code.google.com/p/conemu-maximus5/";
		"url" = "http://downloads.sourceforge.net/project/conemu/FarManager/Far3bis/far3.4254bis.x86.x64.7z";
		"dir" = "Far3bis";
	}

	@{
		"name" = "Notepad2-mod";
		"home" = "http://xhmikosr.github.io/notepad2-mod/";
		"url" = "https://github.com/XhmikosR/notepad2-mod/releases/download/4.2.25.985/Notepad2-mod.4.2.25.985_x86.zip";
		"dir" = "notepad2-mod";
		"postinstall" = {
			$dir = $args[0];
			$ini = "$dir\Notepad2.ini";
			mv -Force -Path "$ini" -Destination "$ini.orig";
			& {
				"[Notepad2]";
				"Notepad2.ini=..\..\etc\notepad\Notepad.ini";
			} | Out-File "$ini";
		};
	}

	@{
		"skip" = $True;
		"name" = "Notepad3";
		"home" = "https://www.rizonesoft.com/downloads/notepad3/";
		"url" = "https://github.com/rizonesoft/Notepad3/releases/download/RELEASE_4.18.512.992/Notepad3_4.18.512.992.zip";
		"dir" = "notepad";
		"postinstall" = {
			$dir = $args[0];
			$ini = "$dir\Notepad3.ini";
			mv -Force -Path "$ini" -Destination "$ini.orig";
			& {
				"[Notepad2]";
				"Notepad2.ini=..\..\etc\notepad\Notepad.ini";
			} | Out-File "$ini";
		};
	}

	@{
		"name" = "UnxUtils";
		"home" = "http://unxutils.sourceforge.met/";
		"url" = "http://downloads.sourceforge.net/project/unxutils/unxutils/current/UnxUtils.zip";
		"dir" = "unxutils";
		"postinstall" = {
			$dir = $args[0];
			$src = "$dir\usr\local\wbin\*";
			$dst = "$dir\bin";
			mv -Force -Path $src -Destination $dst;
		};
	}

	@{
		"name" = "UnxUtils Updates";
		"home" = "http://unxutils.sourceforge.met/";
		"url" = "http://unxutils.sourceforge.net/UnxUpdates.zip";
		"dir" = "unxutils\bin";
	}

);

# =========================================================================

$vendorsDir = [System.IO.Path]::GetFullPath("$pwd\..\vendors");
$distribDir = "$pwd\distrib";

$7zip_exe = "";

# =========================================================================

function download-archive( [string]$url, [string]$targetDir ) {
	$filename = "$targetDir\" + [System.IO.Path]::GetFileName($url);
	if ( ! ( Test-Path $filename ) ) {
		[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;
		$webclient = New-Object System.Net.WebClient;
		$webclient.DownloadFile($url, $filename);
	}
	return $filename;
}

function extract-zip( [string]$filename, [string]$targetDir ) {
	$shell = New-Object -com shell.application;
	$zip = $shell.NameSpace($filename);
	foreach ( $item in $zip.items() ) {
		$shell.Namespace($targetDir).CopyHere($item, 16);
	}
}

function extract-7z( [string]$filename, [string]$targetDir, [bool]$onlyFiles ) {
	$mode = if ( $onlyFiles ) { "e" } else { "x" };
	& "$script:7zip_exe" $mode "$filename" -y "-o$targetDir";
}

function extract-archive( [string]$filename, [string]$targetDir, [bool]$onlyFiles ) {
	if ( $script:7zip_exe ) {
		extract-7z $filename $targetDir $onlyFiles;
	} else {
		extract-zip $filename $targetDir;
	}
}

function install-package( $package ) {
	$dstDir = $script:vendorsDir + "\" + $package.dir;

	"=================================================================";
	"Package     : $($package.name)";
	"Destination : $dstDir";

	if ( $package.skip ) {
		"Skipped";
		return;
	}

	New-Item -Force -ItemType Directory -Path $dstDir >$null;
	$filename = download-archive $package.url $script:distribDir;
	extract-archive $filename $dstDir ( !! $package.onlyFiles );

	if ( ! $package.postinstall ) {
		return;
	}

	"`nInvoke command:";
	$package.postinstall;
	Invoke-Command -ScriptBlock $package.postinstall -ArgumentList $dstDir;
}

# =========================================================================

$enabled = "$pwd\candy-for-tea.enabled";
$logfile = "$pwd\candy-for-tea.log";

if ( ! ( Test-Path "$enabled" ) ) {
	[System.Reflection.Assembly]::LoadWithPartialName( "System.Windows.Forms" ) >$Null;
	[System.Windows.Forms.MessageBox]::Show( "To enable execution create the file:`n$enabled.", "Disabled", 0, "Stop" ) >$Null;
	exit;
}

$packages | % { install-package $_; } | Out-File $logfile;

if ( Test-Path $enabled ) {
	Remove-Item -Force -Path "$enabled";
}

# =========================================================================

# EOF
