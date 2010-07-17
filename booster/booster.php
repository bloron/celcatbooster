<?php

include("../config.php");

$booster = Fabrique::cree($_GET[EMPLOI_DU_TEMPS]);

if($booster != null){
	header('Content-type: text/xml');
	afficheEmploiDuTemps($booster);
}
else
	echo "Erreur : l'emploi du temps demandé est inconnu.";

//-------------------------------------------------------------------

function afficheEmploiDuTemps(Booster $booster){
	
	if(EN_MODE_TEST){
		// TESTS		
		
		$booster = Fabrique::cree(Fabrique::PLANNING_EI4);
		$booster->setGroupesGeneraux(array("EI4", "EI4/AGI/G1", "EI4/AGI/TPA"));
		$booster->setGroupeAnglais(""); // Pas de groupe spécifique
		$booster->setGroupeAllemand(""); // Je ne fais pas allemand
		$booster->setGroupeEspagnol("EI4/GE2"); // Je fais de l'espagnol
		
//		$booster = Fabrique::cree(Fabrique::PLANNING_EI4);
//		$booster->setGroupesGeneraux(array("EI4", "EI4/AGI/G1", "EI4/AGI/TPA"));
//		$booster->setGroupeAnglais(""); // Pas de groupe spécifique
//		$booster->setGroupeAllemand(""); // Je ne fais pas allemand
//		$booster->setGroupeEspagnol("EI4/GE2"); // Je fais de l'espagnol
	}
	else{
		
		// PRODUCTION
		$groupeAnglais = (isset($_GET[GROUPE_ANGLAIS])) ? $_GET[GROUPE_ANGLAIS] : "";
		$groupeAllemand = (isset($_GET[GROUPE_ALLEMAND])) ? $_GET[GROUPE_ALLEMAND] : "";
		$groupeEspagnol = (isset($_GET[GROUPE_ESPAGNOL])) ? $_GET[GROUPE_ESPAGNOL] : "";
		$booster->setGroupesGeneraux(explode(";", utf8_encode($_GET[GROUPES_GENERAUX])));
		$booster->setGroupeAnglais($groupeAnglais);
		$booster->setGroupeAllemand($groupeAllemand);
		$booster->setGroupeEspagnol($groupeEspagnol);
	}
	
	echo $booster->emploiDuTemps();
}