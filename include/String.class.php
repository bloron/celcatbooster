<?php

class String {
	
	public static function substr($chaine, $after, $before){
		$substr = "";
		$deb = strpos($chaine, $after);
		$fin = 0;
		if($deb !== false){
			$deb += count($after);
			$fin = strpos($chaine, $before, $deb);
			if($fin !== false){
				$substr = substr($chaine, $deb, $fin - $deb);
			}
		}
		return $substr;
	}
}