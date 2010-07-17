<?php

class BoosterEI4 extends Booster{
	
	protected function concerneMonGroupeAnglais(SimpleXMLElement $cours){
		if(strpos(strtolower($cours->resources->module->item[0]), "anglais") !== false){
			if($this->groupesCorrespondent($this->groupesGeneraux, $cours->resources->group))
				return true;
		}
		return false;
	}
	
	protected function concerneMonGroupeAllemand(SimpleXMLElement $cours){
		if(strpos(strtolower($cours->resources->module->item[0]), "allemand") !== false){
			if($this->groupesCorrespondent($this->groupeAllemand, $cours->resources->group))
				return true;
		}
		return false;
	}
	
	protected function concerneMonGroupeEspagnol(SimpleXMLElement $cours){
		if(strpos(strtolower($cours->resources->module->item[0]), "espagnol") !== false){
//			echo "Esp : '$this->groupeEspagnol' dans ...";
			if($this->groupesCorrespondent($this->groupeEspagnol, $cours->resources->group))
				return true;
		}
		return false;
	}
}