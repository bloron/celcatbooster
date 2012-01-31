var Categorie = new Class({
	
    libelle: '',
    rubrique: '',
    noeuds: [],
	
    initialize: function(libelle, rubrique) {
        this.libelle = libelle;
        this.rubrique = rubrique;
    },
	
    add: function(noeud) {
        this.noeuds.push(noeud);
    }
});

var Noeud = new Class({
	
    libelle: '',
    identifiant: '',
    categories: [],
    extraValues: null,
	
    LISTE_TYPE: 'div',
    LISTE_ELEMENT: 'div',

    onSelectChange: function(){},
	
    initialize: function(libelle, identifiant, extraValues, onSelectChange) {
        this.libelle = libelle;
        this.identifiant = identifiant;
        this.extraValues = $defined(extraValues) ? extraValues : new Hash();
        this.onSelectChange = $defined(onSelectChange) ? onSelectChange : function(){};
    },
	
    addCategorie: function(categorie) {
        this.categories.push(categorie);
    },
	
    affiche: function(wrapper) {
        $(wrapper).getChildren(this.LISTE_TYPE).destroy();
        if(this.categories.length > 0){
            var liste = new Element(this.LISTE_TYPE, {
                'styles': {
                    'display': 'inline'
                }
            });
            $each(this.categories, function(categorie) {
                var li = new Element(this.LISTE_ELEMENT, {
                    'styles': {
                        'display': 'inline'
                    }
                });
                this.creeSelect(categorie, li);
                liste.adopt(li);
            }, this);
            $(wrapper).adopt(liste);
        }
    },
	
    creeSelect: function(categorie, parent) {
        var iThis = this;
        var select = new Element("select", {
            'rubrique': categorie.rubrique,
            'events': {
                'change': function() {
                    iThis.selectionne(categorie, this, parent);
                }
            }
        });
        select.adopt(new Element("option", {
            'value': '',
            'text': '> Choix'
        }));
        $each(categorie.noeuds, function(noeud, index) {
            var option = new Element("option", {
                'value': noeud.identifiant,
                'text': categorie.libelle + noeud.libelle
            });
            noeud.extraValues.each(function(valeur, cle) {
                option.set(cle, valeur);
            });
            select.adopt(option);
        });
        parent.adopt(select);
    },
	
    selectionne: function(categorie, select, parent) {
        var noeud = categorie.noeuds[select.selectedIndex - 1];
        if($defined(noeud))
            noeud.affiche(parent);
        else
            $(parent).getChildren(this.LISTE_TYPE).destroy();
        this.onSelectChange();
    }
});

var Parametrage = new Class({
	
    racine: null,
    duration: 30,
    CLE_URI: "URI",
    usedOptions: null,
	
    initialize: function(elementRacine) {
        this.racine = $(elementRacine);
        this.usedOptions = new Hash();
    },
	
    /**
    * Enregistre dans un cookie une variable contenant tous les choix effectués :
    * URI = edt=3&gpGen=EI3%3BEI3%2FAGI%3BEI3%2FAGI%3BEI3%2FTC1%3BEI3%2FTPG2%3BEI3%2FTPG2%3BEI3%2FG3&gpEng=EI3%2FG1&gpEsp=EI3%2FGE2
    */
    sauveVersCookie: function(URI) {
        return escape(Cookie.write(this.CLE_URI, URI, {
            'duration': this.duration
        }));
    },
	
    chargeDepuisCookie: function() {
        var hashFiltres = this.chargeFiltres();
        var premier = $$('select')[0];
        this.usedOptions = new Hash();
        if($defined(premier) && hashFiltres.getLength() > 0){
            this.selectionneOption(premier, hashFiltres);
            return true;
        }
        return false;
    },
	
    chargeFiltres: function() {
        var filtres = new Hash(), filtresEnChaine = Cookie.read(this.CLE_URI);
        filtresEnChaine.split("&").each(function(variable) {
            var nomVar = variable.split("=")[0];
            var valeur = unescape(variable.split("=")[1]);
            filtres.set(nomVar, []);
            valeur.split(";").each(function(groupe) {
                filtres.get(nomVar).push(groupe);
            });
        }, this);
        return filtres;
    },
	
    selectionneOption: function(select, hashFiltres) {
        var index = -1;
        var namespace = select.get('rubrique');
        select.getChildren('option').each(function(option, numOption) {
            if(index == -1){
                var optVal = option.get('value');
                var fullKey = namespace + ":" + optVal;
                if(!this.usedOptions.has(fullKey)){
                    optVal.split(";").each(function(identifiant){
                        if(index == -1){
                            var values = hashFiltres.get(namespace);
                            if($defined(values))
                                index = values.indexOf(identifiant);
                            if(index != -1)
                                this.valideSelection(select, numOption, hashFiltres);
                        }
                    }, this);
                    if(index != -1){
                        this.usedOptions.set(fullKey, true);
                        console.log(fullKey);
                    }
                }
            }
        }, this);
    },
	
    valideSelection: function(select, index, filtres) {
        select.selectedIndex = index;
        select.fireEvent('change');
        var sibling = select.getNext();
        if($defined(sibling)){
            sibling.getElements('select').each(function(unSelect) {
                this.selectionneOption(unSelect, filtres);
            }, this);
        }
    }
});
