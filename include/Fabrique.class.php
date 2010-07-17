<?php
class Fabrique {
	
	const PLANNING_EI3_MAN = 0;
	const PLANNING_EI3 = 1;
	const PLANNING_EI4 = 2;
	
	private function __construct(){
	}
	
	public static function cree($type) {
		$booster = null;
		switch($type){
			case self::PLANNING_EI3_MAN : $booster = new BoosterEI3_MAN("nead.univ-angers.fr", "/celcat/istia/g2096.xml"); break;
			case self::PLANNING_EI3 : 	$booster = new BoosterEI3("nead.univ-angers.fr", "/celcat/istia/g2096.xml"); break;
			case self::PLANNING_EI4 : 	$booster = new BoosterEI4("nead.univ-angers.fr", "/celcat/istia/g15807.xml"); break;
			default : echo "Type inconnu !"; break;
		}
		return $booster;
	}
}