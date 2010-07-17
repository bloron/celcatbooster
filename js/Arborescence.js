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
	
	identifiant: '',
	libelle: '',
	categories: [],
	
	initialize: function(identifiant, libelle) {
		this.identifiant = identifiant;
		this.libelle = libelle;
	},
	
	addCategorie: function(categorie) {
		this.categories.push(categorie);
	}
});