<?php
class Fabrique {
	
	const PLANNING_EI1 = 1;
	const PLANNING_EI2 = 2;
	const PLANNING_EI3 = 3;
	const PLANNING_EI4 = 4;
	const PLANNING_EI5 = 5;
	const PLANNING_EI2_PASSMED = 6;
	
	private function __construct(){
	}
	
	public static function creeBooster($type) {
		$booster = null;
		switch($type){
			case self::PLANNING_EI1 : 			$booster = new Booster("nead.univ-angers.fr", "/celcat/istia/g2047"); break;
			case self::PLANNING_EI2 : 			$booster = new Booster("nead.univ-angers.fr", "/celcat/istia/g17238"); break;
			case self::PLANNING_EI3 : 			$booster = new Booster("nead.univ-angers.fr", "/celcat/istia/g2096"); break;
			case self::PLANNING_EI4 : 			$booster = new Booster("nead.univ-angers.fr", "/celcat/istia/g15807"); break;
			case self::PLANNING_EI5 : 			$booster = new Booster("nead.univ-angers.fr", "/celcat/istia/g29804"); break;
			case self::PLANNING_EI2_PASSMED : 	$booster = new Booster("nead.univ-angers.fr", "/celcat/istia/g33515"); break;
			default : break;
		}
		return $booster;
	}
}