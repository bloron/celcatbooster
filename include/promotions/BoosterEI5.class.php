<?php

class BoosterEI5 extends Booster {

    public function __construct() {
        parent::__construct("g146422", array(
            "anglais" => "concerneMonGroupeAnglais",
            "espagnol" => "concerneMonGroupeEspagnol",
            "allemand" => "concerneMonGroupeAllemand"
        ));
    }

    protected function concerneMonGroupeAnglais(SimpleXMLElement $cours) {
        return $this->concerneMesGroupesGeneraux($cours);
    }

    /* Les EI5 actuels (2011-2012) ont Allemand et Espagnol en même temps */

    protected function concerneMonGroupeAllemand(SimpleXMLElement $cours) {
        return false;
    }

    protected function concerneMonGroupeEspagnol(SimpleXMLElement $cours) {
        return !$this->pasDeSecondeLangue();
    }
}
