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
	
	initialize: function(elementRacine) {
		this.racine = $(elementRacine);
	},
	
	chargeDepuisCookie: function() {
		var filtres = chargeFiltres();
		var premier = $$('select')[0];
		if($defined(premier))
			selectionneOption(premier);
	},
	
	selectionneOption: function(select) {
//		select.options.each()
		
	}
	
	chargeFiltres: function() {
		var filtres = [], filtresEnChaine = Cookie.read(this.CLE_URI);
		filtresEnChaine.split("&").each(function(parametre) {
			var valeurs = parametre.split("=")[1];
			valeurs.split(";").each(function(uneValeur) {
				filtres.push(uneValeur);
			});
		});
		alert(JSON.encode(filtres));
		return filtres;
	},
	
	sauveVersCookie: function(URI) {
		return Cookie.write(this.CLE_URI, URI, {'duration': duration});
	}
});