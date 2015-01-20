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
        $poststring = "";
		$socket = fsockopen($serveur, 80);
		if($socket !== false){
			$poststring = 

	            "GET $chemin HTTP/1.1\r\n" . 
	            "Host: $serveur\r\n" . 
                "Cache-Control: no-cache\r\n" .
                "Pragma: no-cache\r\n" .
                "User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/535.11 (KHTML, like Gecko) Chrome/17.0.963.83 Safari/535.11\r\n" .
                "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\r\n" .
                "Accept-Language: fr-FR,fr;q=0.8,en-US;q=0.6,en;q=0.4\r\n" .
                "Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.3\r\n" .
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
