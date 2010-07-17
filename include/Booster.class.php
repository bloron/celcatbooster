<?php

abstract class Booster {
	
	private $serveur;
	private $cheminFichierDistant;
	protected $groupesGeneraux;
	protected $groupeAnglais;
	protected $groupeAllemand;
	protected $groupeEspagnol;
	
	public function __construct($serveur, $cheminFichierDistant){
		$this->serveur = $serveur;
		$this->cheminFichierDistant = $cheminFichierDistant;		
	}
	
	public function setGroupesGeneraux($groupes){
		$this->groupesGeneraux = $groupes;
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
	
	private function meConcerne(SimpleXMLElement $cours){
		return ($this->concerneMesGroupesGeneraux($cours) OR $this->concerneMesGroupesDeLangue($cours));
	}
	
	protected function concerneMesGroupesGeneraux(SimpleXMLElement $cours){
		if(!isset($cours->resources->group))
			return true;
		if($this->groupesCorrespondent($this->groupesGeneraux, $cours->resources->group))
			return true;
		return false;
	}
	
	private function concerneMesGroupesDeLangue(SimpleXMLElement $cours){
		return ($this->concerneMonGroupeAnglais($cours) OR $this->concerneMonGroupeAllemand($cours) OR  $this->concerneMonGroupeEspagnol($cours));
	}
	
	protected function concerneMonGroupeAnglais(SimpleXMLElement $cours){
		// Règle par défaut : on affiche tous les cours d'anglais
		if(strpos(strtolower($cours->resources->module->item[0]), "anglais") !== false){
			return true;
		}
		return false;
	}
	
	protected function concerneMonGroupeAllemand(SimpleXMLElement $cours){
		// Règle par défaut : on affiche tous les cours d'allemand
		if(strpos(strtolower($cours->resources->module->item[0]), "allemand") !== false){
			return true;
		}
		return false;
	}
	
	protected function concerneMonGroupeEspagnol(SimpleXMLElement $cours){
		// Règle par défaut : on affiche tous les cours d'espagnol
		if(strpos(strtolower($cours->resources->module->item[0]), "espagnol") !== false){
			return true;
		}
		return false;
	}
	
	protected function estUnCoursDeLangue(SimpleXMLElement $cours){
		if(strpos(strtolower($cours->resources->module->item[0]), "anglais") !== false)
			return true;
		if(strpos(strtolower($cours->resources->module->item[0]), "allemand") !== false)
			return true;
		if(strpos(strtolower($cours->resources->module->item[0]), "espagnol") !== false)
			return true;
		return false;
	}
	
	protected function groupesCorrespondent($mesGroupes, SimpleXMLElement $lesGroupesDuCours){
		$groupesAppartenance = (is_array($mesGroupes)) ? $mesGroupes : array($mesGroupes);
		$groupesDuCours = (is_array($lesGroupesDuCours->item)) ? $lesGroupesDuCours->item : array($lesGroupesDuCours->item);
		foreach($groupesDuCours as $groupe){
			if(in_array(trim($groupe), $groupesAppartenance))
				return true;
		}
		return false;
	}
	
	private function getSourceXML(){
		return $this->getFichierDistant($this->serveur, $this->cheminFichierDistant);
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
