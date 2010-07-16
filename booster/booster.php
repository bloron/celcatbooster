<?php

function autoChargement($class){
	require "../include/" . $class . ".class.php";
}

spl_autoload_register("autoChargement");

$booster = new CelcatBooster();


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
