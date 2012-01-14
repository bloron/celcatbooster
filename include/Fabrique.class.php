<?php
class Fabrique {
	
	const PLANNING_EI1 = 1;
	const PLANNING_EI2 = 2;
	const PLANNING_EI3 = 3;
	const PLANNING_EI4 = 4;
	const PLANNING_EI5 = 5;
	const PLANNING_EI2_PASSMED = 6;
	const PLANNING_MASTER_SDS = 7;
    
    private static $XML = "xml";
	private static $ICAL = "ical";
    
    private static $SERVEUR_CELCAT = "nead.univ-angers.fr";
	
	private function __construct(){
	}
	
	public static function creeBooster($type) {
		$booster = null;
		switch($type){
			case self::PLANNING_EI1 : 			$booster = new BoosterEI1(grehg); break;
			case self::PLANNING_EI2 : 			$booster = new BoosterEI2(); break;
			case self::PLANNING_EI3 : 			$booster = new BoosterEI3(); break;
			case self::PLANNING_EI4 : 			$booster = new BoosterEI4(); break;
			case self::PLANNING_EI2_PASSMED : 	$booster = new BoosterEI2Passmed(); break;
			case self::PLANNING_EI5 :		 	$booster = new BoosterEI5(); break;
			case self::PLANNING_MASTER_SDS :	$booster = new BoosterMasterSDS(); break;
			default : break;
		}
        $xmlData = self::getFile($booster->getResource() . ".xml");
        $booster->setSourceXML($xmlData);
		return $booster;
	}
    
    public static function creeFormatter($type, Booster $booster) {
		$formatter = null;
		switch($type){
            case self::$ICAL :
                $icsData = self::getFile($booster->getResource() . "_utf8.ics");
                $formatter = new ICal($icsData); break;
            case self::$XML :
			default : 
                $formatter = new XMLCal();
                break;
		}
		return $formatter;
	}
    
    private static function getFile($resourceName) {
        return HttpResource::getFichierDistant(self::$SERVEUR_CELCAT, $resourceName);
    }
}
