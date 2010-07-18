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
	
	LISTE_TYPE: 'ul',
	LISTE_ELEMENT: 'li',
	
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
					'display': 'block'
				}
			});
			$each(this.categories, function(categorie) {
				var li = new Element(this.LISTE_ELEMENT, {
					'styles': {
						'display': 'block'
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
					var noeud = categorie.noeuds[this.selectedIndex - 1];
					if($defined(noeud))
						noeud.affiche(parent);
					else
						$(parent).getChildren(iThis.LISTE_TYPE).destroy();
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
				'text': noeud.libelle
			});
			noeud.extraValues.each(function(valeur, cle) {
				option.set(cle, valeur);
			});
			select.adopt(option);
		});
		parent.adopt(select);
	}
});

window.addEvent('domready', function(){

	var generaux = "gpGen";
	var anglais = "gpEng";
	
	var racine = {
		libelle: "Période",
		identifiant: "",
		categories: [{
			libelle: "Emploi du temps",
			rubrique: generaux,
			noeuds: [{
				libelle: "Année EI1",
				identifiant: "EI1",
				categories: [],
				extra: {'edt': 1}
			},{
				libelle: "Année EI2",
				identifiant: "EI2",
				categories: [],
				extra: {'edt': 2}
			},{
				libelle: "Année EI3",
				identifiant: "EI3",
				categories: [],
				extra: {'edt': 3}
			},
			{
				libelle: "Année EI4",
				identifiant: "EI4",
				categories: [],
				extra: {'edt': 4}
			},{
				libelle: "Année EI5",
				identifiant: "EI5",
				categories: [],
				extra: {'edt': 5}
			}]
		}],
		extra: null
	};
	
	var nodeIt = function(nodeJSON) {
		var node = new Noeud(nodeJSON.libelle, nodeJSON.identifiant, new Hash(nodeJSON.extra));
		nodeJSON.categories.each(function(categorieJSON) {
			var categorie = new Categorie(categorieJSON.libelle, categorieJSON.rubrique);
			categorieJSON.noeuds.each(function(noeud) {
				categorie.add(nodeIt(noeud));
			});
			node.addCategorie(categorie);
		});
		return node;
	}
	
	var racineNode = nodeIt(racine);
	racineNode.affiche("selection");
	
	var periode = new Noeud("Période", "");
	var annee = new Categorie("Emploi du temps", generaux);
	periode.addCategorie(annee);
	
	var ei3 = new Noeud("Année EI3", "EI3", new Hash({'edt': 3}));
	var ei4 = new Noeud("Année EI4", "EI4");
	annee.add(ei3);
	annee.add(ei4);
	
	var catTD = new Categorie("TD", generaux);
	var catAnglais = new Categorie("Anglais", anglais);
	ei3.addCategorie(catTD);
	ei3.addCategorie(catAnglais);
	
	var td1 = new Noeud("TD1", "EI3/TD1");
	var td2 = new Noeud("TD2", "EI3/TD2");
	var td3 = new Noeud("TD3", "EI3/TD3");
	catTD.add(td1);
	catTD.add(td2);
	catTD.add(td3);
	
	var ang1 = new Noeud("Anglais 1", "EI3/Anglais 1");
	var ang2 = new Noeud("Anglais 2", "EI3/Anglais 2");
	var ang3 = new Noeud("Anglais 3", "EI3/Anglais 3");
	catAnglais.add(ang1);
	catAnglais.add(ang2);
	catAnglais.add(ang3);
	
//	periode.affiche("selection");
	
	var genereHashDeSelection = function() {
		var hash = new Hash();
		var selects = $$('select'); 
		selects.each(function(select) {
			var extraValue = select.options[select.selectedIndex].get('edt');
			if($defined(extraValue))
				hash.set('edt', extraValue);
			if(selects.length > 1){
				var oldVal = hash.get(select.get('rubrique'));
				var newVal = (oldVal == null) ? select.get('value') : oldVal + ";" + select.get('value');
				hash.set(select.get('rubrique'), newVal);
			}
		});
		return hash;
	}
	
	var genereURI = function() {
		return genereHashDeSelection().toQueryString();
	}
	
	var genereMessageHash = function() {
		var hash = genereHashDeSelection();
		var message = "";
		hash.each(function(valeur, cle) {
			message += cle + " = " + valeur + "\n";
		});
		return message;
	}
	
	$('lienInterne').addEvent('click', function(){
		alert(unescape(genereURI()));
		parent.frames[0].location = this.get('target') + "?" + genereURI();
		return false;
	});
});