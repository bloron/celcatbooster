<?php

function autoChargement($class){
	require "../include/" . $class . ".class.php";
}

spl_autoload_register("autoChargement");

define("EN_MODE_TEST", true);
define("PROMOTION_TEST", Fabrique::PLANNING_EI4);
define("EMPLOI_DU_TEMPS", 	"edt");
define("GROUPES_GENERAUX", 	"gpGen");
define("GROUPE_ANGLAIS", 	"gpEng");
define("GROUPE_ALLEMAND", 	"gpAll");
define("GROUPE_ESPAGNOL", 	"gpEsp");