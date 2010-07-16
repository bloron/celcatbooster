<?php

header('Content-type: text/xml');
$sourceXML = my_file_get_contents("nead.univ-angers.fr", "/celcat/istia/g2096.xml");
define("EN_MODE_TEST", false);
define("ANGLAIS_GROUPE", "EI3/TC/G1");

if(EN_MODE_TEST){
	
	// TESTS
	$filtres = array("EI3", "EI3/AGI", "EI3/II", "EI3/AGI/G1", "EI3/II/G1", "EI3/TC/G1", "EI3/AGI/TPAGI1", "EI3/II/TPII2", "EI3/s6/Espagnol/TD G2");
	echo CelcatAfficheContenuFiltre($sourceXML, $filtres, ANGLAIS_GROUPE);
}
else{
	
	// PRODUCTION
	$filtres = explode(";", utf8_encode($_GET['filtres']));
	echo CelcatAfficheContenuFiltre($sourceXML, $filtres, $_GET['groupeAnglais']);
}


//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function my_file_get_contents($nomHote, $cheminFichierDistant){
	$contenuFichier = "";
	$socket = fsockopen($nomHote, 80);
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

function CelcatAfficheContenuFiltre($fluxXML, $filtres, $anglais_groupe){
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
?>
