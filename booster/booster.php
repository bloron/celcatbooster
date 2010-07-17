<?php

function autoChargement($class){
	require "../include/" . $class . ".class.php";
}

spl_autoload_register("autoChargement");

$booster = Fabrique::cree(Fabrique::PLANNING_EI4);

header('Content-type: text/xml');
define("EN_MODE_TEST", true);

if($booster != null)
	afficheEmploiDuTemps($booster);
else
	echo "Erreur de type";

//-------------------------------------------------------------------

function afficheEmploiDuTemps(Booster $booster){
	
	if(EN_MODE_TEST){
		// TESTS		
		$booster->setGroupesGeneraux(array("EI4", "EI4/AGI/G1", "EI4/AGI/TPA"));
		$booster->setGroupeAnglais("");
		$booster->setGroupeAllemand("");
		$booster->setGroupeEspagnol("EI4/GE2");
	}
	else{
		
		// PRODUCTION
		$booster->setGroupesGeneraux(explode(";", utf8_encode($_GET['filtres'])));
		$booster->setGroupeAnglais($_GET['groupeAnglais']);
		$booster->setGroupeAllemand("");
		$booster->setGroupeEspagnol("");
	}
	
	echo $booster->emploiDuTemps();
}