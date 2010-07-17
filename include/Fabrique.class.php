<?php
class Fabrique {
	
	const PLANNING_EI1 = 1;
	const PLANNING_EI2 = 2;
	const PLANNING_EI3 = 3;
	const PLANNING_EI4 = 4;
	const PLANNING_EI5 = 5;
	
	private function __construct(){
	}
	
	public static function cree($type) {
		$booster = null;
		switch($type){
			case self::PLANNING_EI1 : 	$booster = new Booster("nead.univ-angers.fr", "/celcat/istia/g2047.xml"); break;
			case self::PLANNING_EI2 : 	$booster = new Booster("nead.univ-angers.fr", "/celcat/istia/g17238.xml"); break;
			case self::PLANNING_EI3 : 	$booster = new Booster("nead.univ-angers.fr", "/celcat/istia/g2096.xml"); break;
			case self::PLANNING_EI4 : 	$booster = new Booster("nead.univ-angers.fr", "/celcat/istia/g15807.xml"); break;
			case self::PLANNING_EI5 : 	$booster = new Booster("nead.univ-angers.fr", "/celcat/istia/g29804.xml"); break;
			default : break;
		}
		return $booster;
	}
}