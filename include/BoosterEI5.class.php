<?php
class BoosterEI5 extends Booster {
	
	public function __construct(){
		parent::__construct("nead.univ-angers.fr", "/celcat/istia/g29804", array(
			"anglais"	=> "concerneMonGroupeAnglais",
			"espagnol"	=> "concerneMonGroupeEspagnol",
			"allemand"	=> "concerneMonGroupeAllemand"
		));
	}
		
	protected function concerneMonGroupeAnglais(SimpleXMLElement $cours){
		$remarque = strtolower(trim($cours->notes));
		$matched = false;
		foreach($this->groupes[self::$GROUPE_ANGLAIS] as $monGroupe){
			$monGroupe = strtolower(trim($monGroupe));
			$matched = ($matched OR strpos($remarque, $monGroupe) !== false);
		}
		return $matched;
	}

	/* Les EI5 actuels (2011-2012) ont Allemand et Espagnol en même temps */
	protected function concerneMonGroupeAllemand(SimpleXMLElement $cours){
		return !$this->pasDeSecondeLangue();
	}

	protected function concerneMonGroupeEspagnol(SimpleXMLElement $cours){
		return !$this->pasDeSecondeLangue();
	}
}
