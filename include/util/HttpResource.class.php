<?php

/**
 * Classe utilitaire pour l'accès aux ressources internet
 *
 * @author Cedric
 */
class HttpResource {
    
    /*
     * Permet de récupérer le contenu d'un fichier texte distant, en contournant
     * les restrictions de certains hébergeurs sur la fonction file_get_contents()
     */
    public static function getFichierDistant($serveur, $chemin){
		$contenuFichier = "";
		$socket = fsockopen($serveur, 80);
		if($socket !== false){
			$poststring = 
			
	            "GET ". $chemin ." HTTP/1.0\r\n" . 
	            "Connection: close\r\n\r\n"; 

			fputs($socket, $poststring); 
	        $buffer = ''; 
	        while(!feof($socket)) 
	            $buffer .= fgets($socket); 
	
	        fclose($socket);
			$contenuFichier .= substr($buffer, strpos($buffer, '<'));
		}
		return $contenuFichier;
	}

    /*
     * Petit méthode de debuggage qui affiche le contenu d'une variable
     * dans un flux HTML.
     */
	public static function debug($var){
		echo "<pre>" . print_r($var, true) . "</pre>";
	}
}

?>
