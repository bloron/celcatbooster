<?php

class BoosterEI5 extends Booster {

    public function __construct() {
        parent::__construct("g146422", array(
            "anglais" => "concerneMonGroupeAnglais",
            "espagnol" => "concerneMonGroupeEspagnol",
            "allemand" => "concerneMonGroupeAllemand"
        ));
    }

    protected function concerneMonGroupeAnglais(SimpleXMLElement $cours) {
        $remarque = strtolower(trim($cours->notes));
        $profs = array();
        if (is_array($cours->resources->staff->item))
        {
            foreach ($cours->resources->staff->item as $item) {
                array_push($profs, (string)$item);
            }
        }
        else
        {
            array_push($profs, (string)$cours->resources->staff->item);
        }
        
        $matched = false;
        if ($this->issetGroup(self::$GROUPE_ANGLAIS)) {
            foreach ($this->groupes[self::$GROUPE_ANGLAIS] as $monGroupe) {
                $monGroupe = strtolower(trim($monGroupe));
                $monProf = (strpos($this->groupesStrings[self::$GROUPES_GENERAUX], "AGI"));
                $monProf = $monProf || (strpos($this->groupesStrings[self::$GROUPES_GENERAUX], "QSF"));
                $monProf = $monProf || (strpos($this->groupesStrings[self::$GROUPES_GENERAUX], "INNO"));
                $matched = ($matched OR ($monProf AND strpos($remarque, $monGroupe) !== false));
            }
        }
        else{
            // On les affiche tous
            $matched = true;
        }
        return $matched;
    }

    /* Les EI5 actuels (2011-2012) ont Allemand et Espagnol en même temps */

    protected function concerneMonGroupeAllemand(SimpleXMLElement $cours) {
        return !$this->pasDeSecondeLangue();
    }

    protected function concerneMonGroupeEspagnol(SimpleXMLElement $cours) {
        return !$this->pasDeSecondeLangue();
    }
}
