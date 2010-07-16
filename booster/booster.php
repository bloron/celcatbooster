<?php

function autoChargement($class){
	require "../include/" . $class . ".class.php";
}

spl_autoload_register("autoChargement");

$booster = new Booster();

header('Content-type: text/xml');

$sourceXML = my_file_get_contents("nead.univ-angers.fr", "/celcat/istia/g2096.xml");
define("EN_MODE_TEST", false);

if(EN_MODE_TEST){
	
	// TESTS
	$booster->setGroupesGeneraux(array("EI3", "EI3/AGI", "EI3/II", "EI3/AGI/G1", "EI3/II/G1", "EI3/TC/G1", "EI3/AGI/TPAGI1", "EI3/II/TPII2", "EI3/s6/Espagnol/TD G2"));
	$booster->setGroupeAnglais("EI3/TC/G1");
	$booster->setGroupeAllemand("");
	$booster->setGroupeEspagnol("");
}
else{
	
	// PRODUCTION
	$booster->setGroupesGeneraux(explode(";", utf8_encode($_GET['filtres'])));
	$booster->setGroupeAnglais($_GET['groupeAnglais']);
	$booster->setGroupeAllemand("");
	$booster->setGroupeEspagnol("");
}

echo $booster->emploiDuTemps();