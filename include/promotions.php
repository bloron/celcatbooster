<?php

/**
 * Script traitant le fichier promotions.xml pour créer les différents select de la vue principale (index.html)
 * Elle génère des object JSON du type :
 *  {
 *      libelle: 'EI1',
 *      identifiant: 'EI1' 
 */
$xml = file_get_contents("../promotions.xml");
$racine = simplexml_load_string($xml);

echo nodeize($racine);

function nodeize(SimpleXMLElement $entreeMere, $identifiantPrecedent = "") {
    $identifiant = getIdentifiant($entreeMere, $identifiantPrecedent);
    $libelle = getLibelle($entreeMere);
    $json = "{" .
            "libelle: '$libelle'," .
            "identifiant: '$identifiant',";
    if (count($entreeMere->extra) > 0) {
        $nbExtra = 0;
        $json .= "extra: {";
        foreach ($entreeMere->extra as $extra) {
            if ($nbExtra > 0)
                $json .= ",";
            $json .= $extra['name'] . ": " . $extra['value'];
            $nbExtra++;
        }
        $json .= "},";
    }
    $json .= "categories: [";
    $nbCategories = 0;
    foreach ($entreeMere->filtre as $filtre) {
        if ($nbCategories > 0)
            $json .= ",";
        $json .= "{" .
                "libelle: '" . $filtre['libelle'] . "'," .
                "rubrique: '" . $filtre['rubrique'] . "'," .
                "noeuds: [";
        $nbNoeuds = 0;
        foreach ($filtre->entree as $entreeFille) {
            if ($nbNoeuds > 0)
                $json .= ",";
            $json .= nodeize($entreeFille, $identifiant);
            $nbNoeuds++;
        }
        $json .= "]}";
        $nbCategories++;
    }
    $json .= "]";
    $json .= "}";
    return $json;
}

function getIdentifiant(SimpleXMLElement $entree, $identifiantPrecedent){
    // Par défaut, l'identifiant d'une entrée vaut sa précédente "slash" son identifiant perso
    // Ex: précédent vaut "EI1" et l'entrée courante vaut "G1", l'identifiant sera EI1/G1
    $identifiant = $identifiantPrecedent . "/" . $entree['identifiant'];
    if ($entree['forcer'] == true) {
        // Sauf si on demande explicitement de le forcer à une valeur précise
        $identifiant = $entree['identifiant'];
    } else {
        // Et si le précédent est vide, on vire le slash
        if ($identifiantPrecedent == "")
            $identifiant = $entree['identifiant'];
    }
    return $identifiant;
}

function getLibelle(SimpleXMLElement $entree){
    return isset($entree['libelle']) ? $entree['libelle'] : $entree['identifiant'];
}