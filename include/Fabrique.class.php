<?php

/**
 * Classe permettant de créer les objets Booster. 
 */
class Fabrique {
	
	const PLANNING_EI1 = 1;
	const PLANNING_EI2 = 2;
	const PLANNING_EI3 = 3;
	const PLANNING_EI4 = 4;
	const PLANNING_EI5 = 5;
	const PLANNING_EI2_PASSMED = 6;
	const PLANNING_MASTER_SDS = 7;
    const PLANNING_MASTER2_BIOINDUSTRIE = 8;
    const PLANNING_MASTER1_INNO = 9;
    
    // Formats de sortie de l'emploi du temps filtré
    private static $XML = "xml";
	private static $ICAL = "ical";
    
    // URL où se situent les ressources d'emploi du temps
    private static $SERVEUR_CELCAT = "celcat.univ-angers.fr";
	
	private function __construct(){
	}
	
    /**
     * Méthode static permettant de crééer une instance de bosster à partir d'un type (entier).
     * @param int $type
     * @return Une instance de Booster
     */
	public static function creeBooster($type) {
		$booster = null;
        // Selon le type choisi, on instancie un booster différent possédant ses propres règles spécifiques
		switch($type){
			case self::PLANNING_EI1 : 			$booster = new BoosterEI1(); break;
			case self::PLANNING_EI2 : 			$booster = new BoosterEI2(); break;
			case self::PLANNING_EI3 : 			$booster = new BoosterEI3(); break;
			case self::PLANNING_EI4 : 			$booster = new BoosterEI4(); break;
			case self::PLANNING_EI2_PASSMED : 	$booster = new BoosterEI2Passmed(); break;
			case self::PLANNING_EI5 :		 	$booster = new BoosterEI5(); break;
			case self::PLANNING_MASTER_SDS :	$booster = new BoosterMasterSDS(); break;
                        case self::PLANNING_MASTER2_BIOINDUSTRIE :	$booster = new BoosterMaster2InnoBIOIndustrie(); break;
                        case self::PLANNING_MASTER1_INNO :	$booster = new BoosterMaster1Inno(); break;
			default : break;
		}
        // On va chercher le contenu XML de l'emploi du temps disponible sur le web
        $xmlData = self::getFile("/istia/" . $booster->getResource() . ".xml");
        $booster->setSourceXML($xmlData);
		return $booster;
	}
    
    /**
     * Crée un formatter (objet qui va manipuler le résultat XML filtré et créer le résultat sous la forme voulue : XML ou ICS).
     * Cette méthode n'est pas terrible, elle devrait être fusionnée avec creeBooster().
     */
    public static function creeFormatter($type, Booster $booster) {
		$formatter = null;
		switch($type){
            case self::$ICAL :
                $icsData = self::getFile("/istia/" . $booster->getResource() . ".ics");
                $formatter = new ICal($icsData); break;
            case self::$XML :
			default : 
                $formatter = new XMLCal();
                break;
		}
		return $formatter;
	}
    
    /**
     * Méthode permettant de récupérer un contenu texte sur le le web.
     */
    private static function getFile($resourceName) {
        return HttpResource::getFichierDistant(self::$SERVEUR_CELCAT, $resourceName);
    }
}
