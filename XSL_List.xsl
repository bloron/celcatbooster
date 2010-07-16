
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!--Options personnalisables-->
	<xsl:variable name="showemptydays" select="1"/>
	<!--Inclure les jours vides dans la grille ? 1=Oui 0=Non-->

	<xsl:variable name="saturday" select="0"/>
	<!--Inclure le samedi si grille du samedi vide ? 1=Oui 0=Non-->

	<xsl:variable name="sunday" select="0"/>
	<!--Inclure le dimanche si grille du dimanche vide ? 1=Oui 0=Non-->


	<xsl:variable name="nb_caracters" select="0"/>
	<!--Ajouter une ellipse si le texte de la ressource dépasse le nombre de caractères indiqués (exemple: 25). Indiquer 0 pour désactivé la fonction-->

	<xsl:variable name="show_event_title" select="0"/>
	<!--Afficher le titre des ressources dans l'événement 1=Oui 0=Non-->

	<xsl:variable name="print_empty" select="0"/>
	<!--Impression des grilles vides 1=Oui 0=Non-->

	<xsl:variable name="display_empty" select="1"/>
	<!--affichage des grilles vides 1=Oui 0=Non-->

	<xsl:variable name="default_color" select="'#FFFFCC'"/>
	<!--Couleur par defaut des événements sans catégorie d'événement-->

	<xsl:variable name="subheading" select="/timetable/option/subheading"/>

	<xsl:variable name="nb_days">
		<xsl:choose>
			<xsl:when test="$saturday = 1">
				<xsl:choose>
					<xsl:when test="$sunday = 1">
						<xsl:value-of select="7"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="6"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="5"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="r_option">
		<xsl:value-of select="substring(/timetable/option/link[1]/@href,1,1)"/>
	</xsl:variable>


	<xsl:template match="/">

		<html encoding="iso-8859-1" lang="fr">
			<head>
				<title>
					<xsl:value-of select="$subheading"/>
				</title>

				<script language="JavaScript">&lt;!--


      function loadXMLDoc(fname)
      {
      var xmlDoc;
      // code for IE
      if (window.ActiveXObject)
      {
      xmlDoc=new ActiveXObject("Microsoft.XMLDOM");
      xmlDoc.async=false;
      xmlDoc.load(fname);

      }
      // code for Mozilla, Firefox, Opera, Safari etc.
      else if (window.XMLHttpRequest)
      {

      var errorHappendHere = "Error handling XMLHttpRequest request";
      var d = new XMLHttpRequest();
      d.open("GET", fname, false);
      d.send(null);
      xmlDoc=d.responseXML;


      }
      // code for Mozilla, Firefox, Opera, etc.
      else if (document.implementation &amp;&amp; document.implementation.createDocument)
      {
      xmlDoc=document.implementation.createDocument("","",null);
      xmlDoc.async=false;
      xmlDoc.load(fname);

      }
      else
      {
      alert('Votre navigateur ne supporte pas ce script');
      }
      return(xmlDoc);
      }






      function ShowEventsList(style)
      {


					<xsl:for-each select="/timetable/option/link">
						<xsl:if test="@class='xml'">var xml=loadXMLDoc("<xsl:value-of select="@href"/>");</xsl:if>
					</xsl:for-each>if (style=='UsageChart')
      {
      var xsl=loadXMLDoc("XSL_Grid_H_Multi.xsl");
      }
      if (style=='List')
      {
      var xsl=loadXMLDoc("XSL_List.xsl");
      }
      if (style=='Grid')
      {
      var xsl=loadXMLDoc("ttss.xsl");
      }

      // code for IE
      if (window.ActiveXObject)
      {
      ex=xml.transformNode(xsl);
      document.write(ex);
      document.close();
      }
      // code for Mozilla, Firefox, Opera, etc.
      else if (document.implementation  &amp;&amp; document.implementation.createDocument)
      {
      xsltProcessor=new XSLTProcessor();
      xsltProcessor.importStylesheet(xsl);
      var resultDocument = xsltProcessor.transformToDocument(xml);
      document.write(resultDocument.documentElement.innerHTML);
      document.close();
      }
      }

      function showmenu(elmnt)
      {
      document.getElementById(elmnt).style.visibility="visible";
      }
      function hidemenu(elmnt)
      {
      document.getElementById(elmnt).style.visibility="hidden";
      }





      --&gt;</script>


				<xsl:if test="/timetable/property/*">
					<script language="JavaScript">&lt;!--
      function toggle(id, show)
      {
      var detail = document.getElementById(id + 'detail');
      var expand = document.getElementById(id + 'expand');
      var shrink = document.getElementById(id + 'shrink');
      if(detail &amp;&amp; expand &amp;&amp; shrink)
        {
        var disp = show || (detail.style.display == 'none');
        detail.style.display = disp ? 'inline' : 'none';
        expand.style.display = disp ? 'none' : 'inline';
        shrink.style.display = disp ? 'inline' : 'none';
        //if(show) window.location.replace('#' + id);
        }
      }
      function searchOnLoad()
      {
      var url = window.location.href;
      var bits = new Array();
      bits = url.split("#");
      if(bits &amp;&amp; bits[0] &amp;&amp; bits[1] &amp;&amp; bits[1].length > 0)
        toggle(bits[1], 1);
      }
      --&gt;</script>
				</xsl:if>
				<link href="webpub.css" rel="stylesheet" type="text/css"/>
			</head>

			<xsl:variable name="combined" select="/timetable/option/@combined = '1'"/>
			<xsl:variable name="totalweeks" select="/timetable/option/@totalweeks = '1'"/>
			<xsl:variable name="dayClass" select="/timetable/option/@dayclass"/>
			<xsl:variable name="termweeks" select="/timetable/option/weeks"/>
			<xsl:variable name="termweek" select="/timetable/option/week"/>
			<xsl:variable name="termdates" select="/timetable/option/dates"/>
			<xsl:variable name="termall" select="/timetable/option/all"/>
			<xsl:variable name="termnotes" select="/timetable/option/notes"/>
			<xsl:variable name="termid" select="/timetable/option/id"/>
			<xsl:variable name="termtag" select="/timetable/option/tag"/>
			<xsl:variable name="termrb">Réserver une salle</xsl:variable>
			<xsl:variable name="termrb2">Réserver la salle</xsl:variable>
			<xsl:variable name="termrberr" select="/timetable/option/rberr"/>
			<xsl:variable name="rburl" select="/timetable/option/rburl"/>
			<xsl:variable name="rbsql" select="/timetable/option/rbsql"/>
			<xsl:variable name="rbdb" select="/timetable/option/rbdb"/>
			<xsl:variable name="rbroom" select="/timetable/option/@roomid"/>

			<body id="body" class="timetable">
				<xsl:if test="/timetable/property/*">
					<xsl:attribute name="onLoad">
						<xsl:if test="not($combined)">InitialiseWeek();</xsl:if>searchOnLoad();</xsl:attribute>
				</xsl:if>
				<xsl:if test="not(/timetable/property/*)">
					<xsl:if test="not($combined)">
						<xsl:attribute name="onLoad">InitialiseWeek();</xsl:attribute>
					</xsl:if>
				</xsl:if>
				<a name="top"/>
				<h2>
					<xsl:value-of select="$subheading"/>
				</h2>
				<span class="noprint">
					<p>
						<table class="noprint">
							<tr>
								<td class="noprint_left">
									<xsl:for-each select="/timetable/option/link">
										<a target="_parent">
											<xsl:attribute name="class">
												<xsl:value-of select="@class"/>link</xsl:attribute>
											<xsl:attribute name="href">
												<xsl:value-of select="@href"/>
											</xsl:attribute>

											<!-- ************************************************************************************* 
	  Affiche directement la boite de dialogue 'Imprimer' au lieu de reprendre une fenêtre à part pour le XML -->
											<xsl:if test="@class='xml'">
												<xsl:attribute name="onClick">javascript:window.print();return false</xsl:attribute>
											</xsl:if>
											<!-- Ajout CELCAT S.A.R.L. 15/01/2009
	  *************************************************************************************** -->

											<xsl:value-of select="."/>
										</a>&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;</xsl:for-each>
									<!-- ************************************************************************************* 
              Section ajoutée pour incorporer un lien vers le fichier Icalendar équivalent de la grille.  
              Si vous utilisez l'option "Suffixe" de l'application CreateICSFile veuillez remplacer les 
              valeurs nom du fichier et lien par celles incorporant le suffixe. Si vous voulez publier
              plusieurs fichiers ICS, un pour MS Outlook et un pour Sunbird par exemple, recopier la section
              ci-dessous autant de fois que nécessaire en modifiant le nom du fichier et le nom du lien
              -->
									<xsl:for-each select="/timetable/option/link">
										<!--Si la grille contient des événements un fichier ICS est créé sinon non-->
										<xsl:if test="position() = 1 and /timetable/event">
											<xsl:variable name="icslinkFile">
												<xsl:value-of select='substring-before(@href,".")'/>
											</xsl:variable>

											<xsl:variable name="icslink">
												<a title="Télécharger votre emploi au format Icalendar">
													<xsl:attribute name="type">text/zip</xsl:attribute>

													<xsl:attribute name="href">
														<!--Création de la variable représentant le nom du fichier ICS
                        Si vous voulez ajouter un suffixe remplacez la ligne ci-dessous par la suivante
                        <xsl:value-of select='concat($icslinkFile,"_suffix.ics")'/>
                        ou suffix = votre suffixe-->
														<xsl:value-of select='concat($icslinkFile,".ics")'/>
													</xsl:attribute>
													<!--Nom du lien de téléchargement du fichier Ics sur la page Web-->ICS</a>&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;</xsl:variable>

											<xsl:copy-of select="$icslink"/>
										</xsl:if>
									</xsl:for-each>
									<!--Code ajoutée par CELCAT S.A.R.L. 21/01/2008
              ***************************************************************************************-->
								</td>

								<td class="changeview" onmouseover="showmenu('views')" onmouseout="hidemenu('views')">
									<a style="cursor:pointer; text-decoration:underline">Changer de vue</a>
									<br/>
									<table class="menu" id="views" style="position:absolute;visibility:hidden">
										<tr>
											<td class="menu">&#xA0;&#xA0;&#xA0;
												<a style="font-weight:bold" class="menu" title="Affiche ce même emploi du temps sous forme de grille" onclick="ShowEventsList('Grid')">Vue Grille</a>
											</td>
										</tr>
										<xsl:if test="not($combined) and $r_option = 'g'">
										<tr>
											<td class="menu">&#xA0;&#xA0;&#xA0;
												<a style="font-weight:bold" class="menu_item" title="Affiche ce même emploi du temps sous forme de diagramme" onclick="ShowEventsList('UsageChart')">Vue Diagramme</a>
											</td>
										</tr>
										</xsl:if>
									</table>
								</td>

								<td class="noprint_middle"/>
								<td class="noprint_right">

									<!-- *************************************************************************************
			 Section ajoutée pour incorporer un lien vers les demandes de salles, sans activer l'option dans 
			 web publisher-->
									<!-- <xsl:for-each select="/timetable/option/link">				  
               <xsl:if test='position() = 1'>
                  <xsl:variable name="RoomBooker">-->
									<!--dans la ligne suivante, veuillez spécifier l'URL vers l'acceuil du room booker-->
									<!--<a href="http://LOCALHOST:8080/roombooker" title="Effectuer une demande de réservation de salle" target="_blank" >
                      Réservation de salles
                    </a> &#160;
                  </xsl:variable>
                  <xsl:copy-of select="$RoomBooker"/>
               </xsl:if> 
              </xsl:for-each>
              Code ajoutée par CELCAT S.A.R.L. 18/02/2009
              ***************************************************************************************-->


									<xsl:for-each select="/timetable/property">
										<xsl:if test="@title">
											<h3>
												<xsl:value-of select="@title"/>
											</h3>
										</xsl:if>
										<xsl:for-each select="*">
											<xsl:variable name="property" select="name()"/>
											<xsl:variable name="title" select="title"/>
											<a target="_self">
												<xsl:attribute name="href">#<xsl:value-of select="$property"/></xsl:attribute>
												<xsl:attribute name="onclick">toggle('<xsl:value-of select="$property"/>', 1);</xsl:attribute>
												<xsl:value-of select="$title"/>
											</a>&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;</xsl:for-each>
										<xsl:if test="$rbroom">
											<a target="_self">
												<xsl:attribute name="href">javascript:rbr(<xsl:value-of select="$rbroom"/>);</xsl:attribute>
												<xsl:value-of select="$termrb2"/>
											</a>
										</xsl:if>
										<xsl:if test="@title">
											<hr/>
										</xsl:if>
									</xsl:for-each>
								</td>
								<td class="noprint_end"/>
							</tr>
						</table>
					</p>
					<xsl:if test="not($combined)">
						<script language="JavaScript">&lt;!--
          function getCookie(name, defaultValue)
            {
          	var ca = document.cookie.split(';');
          	for(var j=0;j &lt; ca.length; j++)
              {
          		var c = ca[j].indexOf(name + '=');
              if(c >= 0)
                {
                var value = ca[j].substring(c + name.length + 1, ca[j].length);
                return value;
                }
              }
    	      return defaultValue;
            }
          function setCookie(name, value)
            {
            document.cookie = name + '=' + value;
            }
          function InitialiseWeek()
            {
            var d = getCookie('week', 'all');
            if(d != 'all' &amp;&amp; d != '#' &amp;&amp; document.getElementById)
              {
              var s = document.getElementById('wkSelList');
              if(s)
                {
                var found = 0;
                for(var j=0; j &lt; s.length; j++)
                  if(('' + s.options[j].value) == d)
                    found = j;
                if(found)
                  {
                  s.selectedIndex = found;
                  WeekSelect(s);
                  }
                }
              }
            }
          function WeekSelect(s)
            {
            if(s &amp;&amp; s.options)
              {
              var d = s.options[s.selectedIndex].value;
              if(d == '#')
              {
              s.selectedIndex = 0;
              d = 'all';
             
          
              }
              if(d != '#' &amp;&amp; document.getElementById)
                {
                var sp = document.getElementById('wkList');
                if(sp) sp.style.display = (d == 'all') ? "inline" : "none";
							<xsl:for-each select="/timetable/span">
                sp = document.getElementById('span<xsl:value-of select="@id"/>');
                if(sp) sp.style.display = (d == '<xsl:value-of select="@id"/>' || d == 'all') ? "inline" : "none";
                br = document.getElementById('break<xsl:value-of select="@id"/>');
                if(br)  br.style.display = (d== 'all') ? "" : "none"; //Fix IE7 not inline but empty

              </xsl:for-each>setCookie('week', d);
               

               
                }
              }
            else
              alert('no s - ' + s);
            }
          --&gt;</script> 
						<span style="display:none" id="wkSelect">
							<h3>
								<select onChange="WeekSelect(this)" id="wkSelList">
									<option value="#">Sélection des semaines</option>
									<option value="#">---</option>
									<option value="all">Toutes les semaines</option>
									<option value="#">---</option>
									<xsl:for-each select="/timetable/span">
										<option>
											<xsl:attribute name="value">
												<xsl:value-of select="@id"/>
											</xsl:attribute>
											<xsl:value-of select="description"/>
										</option>
									</xsl:for-each>
								</select>
							</h3>		
					</span>


					<script language="JavaScript">
          &lt;!-- 
          if(document.getElementById) document.getElementById('wkSelect').style.display = "inline";
          --&gt;
          </script>
					<span id="wkList">
							<H3>
							  <br/>

								<xsl:value-of select="$termweeks"/>: &#xA0;
			<xsl:for-each select="//timetable/span">
                  <xsl:variable name="actual_week" select="@rawix"/>
                  
									<a target="_self">
										<xsl:attribute name="href">
											<xsl:text>#w</xsl:text>
											<xsl:value-of select="@id"/>
										</xsl:attribute>
                    <xsl:choose>
                      <xsl:when test ="count(//timetable/event[substring(rawweeks,$actual_week,1)='Y']) = 0">
                        <xsl:attribute name ="class">
                          <xsl:value-of select="'empty_week'"/>
                        </xsl:attribute>
                        <xsl:attribute name="title">
                          <xsl:value-of select="'Sans événement'"/>
                        </xsl:attribute>
                      </xsl:when>
                      <xsl:otherwise >
                        <xsl:attribute name ="class">
                          <xsl:value-of select="'not_empty_week'"/>
                        </xsl:attribute>
                      </xsl:otherwise>
                    </xsl:choose>

              
									<xsl:value-of select="title"/>
									</a>
									<xsl:if test="position() != last()">
										<xsl:text>, </xsl:text>
									</xsl:if>
								</xsl:for-each>
								<br/>
								<xsl:value-of select="$termdates"/>: &#xA0;
								<xsl:for-each select="//timetable/span">
                  <xsl:variable name="actual_week" select="@rawix"/>
                  
									<a target="_self">
										<xsl:attribute name="href">
											<xsl:text>#w</xsl:text>
											<xsl:value-of select="@id"/>
										</xsl:attribute>
                    <xsl:choose>
                      <xsl:when test ="count(//timetable/event[substring(rawweeks,$actual_week,1)='Y']) = 0">
                        <xsl:attribute name ="class">
                          <xsl:value-of select="'empty_week'"/>
                        </xsl:attribute>
                        <xsl:attribute name="title">
                          <xsl:value-of select="'Sans événement'"/>
                        </xsl:attribute>
                      </xsl:when>
                      <xsl:otherwise >
                        <xsl:attribute name ="class">
                          <xsl:value-of select="'not_empty_week'"/>
                        </xsl:attribute>
                      </xsl:otherwise>
                    </xsl:choose>
 
                    <xsl:value-of select="@date"/>
									</a>
									<xsl:if test="position() != last()">
										<xsl:text>, </xsl:text>
									</xsl:if>
								</xsl:for-each>
							</H3>
							<ln>&#xA0;</ln>
						</span>
					</xsl:if>
				</span>
				<br/>
				<xsl:if test="$combined">
					<span class="noprint">
						<br/>
					</span>
				</xsl:if>

				<xsl:for-each select="/timetable/span">
					<xsl:variable name="actual_week" select="@rawix"/>
					<xsl:variable name="week_nb_events" select="count(//timetable/event[substring(rawweeks,$actual_week,1)='Y'])"/>

					<xsl:if test="position() !=1">
						<xsl:choose>
							<xsl:when test="$week_nb_events = 0 and $print_empty=1">
								<div class="break" style="page-break-before:always">
									<xsl:attribute name="id">
										<xsl:value-of select="concat('break',@id)"/>
									</xsl:attribute>
									<xsl:text>&#xA0;</xsl:text>
									<!--Fix IE7 Doesn't break for empty item-->
								</div>
							</xsl:when>

							<xsl:when test="$week_nb_events = 0 and $print_empty=0">
								<xsl:text>&#xA0;</xsl:text>
							</xsl:when>

							<xsl:otherwise>
								<div class="break" style="page-break-before:always">
									<xsl:attribute name="id">
										<xsl:value-of select="concat('break',@id)"/>
									</xsl:attribute>
									<xsl:text>&#xA0;</xsl:text>
									<!--Fix IE7 Doesn't break for empty item-->
								</div>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>

					<xsl:choose>
						<xsl:when test="($week_nb_events &gt; 0) or ($week_nb_events = 0 and $display_empty =1)">
							<span>
								<xsl:attribute name="id">
									<xsl:text>span</xsl:text>
									<xsl:value-of select="@id"/>
								</xsl:attribute>
								<xsl:variable name="currSpan" select="."/>
								<a>
									<xsl:attribute name="name">
										<xsl:text>w</xsl:text>
										<xsl:value-of select="@id"/>
									</xsl:attribute>
								</a>

								<table border="1" align="center">
									<xsl:choose>
										<xsl:when test="$week_nb_events= 0 and $print_empty=0">
											<xsl:attribute name="class">
												<xsl:value-of select="'empty'"/>
											</xsl:attribute>
										</xsl:when>
										<xsl:otherwise>
											<xsl:attribute name="class">
												<xsl:value-of select="'not_empty'"/>
											</xsl:attribute>
										</xsl:otherwise>
									</xsl:choose>

									<thead>
										<xsl:if test="description !=''">
											<tr>
												<td class="span_description">
													<xsl:if test="not($combined)">
														<xsl:attribute name="colspan">
															<xsl:value-of select="3"/>
														</xsl:attribute>
														<a target="_self" href="#top">
															<xsl:value-of select="description"/>
														</a>
													</xsl:if>
													<xsl:if test="$combined">
														<xsl:attribute name="colspan">
															<xsl:value-of select="4"/>
														</xsl:attribute>
														<xsl:value-of select="description"/>
													</xsl:if>
												</td>
											</tr>
										</xsl:if>

										<tr>
											<th class="days_list">Jour</th>
											<th class="hours_list">
												<nobr>Heures</nobr>
											</th>
											<xsl:if test="$combined">
												<th class="weeks_list">
													<nobr>Semaine(s)</nobr>
												</th>
											</xsl:if>
											<th class="details_list">Détails</th>
										</tr>
									</thead>
									<tbody style="border-color:#A5BEC6">
										<xsl:for-each select="day">
											<xsl:variable name="currDay" select="."/>

											<xsl:variable name="rowCount">
												<xsl:value-of select="count(/timetable/event[($currDay/@id = day) and (contains(substring(rawweeks, $currSpan/@rawix, $currSpan/@rawlen), 'Y'))])"/>
											</xsl:variable>



											<xsl:variable name="daysEvents">
												<xsl:for-each select="/timetable/event[$currDay/@id = day and (contains(substring(rawweeks, $currSpan/@rawix, $currSpan/@rawlen), 'Y'))]">
													<xsl:variable name="currEvent" select="."/>

													<!--  				        <tbody> -->
													<tr>
														<td>
															<xsl:attribute name="class">
																<xsl:value-of select="$dayClass"/>day<xsl:value-of select="$currDay/@id"/></xsl:attribute>
															<span class="day_list">
																<xsl:value-of select="$currDay/name"/>
																<br/>
																<xsl:value-of select="$currDay/date"/>
															</span>
														</td>
														<td>
															<!--															<xsl:attribute name="bgcolor">
																<xsl:value-of select="@colour"/>
															</xsl:attribute>-->
															<xsl:value-of select="prettytimes"/>
														</td>
														<xsl:if test="$combined">
															<td width="500px">
																<!--																<xsl:attribute name="bgcolor">
																	<xsl:value-of select="@colour"/>
																</xsl:attribute>-->
																<xsl:choose>
																	<xsl:when test="$currSpan/alleventweeks = rawweeks">
																		<xsl:value-of select="$termall"/>
																	</xsl:when>
																	<xsl:when test="@date != '' and prettyweeks != ''">
																		<xsl:value-of select="prettyweeks"/>
																		<xsl:text> </xsl:text>(<xsl:value-of select="@date"/>)</xsl:when>
																	<xsl:otherwise>
																		<xsl:value-of select="prettyweeks"/>
																		<xsl:value-of select="@date"/>
																	</xsl:otherwise>
																</xsl:choose>
																<xsl:if test="$totalweeks">
																	<xsl:text> </xsl:text>[=<xsl:value-of select="string-length(translate(rawweeks,'N',''))"/>]</xsl:if>
															</td>
														</xsl:if>
														<td>
					<xsl:attribute name="style">
					<xsl:choose>
						<xsl:when test="@colour = '#FFFFFF'">	
							<xsl:value-of select="concat('background-color:',$default_color)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat('background-color:',@colour)"/>
						</xsl:otherwise>
					</xsl:choose>
					</xsl:attribute>
															<a>
																<xsl:attribute name="name">
																	<xsl:text>ev</xsl:text>
																	<xsl:value-of select="@id"/>
																</xsl:attribute>
															</a>
															<table>
																<xsl:for-each select="resources/*">
																	<tr>
																		<xsl:if test="@title">
																			<td valign="top" width="100px">
																				<b>
																					<xsl:value-of select="@title"/>
																					<xsl:text> : </xsl:text>
																				</b>
																			</td>
																		</xsl:if>
																		<td>
																			<xsl:for-each select="item">
																				<nobr>
																					<xsl:if test="a">
																						<a target="_parent">
																							<xsl:attribute name="href">
																								<xsl:value-of select="a/@href"/>
																							</xsl:attribute>
																							<xsl:copy-of select="a/*|a/text()"/>
																						</a>

																						<xsl:if test="text()!=''">
																							<xsl:value-of select="concat(' ', text())"/>
																						</xsl:if>

																						<xsl:if test="position() != last()">
																							<xsl:text>; </xsl:text>
																						</xsl:if>
																					</xsl:if>

																					<xsl:if test="not(a)">
																						<xsl:value-of select="."/>
																						<xsl:if test="position() != last()">
																							<xsl:text>; </xsl:text>
																						</xsl:if>
																					</xsl:if>
																				</nobr>
																			</xsl:for-each>
																		</td>
																	</tr>
																</xsl:for-each>

																<xsl:if test="($rburl) and not(resources/room)">
																	<tr>
																		<b>
																			<img src="roomreq.gif" border="0"/>
																			<a target="_self">

																				<xsl:attribute name="title">
																					<xsl:value-of select="$termrb"/>
																				</xsl:attribute>
																				<xsl:attribute name="alt">
																					<xsl:value-of select="$termrb"/>
																				</xsl:attribute>
																				<xsl:attribute name="xonClick">rbe(<xsl:value-of select="$currEvent/@id"/>);</xsl:attribute>
																				<xsl:attribute name="href">javascript:rbe(<xsl:value-of select="$currEvent/@id"/>);</xsl:attribute>

																				<nobr>

																					<xsl:value-of select="$termrb"/>
																				</nobr>
																			</a>
																		</b>
																	</tr>
																</xsl:if>

																<xsl:if test="id != ''">
																	<tr>
																		<td valign="top">
																			<b>
																				<i>
																					<xsl:value-of select="$termid"/>:</i>
																			</b>
																		</td>
																		<td>
																			<i>
																				<xsl:for-each select="id">
																					<xsl:copy-of select="."/>
																					<xsl:if test="position() != last()">
																						<xsl:text>; </xsl:text>
																					</xsl:if>
																				</xsl:for-each>
																			</i>
																		</td>
																	</tr>
																</xsl:if>

																<xsl:if test="tag != ''">
																	<tr>
																		<td valign="top">
																			<b>
																				<i>
																					<xsl:value-of select="$termtag"/>:</i>
																			</b>
																		</td>
																		<td>
																			<i>
																				<xsl:for-each select="tag">
																					<xsl:copy-of select="."/>
																					<xsl:if test="position() != last()">
																						<xsl:text>; </xsl:text>
																					</xsl:if>
																				</xsl:for-each>
																			</i>
																		</td>
																	</tr>
																</xsl:if>

																<xsl:if test="notes != ''">
																	<tr>
																		<td valign="top">
																			<b>
																				<i>
																					<xsl:value-of select="$termnotes"/>:</i>
																			</b>
																		</td>
																		<td>
																			<i>
																				<xsl:copy-of select="notes"/>
																			</i>
																		</td>
																	</tr>
																</xsl:if>
															</table>
														</td>
													</tr>
												</xsl:for-each>
											</xsl:variable>

											<!-- Inserer le tri sur le jours -->
											<xsl:choose>

												<xsl:when test="@id &lt; $nb_days">

													<xsl:choose>
														<xsl:when test="$rowCount = 0 and $showemptydays=1">
															<tr>
																<td>
																	<xsl:attribute name="class">
																		<xsl:value-of select="$dayClass"/>day<xsl:value-of select="$currDay/@id"/></xsl:attribute>
																	<span class="day_list">
																		<xsl:value-of select="$currDay/name"/>
																		<br/>
																		<xsl:value-of select="$currDay/date"/>
																	</span>
																</td>
																<td>&#xA0;</td>
																<xsl:if test="$combined">
																	<td>&#xA0;</td>
																</xsl:if>
																<td>&#xA0;</td>
															</tr>
														</xsl:when>
														<xsl:otherwise>
															<xsl:copy-of select="$daysEvents"/>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:when>

												<xsl:otherwise>
													<xsl:choose>
														<xsl:when test="$rowCount &gt; 0">
															<xsl:copy-of select="$daysEvents"/>
														</xsl:when>
														<xsl:otherwise>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:for-each>
									</tbody>
								</table>
								<br/>
							</span>
						</xsl:when>
						<xsl:otherwise>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>


				<!--Footer CELCAT-->

				<xsl:for-each select="/timetable/property">
					<xsl:if test="@title">
						<h3>
							<xsl:value-of select="@title"/>
						</h3>
					</xsl:if>
					<xsl:for-each select="*">
						<xsl:variable name="property" select="name()"/>
						<xsl:variable name="title" select="title"/>
						<xsl:variable name="attribute" select="attribute"/>
						<xsl:variable name="href" select="@href"/>
						<table class="toggleouter">
							<tr>
								<td>
									<span>
										<xsl:attribute name="onclick">toggle('<xsl:value-of select="$property"/>');</xsl:attribute>
										<a>
											<xsl:attribute name="name">
												<xsl:value-of select="$property"/>
											</xsl:attribute>
											<img src="expand.gif">
												<xsl:attribute name="id">
													<xsl:value-of select="$property"/>expand</xsl:attribute>
											</img>
											<img src="shrink.gif" style="display:none">
												<xsl:attribute name="id">
													<xsl:value-of select="$property"/>shrink</xsl:attribute>
											</img>
										</a>
										<xsl:if test="item">
											<a target="_self">
												<xsl:attribute name="href">#<xsl:value-of select="$property"/></xsl:attribute>
												<xsl:value-of select="$title"/>(<xsl:value-of select="count(item)"/>)</a>
										</xsl:if>
										<xsl:if test="not(item)">
											<xsl:if test="$href">
												<a target="_parent">
													<xsl:attribute name="href">
														<xsl:value-of select="$href"/>
													</xsl:attribute>
													<xsl:value-of select="$title"/>
												</a>(0)</xsl:if>
											<xsl:if test="not($href)">
												<xsl:value-of select="$title"/>(0)</xsl:if>
										</xsl:if>
									</span>
									<span class="noprint">&#xA0; <a target="_self" class="toplink" href="#top">^</a></span>
								</td>
							</tr>
							<tr>
								<td>
									<div style="display:none">
										<xsl:attribute name="id">
											<xsl:value-of select="$property"/>detail</xsl:attribute>
										<table class="toggleinner" border="0" cellpadding="0" cellspacing="0" width="100%">
											<xsl:for-each select="item">
												<tr>
													<td width="24px" align="center">
														<xsl:if test="position() != last()">
															<img src="link.gif"/>
														</xsl:if>
														<xsl:if test="position() = last()">
															<img src="lastlink.gif"/>
														</xsl:if>
													</td>
													<td>

														<!-- FF3bugfix 				        <xsl:copy-of select="."/> -->
														<xsl:if test="a">
															<a target="_parent">
																<xsl:attribute name="href">
																	<xsl:value-of select="a/@href"/>
																</xsl:attribute>
																<xsl:copy-of select="a/*|a/text()"/>
															</a>
														</xsl:if>
														<xsl:if test="not(a)">
															<xsl:value-of select="."/>
														</xsl:if>
														<xsl:if test="@attribute">(<xsl:value-of select="$attribute"/><xsl:text> </xsl:text><xsl:value-of select="@attribute"/>)</xsl:if>
														<xsl:if test="(@id) and ($rburl)">
															<a target="_self">
																<xsl:attribute name="href">javascript:rbi('<xsl:value-of select="$property"/>','<xsl:value-of select="@id"/>:<xsl:value-of select="@attribute"/>');</xsl:attribute>
																<img src="roomreq.gif" border="0">
																	<xsl:attribute name="xonClick">rbi('<xsl:value-of select="$property"/>','<xsl:value-of select="@id"/>:<xsl:value-of select="@attribute"/>');</xsl:attribute>
																	<xsl:attribute name="title">
																		<xsl:value-of select="$termrb"/>
																	</xsl:attribute>
																	<xsl:attribute name="alt">
																		<xsl:value-of select="$termrb"/>
																	</xsl:attribute>
																</img>
															</a>
														</xsl:if>
													</td>
												</tr>
											</xsl:for-each>
										</table>
									</div>
								</td>
							</tr>
						</table>
					</xsl:for-each>
					<br class="noprint"/>
					<xsl:if test="@title">
						<hr/>
					</xsl:if>
				</xsl:for-each>

				<h3>
					<xsl:copy-of select="/timetable/option/footer"/>
				</h3>

				<xsl:if test="$rburl">
					<script language="JavaScript">&lt;!--
      var rbifurl;
      function rbe(evid) { rb('&amp;event_id=' + evid); }
      function rbr(room) { rb('&amp;room_id=' + room); }
      function rbi(prop, id) { rb('&amp;' + prop + '_id=' + id); }
      function rb(param)
      {
      var rbif = document.getElementById('rbhidden');
      if(rbif)
        {
        var img = new Image();
        img.onerror = function (evt) { alert("<xsl:value-of select="$termrberr"/>"); }
        //img.onload = function (evt) { rburl(); }
        img.src = '<xsl:value-of select="$rburl"/>files/images/logoRB.gif';
        //rbifurl = '<xsl:value-of select="$rburl"/>files/rbLoader.html?agent=WebPub&amp;sqlserver='+encodeURIComponent('<xsl:value-of select="$rbsql"/>')+'&amp;db='+encodeURIComponent('<xsl:value-of select="$rbdb"/>')+param;
        rbif.src = '<xsl:value-of select="$rburl"/>files/rbLoader.html?agent=WebPub&amp;sqlserver='+encodeURIComponent('<xsl:value-of select="$rbsql"/>')+'&amp;db='+encodeURIComponent('<xsl:value-of select="$rbdb"/>')+param;
        }
      }
      function rburl()
      {
      var rbif = document.getElementById('rbhidden');
      if(rbif)
        rbif.src = rbifurl;
      }
      --&gt;</script>
					<IFRAME id="rbhidden" style="display:none"></IFRAME>
				</xsl:if>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet><!-- Stylus Studio meta-information - (c) 2004-2008. Progress Software Corporation. All rights reserved.

<metaInformation>
	<scenarios>
		<scenario default="yes" name="Scenario1" userelativepaths="yes" externalpreview="no" url="g47.xml" htmlbaseurl="" outputurl="" processortype="saxon8" useresolver="yes" profilemode="0" profiledepth="" profilelength="" urlprofilexml="" commandline=""
		          additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext="" validateoutput="no" validator="internal" customvalidator="">
			<advancedProp name="sInitialMode" value=""/>
			<advancedProp name="bXsltOneIsOkay" value="true"/>
			<advancedProp name="bSchemaAware" value="true"/>
			<advancedProp name="bXml11" value="false"/>
			<advancedProp name="iValidation" value="0"/>
			<advancedProp name="bExtensions" value="true"/>
			<advancedProp name="iWhitespace" value="0"/>
			<advancedProp name="sInitialTemplate" value=""/>
			<advancedProp name="bTinyTree" value="true"/>
			<advancedProp name="bWarnings" value="true"/>
			<advancedProp name="bUseDTD" value="false"/>
			<advancedProp name="iErrorHandling" value="fatal"/>
		</scenario>
	</scenarios>
	<MapperMetaTag>
		<MapperInfo srcSchemaPathIsRelative="yes" srcSchemaInterpretAsXML="no" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" destSchemaInterpretAsXML="no"/>
		<MapperBlockPosition></MapperBlockPosition>
		<TemplateContext></TemplateContext>
		<MapperFilter side="source"></MapperFilter>
	</MapperMetaTag>
</metaInformation>
-->