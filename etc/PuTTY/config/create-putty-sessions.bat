0</*! ::
@echo off
cscript //nologo //e:javascript "%~f0" %*
goto :EOF
*/0;

var putty_file = '../putty.conf';
var sessions_file = 'sessions-list.txt';
var defaults_filename = '#default-settings';

// ========================================================================

var here_dir = WScript.ScriptFullName.replace(/[\\\/][^\\\/]+$/, '');
var putty_dir = here_dir.replace(/[\\\/][^\\\/]+$/, '');

var fso = new ActiveXObject('Scripting.FileSystemObject');

// ========================================================================

var putty_conf = get_file_content(here_dir + '/' + putty_file);

var m = putty_conf.match(/^\s*sessions\s*=\s*(.*?)\s*$/mi);
var sessions_dir = m ? m[1] : 'sessions';
if ( ! /^([A-Z]:)?[\\\/]/i.test(sessions_dir) ) {
	sessions_dir = putty_dir + '/' + sessions_dir;
}

var m = putty_conf.match(/^\s*sessionsuffix\s*=\s*(.*?)\s*$/mi);
var sessions_ext = m ? m[1] : '';

// ========================================================================

var defaults = get_file_content(sessions_dir + '/' + defaults_filename + sessions_ext);

var text = get_file_content(here_dir + '/' + sessions_file);
var hosts = text.replace(/^\s*(#.*)?$/gm, '').split(/[\r\n]+/);

for (var i = 0; i < hosts.length; i++) {
	var h = hosts[i].replace(/^\s+|\s+$/g, '').split(/[\r\n]+/);
	if ( h.length == 0 ) {
		continue;
	}
	var t = defaults.replace(/(HostName\\)([^\\]*)/, function($0, $1, $2) {
		return $1 + ( h[1] || h[0] );
	});
	put_file_content(sessions_dir + '/' + h[0] + sessions_ext, t);
}

// ========================================================================

function print(value) {
	WScript.StdOut.WriteLine(value);
}

function warn(value) {
	WScript.StdErr.WriteLine(value);
}

function die(value) {
	warn(value);
	exit(1);
}

function exit(exitCode) {
	WScript.Quit(exitCode || 0);
}

function getclip() {
	return new ActiveXObject('htmlfile').parentWindow.clipboardData.getData('Text');
}

function get_file_content(file) {
	print('Reading file: ' + file);

	var e;
	try {
		var fh = fso.OpenTextFile(file);
		var text = fh.ReadAll();
		fh.Close();
	} catch(e) {
		throw new Error(e.message + ': ' + file);
	}

	return text;
}

function put_file_content(file, text) {
	print('Writing file: ' + file);

	var e;
	try {
		var fh = fso.OpenTextFile(file, 2, true);
		fh.Write(text);
		fh.Close();
	} catch(e) {
		throw new Error(e.message + ': ' + file);
	}
}

// ========================================================================

// EOF
