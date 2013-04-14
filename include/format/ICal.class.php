<?php

class ICal extends Formatter {

    private $sourceICS;

    public function __construct($sourceICS) {
        $this->sourceICS = $sourceICS;
    }

    public function format(SimpleXMLElement $source) {
        $ids = $this->listeIdentifiants($source);
        $ics = substr($this->sourceICS, strpos($this->sourceICS, "BEGIN:VCALENDAR"));
        $lignes = explode("\n", $ics);
        $result = "";
        $i = 0;
        $nbLignes = count($lignes);
        while ($i < $nbLignes) {
            $ligneCourante = $lignes[$i];
            if (strpos($ligneCourante, "BEGIN:VEVENT") !== false) {
                $j = 0;
                $str = $lignes[$i + 4];
                $id = String::substr($str, '(', '-');
                if (in_array($id, $ids)) {
                    while (strpos($lignes[$i + $j], "END:VEVENT") === false)
                    {
                        
                        $ligne = $lignes[$i + $j];
                        $ligne = str_replace("SUMMARY", "SUMMARY", $ligne);
                        $estTitre = strpos($ligne, "SUMMARY") !== false;
                        $result .= $estTitre ? $this->filtreTitre($ligne) : $ligne;
                        $result .= "\n";
                        $j++;
                    }
                    $ligne = $lignes[$i + $j];
                    $result .= $ligne;
                    $i += $j;
                }
                else
                {
                    while (strpos($lignes[$i + $j], "END:VEVENT") === false)
                    {
                        $j++;
                    }
                    $i += $j;
                }
                $i++;
            }
            else 
            {
                $result .= $ligneCourante . "\n";
                $i++;
            }
        }
        return $result;
    }

    private function filtreTitre($ligneSummary) {
        $title = String::substr($ligneSummary, "- ", "\\");
        $new = " " . substr($title, strrpos($title, "/") + 1);
        $titreFinal = str_replace($title, $new, $ligneSummary);
        $posFin = strpos($titreFinal, "\\");
        $posFin = $posFin !== false ? $posFin : strlen($titreFinal);
        $titreFinal = substr($titreFinal, 0, $posFin) . "\r";
        return $titreFinal;
    }

    private function listeIdentifiants(SimpleXMLElement $racine) {
        $events = $racine->xpath("//event");
        $ids = array();
        foreach ($events as $e) {
            array_push($ids, (string) $e['id']);
        }
        return $ids;
    }

    public function getContentType() {
        return "Content-type: text/calendar; charset=utf-8";
    }

}
