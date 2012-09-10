<?php

/**
 *
 * Fichier d'entrée dans l'application. C'est ce fichier qui est appelé lorsqu'on consulte celcatbooster.
 * Ce fichier extrait les paramètres de l'URL dont :
 * 
 *  - l'emploi du temps ciblé
 *  - les groupes dont on fait partie
 *  
 * puis les réutilise pour constuire l'emploi du temps personnalisé.
 */

// Permet l'import automatique des fichiers de classe + définit des constantes
include("../config.php");

// Récupère le numéro d'emploi du temps dans l'URL
$edt = isset($_GET[EMPLOI_DU_TEMPS]) ? $_GET[EMPLOI_DU_TEMPS] : "";
// Récupère le format voulu dans l'URL
$format = isset($_GET[FORMAT_SORTIE]) ? $_GET[FORMAT_SORTIE] : "";

// Crée une instance de Booster grâce au numéro d'emploi du temps choisi
$booster = Fabrique::creeBooster($edt);
if($booster == null)
    die("Erreur : l'emploi du temps demandé est inconnu.");

// Instancie l'objet qui s'occupera (éventuellement) de traiter le flux filtré
// pour le mettre dans un autre format (comme ICS pour les mobiles)
$formatter = Fabrique::creeFormatter($format, $booster);
// On passe l'ensemble des groupes qui nous concernent dans l'URL au Booster
$booster->setGroupes($_GET);
// Toutes les données sont prêtes, on lance le filtrage et le formatage éventuel du résultat
$booster->afficheEmploiDuTemps($formatter);