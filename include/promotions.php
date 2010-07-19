<?php
$xml = file_get_contents("../promotions.xml");
$racine = simplexml_load_string($xml);

echo nodeize($racine);

function nodeize(SimpleXMLElement $node, $identifiantPrécédent = ""){
	$identifiant = ($identifiantPrécédent == "") ? $node['identifiant'] : $identifiantPrécédent . "/" . $node['identifiant'];
	if($node['forcer'] == true)
		$identifiant = $node['identifiant'];
	$json = "{" .
			"libelle: '" . $node['libelle'] . "'," .
			"identifiant: '" . $identifiant . "',";
	if(count($node->extra) > 0){
		$nbExtra = 0;
		$json .= "extra: {";
		foreach($node->extra as $extra){
			if($nbExtra > 0) $json .= ",";
			$json .= $extra['name'] . ": " . $extra['value'];
			$nbExtra++;
		}
		$json .= "},";
	}
	$json .= "categories: [";
	$nbCategories = 0;
	foreach($node->categorie as $categorie){
		if($nbCategories > 0) $json .= ",";
		$json .= 	"{" .
					"libelle: '" . $categorie['libelle'] . "'," .
					"rubrique: '" . $categorie['rubrique'] . "'," .
					"noeuds: [";
		$nbNoeuds = 0;
		foreach($categorie->noeud as $noeud){
			if($nbNoeuds > 0) $json .= ",";
			$json .= nodeize($noeud, $identifiant);
			$nbNoeuds++;
		}
		$json .= "]}";
		$nbCategories++;
	}
	$json .= "]";
	$json .= "}";
	return $json;
}