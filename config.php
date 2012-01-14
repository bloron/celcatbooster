<?php

function autoChargement($class){
    $pathes = array(
        "../include/",
        "../include/format/",
        "../include/util/",
        "../include/promotions/"
    );
    $i = 0;
    $nbPathes = count($pathes);
    $fileExists = false;
    while(!$fileExists && $i < $nbPathes){
        $fileExists = file_exists($pathes[$i] . $class . ".class.php");
        if(!$fileExists)
            $i++;
    }
    if($fileExists)
        require $pathes[$i] . $class . ".class.php";
}

spl_autoload_register("autoChargement");

define("EMPLOI_DU_TEMPS", 	"edt");
define("FORMAT_SORTIE", 	"format");
