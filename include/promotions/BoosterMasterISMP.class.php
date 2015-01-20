<?php
class BoosterMasterISMP extends Booster {
	
	public function __construct(){
		parent::__construct("g146448", array(
			"anglais" => "concerneMonGroupeAnglais", 
			"communication" => "filterComm"
			));
	}

	protected function concerneMonGroupeAnglais(SimpleXMLElement $cours) {
		return $this->concerneMesGroupesGeneraux($cours);
	}

	protected function filterComm(SimpleXMLElement $cours){
		return $this->concerneMesGroupesGeneraux($cours);
	}

}
