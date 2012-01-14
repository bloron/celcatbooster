<?php

class XMLCal extends Formatter {
    
    public function format(SimpleXMLElement $source){
    	return $source->asXML();
    }

    public function getContentType() {
        return "Content-type: text/xml";
    }
}