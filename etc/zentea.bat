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
			function postinstall( [string]$dir ) {
				$script:7zip_exe = "$dir\7za.exe";
			};
			postinstall $args[0];
		};
	}

	@{
		"name" = "ConEmu";
		"home" = "http://code.google.com/p/conemu-maximus5/";
		"url" = "http://downloads.sourceforge.net/project/conemu/Preview/ConEmuPack.141126.7z";
		"dir" = "ConEmu";
	}

	@{
		"name" = "Clink";
		"home" = "http://mridgers.github.io/clink";
		"url" = "https://github.com/mridgers/clink/releases/download/0.4.2/clink_0.4.2.zip";
		"dir" = "clink";
		"onlyFiles" = $True;
		"postinstall" = {
			function postinstall( [string]$dir ) {
				ls $dir | 
				? { $_.Attributes -eq "Directory" } | 
				% { rmdir -Force -Path "$dir\$_"; };
			};
			postinstall $args[0];
		};
	}

	@{
		"name" = "Far3";
		"home" = "http://www.farmanager.com/";
		"url" = "http://www.farmanager.com/files/Far30b4040.x86.20140810.7z";
		"dir" = "Far3";
	}

	@{
		"name" = "Notepad2-mod";
		"home" = "http://xhmikosr.github.io/notepad2-mod/";
		"url" = "https://github.com/XhmikosR/notepad2-mod/releases/download/4.2.25.935/Notepad2-mod.4.2.25.935_x86.zip";
		"dir" = "notepad2-mod";
		"postinstall" = {
			function postinstall( [string]$dir ) {
				$ini = "$dir\Notepad2.ini";
				mv -Force -Path "$ini" -Destination "$ini.orig";
				& {
					"[Notepad2]";
					"Notepad2.ini=..\..\etc\notepad2\Notepad2.ini";
				} | Out-File "$ini";
			};
			postinstall $args[0];
		};
	}

	@{
		"name" = "UnxUtils";
		"home" = "http://unxutils.sourceforge.met/";
		"url" = "http://downloads.sourceforge.net/project/unxutils/unxutils/current/UnxUtils.zip";
		"dir" = "x-unxutils";
		"postinstall" = {
			function postinstall( [string]$dir ) {
				$src = "$dir\usr\local\wbin\*";
				$dst = "$dir\bin";
				mv -Force -Path $src -Destination $dst;
			};
			postinstall $args[0];
		};
	}

	@{
		"name" = "UnxUtils Updates";
		"home" = "http://unxutils.sourceforge.met/";
		"url" = "http://unxutils.sourceforge.net/UnxUpdates.zip";
		"dir" = "x-unxutils\bin";
	}

);

# =========================================================================

$dstDir = [System.IO.Path]::GetFullPath("$pwd\..\vendors");
$tmpDir = $pwd;

$7zip_exe = "";

# =========================================================================

function download-archive( [string]$url, [string]$targetDir ) {
	$filename = "$targetDir\" + [System.IO.Path]::GetFileName($url);
	if ( ! ( Test-Path $filename ) ) {
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
	$dstDir = $script:dstDir + "\" + $package.dir;

@"

=======================================================================

Package: {0}
Destination: {1}

"@ -f $package.name, $dstDir;

	if ( $package.skip ) {
		"Skipped";
		return;
	}

	New-Item -Force -ItemType Directory -Path $dstDir >$null;
	$filename = download-archive $package.url $script:tmpDir;
	extract-archive $filename $dstDir ( !! $package.onlyFiles );

	if ( $package.postinstall ) {
		"`nInvoke command:";
		$package.postinstall;
		Invoke-Command -ScriptBlock $package.postinstall -ArgumentList $dstDir;
	}
}

# =========================================================================

$enabled = "$pwd\zentea.enabled";

if ( ! ( Test-Path "$enabled" ) ) {
	[System.Reflection.Assembly]::LoadWithPartialName( "System.Windows.Forms" );
	[System.Windows.Forms.MessageBox]::Show( "To enable execution create the file:`n$enabled.", "Disabled", 0, "Stop" );
	exit;
}

$packages | % { install-package $_; } | Out-File "$pwd\zentea.log";

Remove-Item -Force -Path "$enabled";

# =========================================================================

# EOF
