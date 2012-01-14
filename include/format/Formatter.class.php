<?php

abstract class Formatter
{
	abstract public function format(SimpleXMLElement $source);
    abstract public function getContentType();
}