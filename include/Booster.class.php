<?php

class Booster {

    public static $GROUP_IDENTIFIER = "gp";
    public static $GROUPES_GENERAUX = "gpGen";
    public static $GROUPE_ANGLAIS = "gpEng";
    public static $GROUPE_ALLEMAND = "gpAll";
    public static $GROUPE_ESPAGNOL = "gpEsp";
    public static $GROUPE_MASTER = "gpMas";
    private $sourceXML;
    private $resource;
    private $specialFilters;
    protected $groupes;
    protected $groupesStrings;

    /**
     * Constructeur.
     * @param String $dataResource Chaîne XML provenant du site de l'université, et contenant l'emploi du temps non filtré.
     *  array $specialFilters Tableau associatif éventuel, associant un nom de cours à une méthode. Si le nom
     * de cours est trouvé lors de l'analyse, c'est le résultat de la méthode qui devra dire si le cours nous concerne (return true)
     * ou pas (return false).
     */
    public function __construct($dataResource, array $specialFilters = array()) {
        // On stocke le flux XML dans une variable
        $this->resource = $dataResource;
        // On associe certains cours à des méthodes particulières (les cours de langues ont toujours des règles spécifiques)
        $this->specialFilters = array_merge(array(
            "anglais" => "filtreAnglais",
            "espagnol" => "filtreEspagnol",
            "allemand" => "filtreAllemand"
                ), $specialFilters);
        $this->groupes = array();
    }

    /**
     * Permet de dire de quels groupes on fait partie.
     * @param array $vars Tableau des groupes, de la forme $vars['gpGen'] = "EI5/EI5%20AGI/..."; $vars['gpEng'] = "...";
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

    /**
     * Méthode d'exécution du filtrage. Lance l'analyse, filtre les cours, puis formate la sortie.
     * @param Formatter $formatter Instance s'occupant de formater la sortie (XML ou ICS)
     */
    public function afficheEmploiDuTemps(Formatter $formatter) {
        $emploiDuTempsCleaned = $this->emploiDuTemps();
        $xmlAssocie = simplexml_load_string($emploiDuTempsCleaned);
        header($formatter->getContentType());
        echo $formatter->format($xmlAssocie);
    }

    /**
     * Méthode qui s'occupe du filtrage. Elle utilise le flux XML d'entrée, filtre chaque cours, puis renvoie une chaîne XML
     * élaguée des cours qui ne nous intéressent pas.
     * @return String Flux XML sans les cours filtrés.
     */
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

    /**
     * Méthode inutile ?
     */
    private function format(Formatter $formater) {
        return $formater->format();
    }

    /**
     * Méthode de filtrage. Prend un élément XML en paramètre, et renvoie TRUE si le cours est à conserver, FALSE s'il doit être filtré.
     * @param SimpleXMLElement $cours Cours sous forme d'objet SimpleXML
     * @return boolean 
     */
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

    /**
     * Méthode qui teste si un cours concerne mes groupes généraux (CM, TD, TP, ...)
     * @param SimpleXMLElement $cours
     * @return boolean 
     */
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

    /**
     * Permet de savoir le type de cours en effectuant un test sur le nom.
     * @param SimpleXMLElement $cours Objet de cours qu'on souhaite tester
     * @param type $type Nom du cours
     * @return type Retourne TRUE si le nom passé en paramètre est présent dans le nom du cours, FALSE sinon.
     */
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

    /**
     * Méthode testant si un de mes groupes correspond à celui du cours. Si oui, c'est qu'il faut le conserver !
     * @return boolean TRUE si un de mes groupes figure dans le cours, FALSE sinon.
     */
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
