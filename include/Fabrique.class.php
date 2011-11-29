<?php
class Fabrique {
	
	const PLANNING_EI1 = 1;
	const PLANNING_EI2 = 2;
	const PLANNING_EI3 = 3;
	const PLANNING_EI4 = 4;
	const PLANNING_EI5 = 5;
	const PLANNING_EI2_PASSMED = 6;
	const PLANNING_MASTER_SDS = 7;
	
	private function __construct(){
	}
	
	public static function creeBooster($type) {
		$booster = null;
		switch($type){
			case self::PLANNING_EI1 : 			$booster = new BoosterEI1(); break;
			case self::PLANNING_EI2 : 			$booster = new BoosterEI2(); break;
			case self::PLANNING_EI3 : 			$booster = new BoosterEI3(); break;
			case self::PLANNING_EI4 : 			$booster = new BoosterEI4(); break;
			case self::PLANNING_EI2_PASSMED : 	$booster = new BoosterEI2Passmed(); break;
			case self::PLANNING_EI5 :		 	$booster = new BoosterEI5(); break;
			case self::PLANNING_MASTER_SDS :	$booster = new BoosterMasterSDS(); break;
			default : break;
		}
		return $booster;
	}
}
