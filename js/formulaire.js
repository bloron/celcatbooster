var Parametrage = new Class({

	cookiesExistants: false,
	dureeConsevation: 30,
	liste: [],
	donnees: null,
	
	initialize: function(){
		this.liste = ['promo', 'opt1', 'opt2', 'tc', 'lv1', 'lv2', 'td1', 'td2', 'tp1', 'tp2'];
		this.donnees = new Hash();
	},
	
	litCookies: function(){
		$each(this.liste, function(cle){
			var val = $pick(Cookie.read(cle), '');
			if(!this.cookiesExistants && val != '') this.cookiesExistants = true;
			this.donnees.set(cle, val);
		}, this);
	},
	
	ecritCookies: function(){
		var duree = this.dureeConsevation;
		$each(this.liste, function(cle){
			Cookie.write(cle, this.donnees.get(cle), {duration: duree});
		}, this);
	},
	
	litChamps: function(){
		$each(this.liste, function(cle){
			this.donnees.set(cle, $(cle).get('value'));
		}, this);
	},
	
	ecritChamps: function(){
		$each(this.liste, function(cle){
			var valeur = this.donnees.get(cle);
			var trouve = false;
			var i = 0;
			var select = $(cle);
			var options = select.options;
			while(i < options.length && !trouve){
				if(options[i].value == valeur){
					trouve = true;
					options[i].setProperty('selected', 'selected');
				}
				i++;
			}
		}, this);
	},
	
	getFiltres: function(){
		var filtres = this.getFiltresPromos();
		$each(this.liste, function(cle){
			if(cle != 'promo' && cle != 'lv1' && cle != 'opt1' && cle != 'opt2')
				filtres += $(cle).get('value') + ';';
		});
		return filtres;
	},
	
	getFiltresPromos: function(){
		var promo = this.donnees.get('promo');
		var opt1 = promo + '/' + this.donnees.get('opt1');
		var opt2 = promo + '/' + this.donnees.get('opt2');
		return promo + ';' + opt1 + ';' + opt2 + ';';
	},
	
	get: function(cle){
		return this.donnees.get(cle);
	}
});

window.addEvent('domready', function(){

	var promos = {
		EI3: {
			AGI: {
				TD: 3,
				TP: 4
			},
			II: {
				TD: 3,
				TP: 4
			},
			IMQ: {
				TD: 4,
				TP: 6
			}
		}
	}
	
	function genereOptions(promo, type, numOption){
		var opt = $('opt'+numOption).get('value');
		var nbGroupes = eval('promos.'+promo+'.'+opt+'.'+type.toUpperCase());
		for(i = 1; i <= nbGroupes; i++){
			$(type+numOption).adopt(new Element('option', {
				'value': (type == 'td') ? promo+'/'+opt+'/G'+i : promo+'/'+opt+'/TP'+opt+i,
				'text': type.toUpperCase()+' '+opt+' '+i
			}));
		}
	}
	
	function genereURI(unParam){
		unParam.litChamps();
		unParam.ecritCookies();
		var form = $('myForm');
		var filtres = unParam.getFiltres();
		var adresse = form.get('action') + '?' + 'groupeAnglais=' + unParam.get('lv1') + '&filtres=' + filtres;
		return adresse;
	}
	
	oParam = new Parametrage();
	oParam.litCookies();
	
	$each(promos, function(promo, nomPromo){
		$('promo').adopt(new Element('option', {
			'value': nomPromo,
			'text': nomPromo
		}));
	});
	
	$('promo').addEvent('change', function(){
		var nomPromo = $('promo').get('value');
		var elementsLies = ['opt1', 'opt2', 'lv1', 'lv2'];
		elementsLies.each(function(el){
			$(el).empty();
		});
		$each(eval('promos.'+nomPromo), function(option, nomOption){
			$('opt1').adopt(new Element('option', {
				'value': nomOption,
				'text': nomOption
			}));
			$('opt2').adopt(new Element('option', {
				'value': nomOption,
				'text': nomOption
			}));
		});
	});
	
	$('opt1').addEvent('change', function(){
		var elementsLies = ['td1', 'tp1'];
		elementsLies.each(function(el){
			$(el).empty();
		});
		var promo = $('promo').get('value');
		genereOptions(promo, 'td', 1);		
		genereOptions(promo, 'tp', 1);		
	});
	
	$('opt2').addEvent('change', function(){
		var elementsLies = ['td2', 'tp2'];
		elementsLies.each(function(el){
			$(el).empty();
		});
		var promo = $('promo').get('value');
		genereOptions(promo, 'td', 2);		
		genereOptions(promo, 'tp', 2);	
	});
	
	$('lv1').addEvent('click', function(){
	});
	
	$('lv2').addEvent('click', function(){
	});
	
	$('myForm').addEvent('submit', function(){
		parent.frames[0].location = genereURI(oParam);
		return false;
	});
	
	$('promo').fireEvent('change');
	$('opt1').fireEvent('change');
	$('opt2').fireEvent('change');
	
	for(i = 1; i <= 5; i++){
		$('tc').adopt(new Element('option', {
			'value': 'EI3/TC/G'+i,
			'text': 'TC '+i
		}));
		$('lv1').adopt(new Element('option', {
			'value': 'EI3/TC/G'+i,
			'text': 'Anglais G'+i
		}));
	}
	
	for(i = 1; i <= 4; i++){
		$('lv2').adopt(new Element('option', {
			'value': 'EI3/s6/Espagnol/TD G'+i,
			'text': 'Espagnol G'+i
		}));
	}
	var groupesAllemand = ['EI3/s6/Allemand Avanc�', 'EI3/s6/Allemand  D�butant', 'EI3/s5/ALLEMAND- GA'];
	groupesAllemand.each(function(groupe){
		$('lv2').adopt(new Element('option', {
			'value': groupe,
			'text': groupe
		}));
	});
	
	$('lienExterne').addEvent('click', function(){
		$('lienExterne').setProperty('href', genereURI(oParam));
	});
	
	oParam.ecritChamps();
	$('opt1').fireEvent('change');
	$('opt2').fireEvent('change');
	oParam.ecritChamps();
	if(oParam.cookiesExistants) $('myForm').fireEvent('submit');
});