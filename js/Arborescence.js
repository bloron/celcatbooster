
window.addEvent('domready', function(){
	
	var racine = $("selection");
	var chargeur = new Parametrage(racine);
	var formulaire = $('selecteur');
	
	racine.setStyle('display', 'inline');
	
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
	
	new Request({
		url: "include/promotions.php",
		onComplete: function(resultatJSON){
			var noeud = JSON.decode(resultatJSON);
			nodeIt(noeud).affiche(racine);
			chargeur.chargeDepuisCookie();
		}
	}).get();
	
	var genereHashDeSelection = function() {
		var hash = new Hash();
		var selects = $$('select'); 
		var nbSelectsNonNuls = 0;
		selects.each(function(select) {
			if(select.selectedIndex != 0)
				nbSelectsNonNuls++;
		})
		selects.each(function(select) {
			if(select.selectedIndex > 0){
				var extraValue = select.options[select.selectedIndex].get('edt');
				if($defined(extraValue))
					hash.set('edt', extraValue);
				if(nbSelectsNonNuls > 1){
					var oldVal = hash.get(select.get('rubrique'));
					var newVal = (oldVal == null) ? select.get('value') : oldVal + ";" + select.get('value');
					hash.set(select.get('rubrique'), newVal);
				}
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
	
	var getAction = function() {
		return formulaire.get('action');
	}
	
	$('lienInterne').addEvent('click', function(){
		var URI = genereURI();
		chargeur.sauveVersCookie(URI);
		parent.frames[0].location = getAction() + "?" + URI;
		return false;
	});
	
	$('lienExterne').addEvent('click', function(){
		var URI = genereURI();
		chargeur.sauveVersCookie(URI);
		this.set('href', getAction() + "?" + URI);
	});
});