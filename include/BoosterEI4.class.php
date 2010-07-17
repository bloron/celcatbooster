<?php

class BoosterEI4 extends Booster{
	
	protected function concerneMonGroupeAnglais(SimpleXMLElement $cours){
		if($this->estUnCoursAnglais($cours)){
			if($this->groupesCorrespondent($this->groupesGeneraux, $cours->resources->group))
				return true;
		}
		return false;
	}
	
	protected function concerneMonGroupeAllemand(SimpleXMLElement $cours){
		if($this->estUnCoursAllemand($cours)){
			if($this->groupesCorrespondent($this->groupeAllemand, $cours->resources->group))
				return true;
		}
		return false;
	}
	
	protected function concerneMonGroupeEspagnol(SimpleXMLElement $cours){
		if($this->estUnCoursEspagnol($cours)){
			if($this->groupesCorrespondent($this->groupeEspagnol, $cours->resources->group))
				return true;
		}
		return false;
	}
}