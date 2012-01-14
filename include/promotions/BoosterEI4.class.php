<?php
class BoosterEI4 extends Booster {
	
	public function __construct(){
		parent::__construct("/celcat/istia/g15807", array(
			"communication"	=> "filterComm"
		));
	}

	protected function filterComm(SimpleXMLElement $cours){
		if($this->groupesCorrespondent($this->groupes['gpCom'], $cours->resources->group))
			return true;
		return false;
	}
}
