<?php

class Booster {
	
	public static $XML = "xml";
	public static $ICAL = "ical";
	public static $GROUP_IDENTIFIER = "gp";
	public static $GROUPES_GENERAUX = "gpGen";
	public static $GROUPE_ANGLAIS = "gpEng";
	public static $GROUPE_ALLEMAND = "gpAll";
	public static $GROUPE_ESPAGNOL = "gpEsp";
	
	private $serveur;
	protected $groupes;
	protected $groupesGeneraux;
	protected $groupeAnglais;
	protected $groupeAllemand;
	protected $groupeEspagnol;
	protected $fichierXML;
	protected $fichierICS;
	
	public function __construct($serveur, $cheminFichierDistant){
		$this->serveur = $serveur;
		$this->fichierXML = $cheminFichierDistant . ".xml";
		$this->fichierICS = $cheminFichierDistant . ".ics";
		$this->setGroupesGeneraux(array());
		$this->setGroupeAnglais(array());
		$this->setGroupeAllemand(array());
		$this->setGroupeEspagnol(array());	
		$this->groupes = array();
	}
	
	public function setGroupes(array $vars){
		foreach($vars as $key => $value){
			if(String::startswith($key, self::$GROUP_IDENTIFIER)){
				$this->groupes[$key] = explode(";", $value);
			}
		}
		$this->setGroupesGeneraux(explode(";", utf8_encode($vars[self::$GROUPES_GENERAUX])));
		$this->setGroupeAnglais((isset($vars[self::$GROUPE_ANGLAIS])) ? $vars[self::$GROUPE_ANGLAIS] : "");
		$this->setGroupeAllemand((isset($vars[self::$GROUPE_ALLEMAND])) ? $vars[self::$GROUPE_ALLEMAND] : "");
		$this->setGroupeEspagnol((isset($vars[self::$GROUPE_ESPAGNOL])) ? $vars[self::$GROUPE_ESPAGNOL] : "");
	}

	public function setGroupesGeneraux($groupes){
		$this->groupesGeneraux = in_array("", $groupes) ? array() : $groupes;
	}
	
	public function setGroupeAnglais($groupe){
		$this->groupeAnglais = $groupe;
	}
	
	public function setGroupeAllemand($groupe){
		$this->groupeAllemand = $groupe;
	}
	
	public function setGroupeEspagnol($groupe){
		$this->groupeEspagnol = $groupe;
	}
	
	public function afficheEmploiDuTemps($format){
		$sourceXML = simplexml_load_string($this->emploiDuTemps());
		$formater = null;
		switch ($format) {
			case Booster::$ICAL:
				header('Content-type: text/calendar; charset=utf-8');
				$formater = new ICal($sourceXML, $this->getSourceICS());
			break;
			
			case Booster::$XML:
			default:
				header('Content-type: text/xml');
				$formater = new XMLCal($sourceXML);
			break;
		}
		echo $formater->format();
	}
	
	public function emploiDuTemps(){
		$racine = simplexml_load_string($this->getSourceXML());
		$resultat = '<?xml version="1.0" encoding="utf-8"?>' ."\n". '<?xml-stylesheet type="text/xsl" href="ttss.xsl"?>' ."\n". "<timetable>";
		$nonEvents = $racine->xpath("/timetable/*[not(self::event)]");
		$events = $racine->xpath("//event");
		foreach($nonEvents as $node){
			$resultat .= $node->asXML();
		}
		foreach($events as $node){
			$afficher = false;
			if(count($node->resources[0]) > 0)
				$afficher = $this->meConcerne($node);
			else
				$afficher = true;
			if($afficher)
				$resultat .= $node->asXML();
		}
		$resultat .= "</timetable>";
		return $resultat;
	}
	
	private function format(Formatter $formater){
		return $formater->format();
	}
	
	private function meConcerne(SimpleXMLElement $cours){
		if($this->aucunFiltreGeneralDefini() OR $this->coursSansGroupes($cours))
			return true;
		if($this->estUnCoursDeLangue($cours))
			return $this->concerneMesGroupesDeLangue($cours);
		else if($this->concerneUnGroupeParticulier($cours))
			return true;
		else
			return $this->concerneMesGroupesGeneraux($cours);
	}
	
	protected function concerneUnGroupeParticulier(SimpleXMLElement $cours){
		return false;
	}

	protected function concerneMesGroupesGeneraux(SimpleXMLElement $cours){
		if($this->groupesCorrespondent($this->groupesGeneraux, $cours->resources->group))
			return true;
		return false;
	}
	
	protected function aucunFiltreGeneralDefini(){
		return count($this->groupesGeneraux) == 0;
	}
	
	protected function pasDeGroupeAnglais(){
		return $this->groupeAnglais == "";
	}
	
	protected function pasDeGroupeAllemand(){
		return $this->groupeAllemand == "";
	}
	
	protected function pasDeGroupeEspagnol(){
		return $this->groupeEspagnol == "";
	}
	
	protected function pasDeSecondeLangue(){
		return ($this->pasDeGroupeEspagnol() AND $this->pasDeGroupeAllemand());
	}
	
	protected function coursSansGroupes(SimpleXMLElement $cours){
		return !isset($cours->resources->group);
	}
	
	private function concerneMesGroupesDeLangue(SimpleXMLElement $cours){
		return ($this->concerneMonGroupeAnglais($cours) OR $this->concerneMonGroupeAllemand($cours) OR  $this->concerneMonGroupeEspagnol($cours));
	}
	
	protected function concerneMonGroupeAnglais(SimpleXMLElement $cours){
		if($this->estUnCoursAnglais($cours)){
			if($this->pasDeGroupeAnglais()){
				return $this->groupesCorrespondent($this->groupesGeneraux, $cours->resources->group, true);
			}
			else{
				return $this->groupesCorrespondent($this->groupeAnglais, $cours->resources->group);
			}
		}
		return false;
	}
	
	protected function concerneMonGroupeAllemand(SimpleXMLElement $cours){
		if($this->estUnCoursAllemand($cours)){
			if($this->pasDeSecondeLangue())
				return $this->groupesCorrespondent($this->groupesGeneraux, $cours->resources->group);
			else
				return $this->groupesCorrespondent($this->groupeAllemand, $cours->resources->group);
		}
		return false;
	}
	
	protected function concerneMonGroupeEspagnol(SimpleXMLElement $cours){
		if($this->estUnCoursEspagnol($cours)){
			if($this->pasDeSecondeLangue())
				return $this->groupesCorrespondent($this->groupesGeneraux, $cours->resources->group);
			else
				return $this->groupesCorrespondent($this->groupeEspagnol, $cours->resources->group);
		}
		return false;
	}
	
	protected function estUnCoursDeLangue(SimpleXMLElement $cours){
		return ($this->estUnCoursAnglais($cours) OR $this->estUnCoursAllemand($cours) OR $this->estUnCoursEspagnol($cours));
	}
	
	protected function estUnCoursAnglais(SimpleXMLElement $cours){
		return $this->estUnCoursDeType($cours, "anglais");
	}
	
	protected function estUnCoursAllemand(SimpleXMLElement $cours){
		return $this->estUnCoursDeType($cours, "allemand");
	}
	
	protected function estUnCoursEspagnol(SimpleXMLElement $cours){
		return $this->estUnCoursDeType($cours, "espagnol");
	}
	
	protected function estUnCoursDeType(SimpleXMLElement $cours, $type){
		$trouve = false;
		$count = count($cours->resources->children());
		$i = 0;
		while(!$trouve && $i < $count){
			$trouve = strpos(strtolower($cours->resources->module->item[$i]), strtolower($type)) !== false;
			$i++;
		}
		return $trouve;
	}

	protected function groupesCorrespondent($mesGroupes, SimpleXMLElement $lesGroupesDuCours, $trace = false){
		$groupesAppartenance = (is_array($mesGroupes)) ? $mesGroupes : array($mesGroupes);
		$groupesDuCours = (count($lesGroupesDuCours->item) > 1) ? $lesGroupesDuCours->item : array($lesGroupesDuCours->item[0]);
		foreach($groupesDuCours as $groupe){
			if(in_array(trim($groupe), $groupesAppartenance))
				return true;
		}
		return false;
	}
	
	private function getSourceXML(){
		return $this->getFichierDistant($this->serveur, $this->fichierXML);
	}
	
	private function getSourceICS(){
		return $this->getFichierDistant($this->serveur, $this->fichierICS);
	}
	
	public static function getFichierDistant($serveur, $chemin){
		$contenuFichier = "";
		$socket = fsockopen($serveur, 80);
		if($socket !== false){
			$poststring = 
			
	            "GET ". $chemin ." HTTP/1.0\r\n" . 
	            "Connection: close\r\n\r\n"; 

			fputs($socket, $poststring); 
	        $buffer = ''; 
	        while(!feof($socket)) 
	            $buffer .= fgets($socket); 
	
	        fclose($socket);
			$contenuFichier .= substr($buffer, strpos($buffer, '<'));
		}
		return $contenuFichier;
	}
}
