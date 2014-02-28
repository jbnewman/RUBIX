<?php
/**
 * Start Sessions
 */
session_start();
define('RUBIX_APP_START', microtime(true));


/**
 * Set Timezone
 */
ini_set('date.timezone', date_default_timezone_get());


/**
 * Autoload class files
 */
function load_inc($name){
	if(defined('WEBSITE')){
		$overwrite 	= 'themes/'.WEBSITE.'/inc/'.$name.'.q';
	}
	if(defined('WEBSITE') && is_file($overwrite)){
		include $overwrite;
	}else{
		if(is_file('inc/'.$name.'.q')){
			include 'inc/'.$name.'.q';
		}
	}	
}
spl_autoload_register('load_inc');


/**
 * Initialize the RUBIX object
 */
if(!isset($_GET['request'])){
	$_GET['request'] = 'home/page';
}
$RUBIX = new rubix($_GET['request']);


/**
 * Try and include the config file
 */
if(is_file('themes/'.WEBSITE.'/config.q')){
	include 'themes/'.WEBSITE.'/config.q';
}


/**
 * Load the App
 */
ob_start();
include $RUBIX->app_path;
$RUBIX->app_html = ob_get_contents();
ob_end_clean();


/**
 * Load the template if needed
 */
if(isset($RUBIX->template)){
	ob_start();
	$RUBIX->set_template_path();
	include $RUBIX->template_path;
	$RUBIX->template_html = ob_get_contents();
	ob_end_clean();	 
	 
	echo $RUBIX->template_html;
}else{
	echo $RUBIX->app_html;
}
define('RUBIX_APP_END', microtime(true));
if(isset($RUBIX->are_we_there_yet)){
	$time = RUBIX_APP_END - RUBIX_APP_START;
	echo PHP_EOL.'<!-- We got there in '.number_format($time,3).' seconds using '.number_format((memory_get_usage()/(1024*1024)),3).'MB of memory! -->';
}

?>