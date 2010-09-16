<?php

abstract class Formatter
{
	protected $sourceXML;
	
	public function __construct(SimpleXMLElement $source){
		$this->sourceXML = $source;
	}
	
	abstract public function format();
}