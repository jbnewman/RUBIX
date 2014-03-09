<?php
class rubix {
	
	var $request;
	var $parts;
	var $module;
	var $view;
	var $site_root;
	var $plugin = array();
	var $loaded = array();
	var $js;
	var $css;
	
	public function __construct($request){
		
		#set the website
		$this->set_website();
		
		#set the site root
		$this->set_site_root();
		
		#set the request
		$this->set_request($request);
		
		#set the parts var
		$this->set_parts($this->request);
		
		#set the module
		$this->set_module($this->parts[0]);
		
		#set the view
		$this->set_view($this->parts[1]);
		
		#set the include
		$this->set_app_path();
	}
	
	private function set_site_root(){
		$path_parts = pathinfo($_SERVER['SCRIPT_NAME']);
		
		#determine if http or https
		if(isset($_SERVER['HTTPS'])){
			$http = 'https://';
		}else{
			$http = 'http://';
		}
		
		$string = $http.$_SERVER['SERVER_NAME'].$path_parts['dirname'];
		if(isset($_SESSION['website_url'])){
			//$string = $http.$_SESSION['website_url'].$path_parts['dirname'];;
		}
		$string = trim(stripslashes($string),'/');
		#set site root vars
		$this->site_root = $string.'/';
		define('SITE_ROOT',$this->site_root);
	}
	
	private function set_website(){
		$this->website = str_replace('www.','',$_SERVER['SERVER_NAME']);
		define('WEBSITE',$this->website);
	}
	
	private function set_request($request){
		
		#replace all non ascii characters
		$this->request = preg_replace('/[^(\x20-\x7F)]*/','', $request);
		#replace all . (sanitize for include)
		$this->request = str_replace('.','',$this->request);	
	}
	
	private function set_parts($request){
		
		#explode all the parts
		$this->parts = explode('/',$request);
		
		#verify parts is set correctly
		if(!is_array($this->parts) || count($this->parts) < 2){
			header("HTTP/1.0 404 Not Found");
			die();
		}
	}
	
	private function set_module($module){
		
		#remove all non alpha characters
		$module = preg_replace("/[^A-Za-z _]/", '', $module);
		$this->module = $module;
	}
	
	private function set_view($view){
		
		#remove all non alpha characters
		$view = preg_replace("/[^A-Za-z _]/", '', $view);
		$this->view = $view;
	}
	
	private function set_app_path(){
		
		#build the include path
		$overwrite = 'themes/'.$this->website.'/apps/'.$this->module.'/'.$this->view.'.q';
		$main = 'apps/'.$this->module.'/'.$this->view.'.q';
		if(is_file($overwrite)){
			$this->app_path = $overwrite;
		}elseif(is_file($main)){
			$this->app_path = $main;
		}else{
			header("HTTP/1.0 404 Not Found");
			die();
		}
		
	}
	
	public function set_template_path(){
		
		#build the include path
		$this->template_path = 'themes/'.$this->website.'/'.$this->template.'.q';
		if(!is_file($this->template_path)){
			header("HTTP/1.0 404 Not Found");
			die();
		}
	}
	
	//check if a plugin is loaded
	public function is_loaded($name){
		if(in_array($name, $this->loaded)){
			return true;
		}
		return false;
	}
	
	/*
	return the time the script has been running
	at the time this function is called
	This was built to help be useful when testing 
	if caching is a benifit and where a script might be stalling
	*/
	public function how_long(){
		$time = microtime(true) - RUBIX_APP_START;
		echo '<pre>We got here in '.number_format($time,3).' seconds using '.number_format((memory_get_usage()/(1024*1024)),3).'MB of memory!</pre>';
	}
	
	/*
	Why is the below a rubix function?
	doesn't seem like it should be, it doesn't improve core functionality
	i will delete this soon
	*/
	//are you a Vision AMP member?
	public function is_va(){
		
		//run multiple checks returning false by default
		return false;
		
	}
	
	
	
}
?>