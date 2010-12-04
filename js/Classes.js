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
	
	initialize: function(libelle, identifiant, extraValues) {
		this.libelle = libelle;
		this.identifiant = identifiant;
		this.extraValues = ($defined(extraValues)) ? extraValues : new Hash();
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
	}
});

var Parametrage = new Class({
	
	racine: null,
	duration: 30,
	CLE_URI: "URI",
	CLES_UTILES: ['gpGen', 'gpEng', 'gpAll', 'gpEsp'],
	
	initialize: function(elementRacine) {
		this.racine = $(elementRacine);
	},
	
	sauveVersCookie: function(URI) {
		return escape(Cookie.write(this.CLE_URI, URI, {'duration': this.duration}));
	},
	
	chargeDepuisCookie: function() {
		var filtres = this.chargeFiltres();
		var premier = $$('select')[0];
		if($defined(premier) && filtres.getLength() > 0){
			this.selectionneOption(premier, filtres);
			return true;
		}
		return false;
	},
	
	chargeFiltres: function() {
		var filtres = new Hash(), filtresEnChaine = Cookie.read(this.CLE_URI);
		filtresEnChaine.split("&").each(function(parametre) {
			var cle = parametre.split("=")[0];
			if(this.CLES_UTILES.contains(cle)){
				if(!$defined(filtres.get(cle)))
					filtres.set(cle, []);
				var valeurs = unescape(parametre.split("=")[1]);
				valeurs.split(";").each(function(uneValeur) {
					filtres.get(cle).push(uneValeur);
				});
			}
		}, this);
		return filtres;
	},
	
	selectionneOption: function(select, filtres) {
		var index = -1;
		var cle = select.get('rubrique');
		select.getChildren('option').each(function(option, numOption) {
			if(index == -1){
				option.get('value').split(";").each(function(uneOption){
					if(index == -1){
						var values = filtres.get(cle);
						if($defined(values))
							index = values.indexOf(uneOption);
						if(index != -1)
						this.valideSelection(select, numOption, filtres);
					}
				}, this);
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
