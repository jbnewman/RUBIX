<?php

class plugin {
	
	static function load($name){
		#rubix should be the only global variable we need
		global $RUBIX;
		$plug = array();
		if(!is_array($name)){
			$plug[] = $name;
		}else{
			$plug = $name;	
		}
		foreach($plug as $k => $value){
			$path = 'themes/'.WEBSITE.'/plugins/'.$value.'/load.q';
			if(!is_file($path)){
				$path = 'plugins/'.$value.'/load.q';
			}
			if(is_file($path) && !in_array($value,$RUBIX->loaded)){
				include $path;
			}
		}
	}
	
}

?>