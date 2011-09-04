
window.addEvent('domready', function(){
	
	var racine = $("selection");
	var chargeur = new Parametrage(racine);
	var formulaire = $('selecteur');
	
	racine.setStyle('display', 'inline');
	
	new Request({
		url: "include/promotions.php",
		onComplete: function(resultatJSON){
			var resultat = JSON.decode(resultatJSON);
			data2nodes(resultat).affiche(racine);
			if(chargeur.chargeDepuisCookie())
				$('lienInterne').fireEvent('click');
		}
	}).get();
	
	$('lienInterne').addEvent('click', function(){
		var URI = genereURI();
		chargeur.sauveVersCookie(URI);
		var maFrame = $('celcatboosterInnerFrame');
		maFrame.set('src', formulaire.get('action') + "?" + URI);
		return false;
	});
	
	$('lienExterne').addEvent('click', function(){
		var URI = genereURI();
		chargeur.sauveVersCookie(URI);
		this.set('href', formulaire.get('action') + "?" + URI);
	});
	
	$('lienICal').addEvent('click', function(){
		var URI = genereURI();
		this.set('href', formulaire.get('action') + "?" + URI + "&format=ical");
		chargeur.sauveVersCookie(URI);
	});
});

function data2nodes(nodeJSON) {
	var node = new Noeud(nodeJSON.libelle, nodeJSON.identifiant, new Hash(nodeJSON.extra));
	nodeJSON.categories.each(function(categorieJSON) {
		var categorie = new Categorie(categorieJSON.libelle, categorieJSON.rubrique);
		categorieJSON.noeuds.each(function(noeud) {
			categorie.add(data2nodes(noeud));
		});
		node.addCategorie(categorie);
	});
	return node;
}

function genereHashDeSelection() {
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
			if(nbSelectsNonNuls > 0){
				var oldVal = hash.get(select.get('rubrique'));
				var newVal = (oldVal == null) ? select.get('value') : oldVal + ";" + select.get('value');
				hash.set(select.get('rubrique'), newVal);
			}
		}
	});
	return hash;
}

function genereURI() {
	var base = genereHashDeSelection().toQueryString();
	return base.replace("%C3%A9", "%E9");
}

function genereMessageHash() {
	var hash = genereHashDeSelection();
	var message = "";
	hash.each(function(valeur, cle) {
		message += cle + " = " + valeur + "\n";
	});
	return message;
}

