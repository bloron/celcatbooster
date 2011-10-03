<?php
class BoosterEI5 extends Booster {
	
	public function __construct(){
		parent::__construct("nead.univ-angers.fr", "/celcat/istia/g29804");
	}
		
	protected function concerneMonGroupeAnglais(SimpleXMLElement $cours){
		if($this->estUnCoursAnglais($cours) && !$this->pasDeGroupeAnglais()){
			$remarque = strtolower(trim($cours->notes));
			$groupe = strtolower(trim($this->groupeAnglais));
			return strpos($remarque, $groupe) !== false;
		}
		return false;
	}

	protected function concerneMonGroupeAllemand(SimpleXMLElement $cours){
		if($this->estUnCoursAllemand($cours)){
			return !$this->pasDeSecondeLangue();
		}
		return false;
	}

	protected function concerneMonGroupeEspagnol(SimpleXMLElement $cours){
		if($this->estUnCoursEspagnol($cours)){
			return !$this->pasDeSecondeLangue();
		}
		return false;
	}
}
