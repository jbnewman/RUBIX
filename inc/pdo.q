<?php

class pdo {
	
	public function __construct($engine='mysql'){
		try {
			switch($engine){
				case 'mysql':
					$this->conn = new PDO('mysql:host='.MYSQL_HOST.';dbname='.MYSQL_DB, MYSQL_USER, MYSQL_PASS, array(
						PDO::ATTR_PERSISTENT => true
					));
				break;
				case 'sqlite':
					$this->conn = new PDO('sqlite:themes/'.WEBSITE.'/db/'.SQLITE_DB.'.q');
				break;
				case 'memory':
					$this->conn = new PDO('sqlite::memory');
				break;
				default:
					die('Unsupported Connection Engine: '.$engine);
				break;
			}
		}
		catch(PDOException $e){
			die($e->getMessage());
		}
	}
	
	public function query($query,$field_map=array()){
		try {
			if(count($field_map)>0){
				$this->prepare($query,$field_map);
			}else{
				$this->stmt = $this->conn->prepare($query);
				$this->stmt->execute();
			}
		}
		catch(PDOException $e){
			die($e->getMessage());
		}
	}
	
	public function get($query,$field_map=array()){
		if(count($field_map)>0){
			$this->prepare($query,$field_map);
		}else{
			$this->query($query);
		}
		$this->fetch();
		return $this->data;
	}
	
	public function prepare($query, $adata){
		
		try {
			$this->stmt = $this->conn->prepare($query);
			$this->stmt->execute($adata);
		}
		catch(PDOException $e){
			die($e->getMessage());
		}
	}
	
	public function last_id(){
		return $this->conn->lastInsertId();	
	}
	
	public function row_count(){
		return $this->stmt->rowCount();	
	}
	
	public function fetch(){
		$this->data = array();
		while($row = $this->stmt->fetch(PDO::FETCH_ASSOC)){
			$this->data[] = $row;		
		}
	}
	public function is_table($table){
		try{
        	$result = $this->conn->prepare('SELECT 1 FROM :table LIMIT 1',array(':table'=>$table));
		}catch (Exception $e) {
			return false;
		}
		return $result !== FALSE;	
	}
		
}
?>