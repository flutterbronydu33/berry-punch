<?php
header('Content-Type: text/plain; charset=utf8');
$handle = popen('grep "$(date +%Y-%m-%d)" /home/berry-punch/logs/ChannelLogger/freenode/#bronycub/#bronycub.log 2>&1|sort -nr', 'r');

while (!feof($handle)) {
	$buffer = substr(fgets($handle),11);
	# $buffer = preg_replace(array('/</', '/>/', "/\n/"), array('&lt;','&gt;', "<br />\n"), $buffer);
	$buffer = str_replace(array('has joined #bronycub', 'has left #bronycub', 'has quit IRC'), array('est entré sur le canal', 'est parti du canal', 's\'est déconnecté'), $buffer);
	echo "$buffer";
	ob_flush();
	flush();
}
pclose($handle);