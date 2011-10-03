<?php
$xml = file_get_contents("../promotions.xml");
$racine = simplexml_load_string($xml);

echo nodeize($racine);

function nodeize(SimpleXMLElement $entree, $identifiantPrecedent = ""){
	$identifiant = ($identifiantPrecedent == "") ? $entree['identifiant'] : $identifiantPrecedent . "/" . $entree['identifiant'];
	$optionnel = ($entree['idOptionnel'] == "1") ? ";" . $identifiantPrecedent . " " . $entree['identifiant'] : "";
	if($entree['forcer'] == true)
		$identifiant = $entree['identifiant'];
	$json = "{" .
			"libelle: '" . (isset($entree['libelle']) ? $entree['libelle'] : $entree['identifiant']) . "'," .
			"identifiant: '" . $identifiant . $optionnel . "',";
	if(count($entree->extra) > 0){
		$nbExtra = 0;
		$json .= "extra: {";
		foreach($entree->extra as $extra){
			if($nbExtra > 0) $json .= ",";
			$json .= $extra['name'] . ": " . $extra['value'];
			$nbExtra++;
		}
		$json .= "},";
	}
	$json .= "categories: [";
	$nbCategories = 0;
	foreach($entree->categorie as $categorie){
		if($nbCategories > 0) $json .= ",";
		$json .= 	"{" .
					"libelle: '" . $categorie['libelle'] . "'," .
					"rubrique: '" . $categorie['rubrique'] . "'," .
					"noeuds: [";
		$nbNoeuds = 0;
		foreach($categorie->entree as $element){
			if($nbNoeuds > 0) $json .= ",";
			$json .= nodeize($element, $identifiant);
			$nbNoeuds++;
		}
		$json .= "]}";
		$nbCategories++;
	}
	$json .= "]";
	$json .= "}";
	return $json;
}
