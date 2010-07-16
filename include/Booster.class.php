<?php

class Booster {
	
	private $serveur;
	private $cheminFichierDistant;
	private $groupesGeneraux;
	private $groupeAnglais;
	private $groupeAllemand;
	private $groupeEspagnol;
	
	public function __construct($groupesGeneraux = array(), $groupeAnglais = "", $groupeAllemand = "", $groupeEspagnol = ""){
		$this->groupesGeneraux = $groupesGeneraux;
		$this->groupeAnglais = $groupeAnglais;
		$this->groupeAllemand = $groupeAllemand;
		$this->groupeEspagnol = $groupeEspagnol;
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
	
	public function emploiDuTemps($fluxXML, $filtres, $anglais_groupe){
		$racine = simplexml_load_string($fluxXML);
		$resultat = '<?xml version="1.0" encoding="utf-8"?>' ."\n". '<?xml-stylesheet type="text/xsl" href="ttss.xsl"?>' ."\n". "<timetable>";
		$nonEvents = $racine->xpath("/timetable/*[not(self::event)]");
		$events = $racine->xpath("//event");
		foreach($nonEvents as $node){
			$resultat .= $node->asXML();
		}
		foreach($events as $node){
			$afficher = false;
			if(count($node->resources[0]) > 0){
				// AVEC RESSOURCES
				if(strpos($node->resources->module->item[0], "Anglais") !== false){
					// ANGLAIS
					foreach($node->resources->group->item as $groupe){
						if($groupe == $anglais_groupe)
							$afficher = true;
					}
				}
				else{
					// NORMAL
					foreach($node->resources->group->item as $groupe){
						if(in_array(trim($groupe), $filtres))
							$afficher = true;
					}
				}
			}
			else $afficher = true;
			if($afficher)
				$resultat .= $node->asXML();
		}
		$resultat .= "</timetable>";
		return $resultat;
	}
	
	private function getSourceXML(){
		return $this->getFichierDistant($this->serveur, $this->cheminFichierDistant);
	}
	
	public static function getFichierDistant($serveur, $chemin){
		$contenuFichier = "";
		$socket = fsockopen($serveur, 80);
		if($socket !== false){
			$poststring = 
			
	            "GET ". $cheminFichierDistant ." HTTP/1.0\r\n" . 
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
