<?php

class BoosterEI3 extends Booster{
	
	protected function concerneMesGroupesGeneraux(SimpleXMLElement $cours){
		if($this->estUnCoursDeLangue($cours))
			return false;
		if(strpos($cours->resources->module->item[0], "/MAN/") !== false)
			return false;
		if(!$this->contientDesGroupes($cours))
			return true;
		if($this->auMoinsUnAppartientAuGroupe($this->groupesGeneraux, $cours->resources->group))
			return true;
		return false;
	}
}