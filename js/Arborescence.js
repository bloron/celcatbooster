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
	
	initialize: function(libelle, identifiant) {
		this.libelle = libelle;
		this.identifiant = identifiant;
	},
	
	addCategorie: function(categorie) {
		this.categories.push(categorie);
	},
	
	affiche: function(wrapper) {
		var liste = new Element("ul");
		$each(this.categories, function(categorie) {
			var li = new Element("li", {
				"html": categorie.libelle
			});
			liste.adopt(li);
			$each(categorie.noeuds, function(noeud) {
				noeud.affiche(li);
			});
		});
		$(wrapper).adopt(liste);
	}
});

window.addEvent('domready', function(){

	var generaux = "gpGen";
	var anglais = "gpEng";
	
	var periode = new Noeud("Période", "");
	var annee = new Categorie("Année", generaux);
	periode.addCategorie(annee);
	
	var ei3 = new Noeud("Année EI3", "EI3");
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
	
	periode.affiche("test");
});