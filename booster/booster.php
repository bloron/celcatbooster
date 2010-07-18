<?php

include("../config.php");

if(EN_MODE_TEST){
	$booster = Fabrique::cree(PROMOTION_TEST);
	parametrageDeTest($booster);
}
else{
	$booster = Fabrique::cree($_GET[EMPLOI_DU_TEMPS]);
	if($booster == null)
		die("Erreur : l'emploi du temps demandé est inconnu.");
	$booster->setGroupesGeneraux(explode(";", utf8_encode($_GET[GROUPES_GENERAUX])));
	$booster->setGroupeAnglais((isset($_GET[GROUPE_ANGLAIS])) ? $_GET[GROUPE_ANGLAIS] : "");
	$booster->setGroupeAllemand((isset($_GET[GROUPE_ALLEMAND])) ? $_GET[GROUPE_ALLEMAND] : "");
	$booster->setGroupeEspagnol((isset($_GET[GROUPE_ESPAGNOL])) ? $_GET[GROUPE_ESPAGNOL] : "");
}

header('Content-type: text/xml');
echo $booster->emploiDuTemps();

//-------------------------------------------------------------------

function parametrageDeTest(Booster $booster){

	switch(PROMOTION_TEST){
		case Fabrique::PLANNING_EI1 :
			$booster->setGroupesGeneraux(array("EI1", "EI1/TD G1", "EI1/TP G1"));
			$booster->setGroupeAnglais("EI1/Anglais G2");
			$booster->setGroupeAllemand("EI1/Allemand Avancé");
			$booster->setGroupeEspagnol("");
			break;
			
		case Fabrique::PLANNING_EI2 :
			$booster->setGroupesGeneraux(array("EI2", "EI2/G1", "EI2/TP1"));
			$booster->setGroupeAnglais("EI2/Anglais G3");
			$booster->setGroupeAllemand("EI2/Allemand débutant");
			$booster->setGroupeEspagnol("");
			break;
			
		case Fabrique::PLANNING_EI3 :
			$booster->setGroupesGeneraux(array("EI3", "EI3/GM1", "EI3/G1"));
			$booster->setGroupeAnglais("");
			$booster->setGroupeAllemand("");
			$booster->setGroupeEspagnol("EI3/GE1");
			break;
			
		case Fabrique::PLANNING_EI4 :
			$booster->setGroupesGeneraux(array("EI4", "EI4/AGI/G1", "EI4/AGI/TPA"));
			$booster->setGroupeAnglais("");
			$booster->setGroupeAllemand("");
			$booster->setGroupeEspagnol("EI4/GE2");
			break;
			
		case Fabrique::PLANNING_EI5 :
			$booster->setGroupesGeneraux(array("EI5", "EI5 AGI", "EI5 AGI TD G1", "EI5 AGI TP1"));
			$booster->setGroupeAnglais("");
			$booster->setGroupeAllemand("");
			$booster->setGroupeEspagnol("EI4/GE2");
			break;
			
		default : die("Promotion de test inconnue.");
	}
}