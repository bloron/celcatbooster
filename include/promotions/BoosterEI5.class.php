<?php

class BoosterEI5 extends Booster {

    public function __construct() {
        parent::__construct("g29804", array(
            "anglais" => "concerneMonGroupeAnglais",
            "espagnol" => "concerneMonGroupeEspagnol",
            "allemand" => "concerneMonGroupeAllemand"
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
                $monProf = (in_array("FERRIER,Catherine", $profs) && strpos($this->groupesStrings[self::$GROUPES_GENERAUX], "AGI"));
                $monProf = $monProf ||
                        (in_array("REVERDY,Valerie", $profs) && strpos($this->groupesStrings[self::$GROUPES_GENERAUX], "QSF"));
                $matched = ($matched OR ($monProf AND strpos($remarque, $monGroupe) !== false));
            }
        }
        else{
            // On les affiche tous
            $matched = true;
        }
        return $matched OR $this->groupesCorrespondent("EI5 AGI", $cours->resources->group);
    }

    /* Les EI5 actuels (2011-2012) ont Allemand et Espagnol en même temps */

    protected function concerneMonGroupeAllemand(SimpleXMLElement $cours) {
        return !$this->pasDeSecondeLangue();
    }

    protected function concerneMonGroupeEspagnol(SimpleXMLElement $cours) {
        return !$this->pasDeSecondeLangue();
    }

    /*     * *** REDEFINITION pour la gestion de groupes ultra spécifiques (EI5 AGI pour définir EI5 IAIE et EI5 IHM-RV) **** */

    protected function groupesCorrespondent($mesGroupes, SimpleXMLElement $lesGroupesDuCours) {
        $groupesAppartenance = (is_array($mesGroupes)) ? $mesGroupes : array($mesGroupes);
        $groupesAppartenance[] = "EI5 AGI";
        return parent::groupesCorrespondent($groupesAppartenance, $lesGroupesDuCours);
    }

}
