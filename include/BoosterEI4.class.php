<?php
class BoosterEI4 extends Booster {
	
	public function __construct(){
		parent::__construct("nead.univ-angers.fr", "/celcat/istia/g15807");
	}

	protected function concerneUnGroupeParticulier(SimpleXMLElement $cours){
		if(strpos($cours->resources->module->item[0], "COMMUNICATION") !== false){
			if($this->groupesCorrespondent($this->groupes['gpCom'], $cours->resources->group))
				return true;
		}
		return false;
	}
}
