<?php
class BoosterEI4 extends Booster {
	
	public function __construct(){
		parent::__construct("g146386",array(
			"communication" => "filterComm",
			"droit du travail" => "filterComm"));
	}

	protected function filterComm(SimpleXMLElement $cours){
		if (isset($this->groupes['gpCom']))
		{
			if(($this->groupesCorrespondent($this->groupes['gpCom'], $cours->resources->group)))
				return true;
			else
				return false;
		}

	}



}
