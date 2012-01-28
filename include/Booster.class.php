<?php

class Booster {

    public static $GROUP_IDENTIFIER = "gp";
    public static $GROUPES_GENERAUX = "gpGen";
    public static $GROUPE_ANGLAIS = "gpEng";
    public static $GROUPE_ALLEMAND = "gpAll";
    public static $GROUPE_ESPAGNOL = "gpEsp";
    private $sourceXML;
    private $resource;
    private $specialFilters;
    protected $groupes;
    protected $groupesStrings;

    public function __construct($dataResource, array $specialFilters = array()) {
        $this->resource = $dataResource;
        $this->specialFilters = array_merge(array(
            "anglais" => "filtreAnglais",
            "espagnol" => "filtreEspagnol",
            "allemand" => "filtreAllemand"
                ), $specialFilters);
        $this->groupes = array();
    }

    /**
     * $vars array Tableau des groupes, de la forme $vars['gpGen'] = "EI5/EI5%20AGI/..."; $vars['gpEng'] = "...";
     */
    public function setGroupes(array $vars) {
        foreach ($vars as $key => $value) {
            if (String::startswith($key, self::$GROUP_IDENTIFIER)) {
                $this->groupes[$key] = explode(";", $value);
                $this->groupesStrings[$key] = utf8_encode($value);
                foreach ($this->groupes[$key] as $subkey => $subvalue)
                    $this->groupes[$key][$subkey] = utf8_encode($subvalue);
            }
        }
    }

    public function afficheEmploiDuTemps(Formatter $formatter) {
        $emploiDuTempsCleaned = $this->emploiDuTemps();
        $xmlAssocie = simplexml_load_string($emploiDuTempsCleaned);
        header($formatter->getContentType());
        echo $formatter->format($xmlAssocie);
    }

    public function emploiDuTemps() {
        $racine = simplexml_load_string($this->getSourceXML());
        $resultat = '<?xml version="1.0" encoding="utf-8"?>' . "\n" . '<?xml-stylesheet type="text/xsl" href="ttss.xsl"?>' . "\n" . "<timetable>";
        $nonEvents = $racine->xpath("/timetable/*[not(self::event)]");
        $events = $racine->xpath("//event");
        foreach ($nonEvents as $node) {
            $resultat .= $node->asXML();
        }
        foreach ($events as $node) {
            $afficher = false;
            if (count($node->resources[0]) > 0)
                $afficher = $this->meConcerne($node);
            else
                $afficher = true;
            if ($afficher)
                $resultat .= $node->asXML();
        }
        $resultat .= "</timetable>";
        return $resultat;
    }

    private function format(Formatter $formater) {
        return $formater->format();
    }

    private function meConcerne(SimpleXMLElement $cours) {
        if ($this->aucunFiltreGeneralDefini() OR $this->coursSansGroupes($cours))
            return true;
        else {
            $filterFunc = "";
            foreach ($this->specialFilters as $cleCours => $nomMethode) {
                if ($filterFunc == "") {
                    if ($this->estUnCoursDeType($cours, $cleCours)) {
                        $filterFunc = $nomMethode;
                    }
                }
            }
            if ($filterFunc != "")
                return $this->$filterFunc($cours);
            else
                return $this->concerneMesGroupesGeneraux($cours);
        }
    }

    protected function concerneMesGroupesGeneraux(SimpleXMLElement $cours) {
        if ($this->groupesCorrespondent($this->groupes[self::$GROUPES_GENERAUX], $cours->resources->group))
            return true;
        return false;
    }

    protected function aucunFiltreGeneralDefini() {
        return count($this->groupes[self::$GROUPES_GENERAUX]) == 0;
    }

    protected function pasDeSecondeLangue() {
        return (!($this->issetGroup(self::$GROUPE_ESPAGNOL) OR $this->issetGroup(self::$GROUPE_ESPAGNOL)));
    }

    protected function issetGroup($groupKey) {
        return isset($this->groupes[$groupKey]);
    }

    protected function getGroup($groupKey) {
        return $this->issetGroup($groupKey) ? $this->groupes[$groupKey] : array();
    }

    protected function coursSansGroupes(SimpleXMLElement $cours) {
        return !isset($cours->resources->group);
    }

    private function filtreAnglais(SimpleXMLElement $cours) {
        return $this->filtreLangues($cours, $this->getGroup(self::$GROUPE_ANGLAIS));
    }

    private function filtreEspagnol(SimpleXMLElement $cours) {
        return $this->filtreLangues($cours, $this->getGroup(self::$GROUPE_ESPAGNOL));
    }

    private function filtreAllemand(SimpleXMLElement $cours) {
        return $this->filtreLangues($cours, $this->getGroup(self::$GROUPE_ALLEMAND));
    }

    private function filtreLangues(SimpleXMLElement $cours, $groupesSpeciaux) {
        if (is_array($groupesSpeciaux))
            return $this->groupesCorrespondent($groupesSpeciaux, $cours->resources->group);
        else
            return $this->groupesCorrespondent($this->getGroup(self::$GROUPES_GENERAUX), $cours->resources->group);
    }

    protected function estUnCoursDeType(SimpleXMLElement $cours, $type) {
        $trouve = false;
        $count = count($cours->resources->children());
        $i = 0;
        while (!$trouve && $i < $count) {
            $trouve = strpos(strtolower($cours->resources->module->item[$i]), strtolower($type)) !== false;
            $i++;
        }
        return $trouve;
    }

    protected function groupesCorrespondent($mesGroupes, SimpleXMLElement $lesGroupesDuCours) {
        $groupesAppartenance = (is_array($mesGroupes)) ? $mesGroupes : array($mesGroupes);
        $groupesDuCours = (count($lesGroupesDuCours->item) > 1) ? $lesGroupesDuCours->item : array($lesGroupesDuCours->item[0]);
        foreach ($groupesDuCours as $groupe) {
            if (in_array(trim($groupe), $groupesAppartenance))
                return true;
        }
        return false;
    }

    private function getSourceXML() {
        return $this->sourceXML;
    }

    public function getResource() {
        return $this->resource;
    }

    public function setSourceXML($sourceXML) {
        $this->sourceXML = $sourceXML;
    }

}
