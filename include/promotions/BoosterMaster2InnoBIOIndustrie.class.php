<?php
class BoosterMaster2InnoBIOIndustrie extends Booster {

    	
	public function __construct(){
		parent::__construct("g146447", array(
            "anglais" => "concerneMonGroupeAnglais"
            ));
	}
        
        protected function concerneMonGroupeAnglais(SimpleXMLElement $cours) {
            $remarque = strtolower(trim($cours->notes));
            $profs = array();
            foreach ($cours->resources->staff->item as $item) {
                $profs[] = (string) $item;
            }
            $matched = false;
            if ($this->issetGroup(self::$GROUPE_ANGLAIS)) {
                foreach ($this->groupes[self::$GROUPE_ANGLAIS] as $monGroupe) {
                    $monGroupe = strtolower(trim($monGroupe));
                    $monProf = (strpos($this->groupesStrings[self::$GROUPES_GENERAUX], "M2 INNO "));
                    $matched = ($matched OR ($monProf AND strpos($remarque, $monGroupe) !== false));
                }
            }
            else{
                // On les affiche tous
                $matched = true;
            }
            return $matched;
        }
}