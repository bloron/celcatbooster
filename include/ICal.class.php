<?php

class ICal extends Formatter
{
	private $sourceICS;
	
	public function __construct(SimpleXMLElement $sourceXML, $sourceICS){
		parent::__construct($sourceXML);
		$this->sourceICS = $sourceICS;
	}
	
	public function format(){
		$ids = $this->listeIdentifiants($this->sourceXML);
		$ics = substr($this->sourceICS, strpos($this->sourceICS, "BEGIN:VCALENDAR"));
		$lignes = explode("\n", $ics);
		$result = "";
		$i = 0;
		$nbLignes = count($lignes);
		while($i < $nbLignes){
			$ligneCourante = $lignes[$i];
			if(strpos($ligneCourante, "BEGIN:VEVENT") !== false){
				$str = $lignes[$i + 3];
				$id = String::substr($str, '(', '-');
				if(in_array($id, $ids)){
					for($j = 0; $j < 9; $j++){
						$ligne = $lignes[$i + $j];
						$estTitre = strpos($ligne, "SUMMARY") !== false;
						$result .= $estTitre ? $this->filtreTitre($ligne) : $ligne;
						$result .= "\n";
					}
				}
				$i += 9;
			}
			else{
				$result .= $ligneCourante . "\n";
				$i++;
			}
		}
		return $result;
	}
	
	private function filtreTitre($ligneSummary){
		$title = String::substr($ligneSummary, "- ", "\\");
		$new = " " . substr($title, strrpos($title, "/") + 1);
		$titreFinal = str_replace($title, $new, $ligneSummary);
		$posFin = strpos($titreFinal, "\\");
		$posFin = $posFin !== false ? $posFin : strlen($titreFinal);
		$titreFinal = substr($titreFinal, 0, $posFin) . "\r";
		return $titreFinal;
	}
	
	private function listeIdentifiants($racine){
		$events = $racine->xpath("//event");
		$ids = array();
		foreach($events as $e){
			array_push($ids, (string) $e['id']);
		}
		return $ids;
	}
}