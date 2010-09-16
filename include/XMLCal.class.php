<?php

class XMLCal extends Formatter {

    function __construct(SimpleXMLElement $source){
    	parent::__construct($source);
    }
    
    public function format(){
    	return $this->sourceXML->asXML();
    }
}