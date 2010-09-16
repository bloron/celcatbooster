<?php

abstract class Formatter
{
	private $sourceXML;
	
	public function __construct(SimpleXMLElement $source){
		$this->sourceXML = $source;
	}
	
	abstract public function format();
}