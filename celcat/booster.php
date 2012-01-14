<?php

include("../config.php");

$edt = isset($_GET[EMPLOI_DU_TEMPS]) ? $_GET[EMPLOI_DU_TEMPS] : "";
$format = isset($_GET[FORMAT_SORTIE]) ? $_GET[FORMAT_SORTIE] : "";

$booster = Fabrique::creeBooster($edt);
if($booster == null)
    die("Erreur : l'emploi du temps demandé est inconnu.");

$formatter = Fabrique::creeFormatter($format, $booster);
$booster->setGroupes($_GET);
$booster->afficheEmploiDuTemps($formatter);