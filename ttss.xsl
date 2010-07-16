<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

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

	<xsl:variable name="time_unit" select="5"/>
	<!--Granularité de la grille-->

	<xsl:variable name="no_periods" select="count($Grid/day/time/starttime)"/>
	<xsl:variable name="mod_num_periods" select="number(100 mod $no_periods)"/>
	<xsl:variable name="num_periods" select="number((100 - $mod_num_periods) div $no_periods)"/>
	<!--Largeur en % des plages horaires-->

	<xsl:variable name="default_color" select="'#FFFFCC'"/>
 	<!--Couleur par defaut des événements sans catégorie d'événement-->

	<!--Options par defaut-->

	<xsl:variable name="Grid" select="document('grid3.xml')/grid"/>
	<!--Fichier externe de paramétrage de la grille-->
	<xsl:variable name="subheading" select="/timetable/option/subheading"/>
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

	<!--Heure de début de la grille-->
	<xsl:variable name="firststart">
		<xsl:for-each select="$Grid/day/time">
			<xsl:if test="position()=1">
				<xsl:value-of select="starttime"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:variable>

	<!--Heure de fin de la grille-->
	<xsl:variable name="lastend">
		<xsl:for-each select="$Grid/day/time">
			<xsl:if test="position()=last()">
				<xsl:value-of select="endtime"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:variable>

	<!--Durée d'une journée en minutes-->
	<xsl:variable name="day_duration">
		<xsl:call-template name="get_duration">
			<xsl:with-param name="starttime" select="$firststart"/>
			<xsl:with-param name="endtime" select="$lastend"/>
		</xsl:call-template>
	</xsl:variable>

	<!--Heure de début d'une journée en minutes-->
	<xsl:variable name="day_start">
		<xsl:call-template name="get_timevalue">
			<xsl:with-param name="value" select="$firststart"/>
		</xsl:call-template>
	</xsl:variable>

	<!--Heure de fin d'une journée en minutes-->
	<xsl:variable name="day_end">
		<xsl:call-template name="get_timevalue">
			<xsl:with-param name="value" select="$lastend"/>
		</xsl:call-template>
	</xsl:variable>

	<!--Nombre de jour qu'on souhaite afficher en tenant compte ou non du weekend. Fonctionne avec variable globale $showemptydays.-->
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

		<html>
			<head>
				<link href="webpub.css" rel="stylesheet" type="text/css"/>
				<style type="text/css">

					<!--Indiquez vos valeurs CSS pour écraser celles de WebPub.css-->
				</style>

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
      if(bits &amp;&amp; bits[0] &amp;&amp; bits[1] &amp;&amp; bits[1].length &gt; 0)
        toggle(bits[1], 1);
      }
      
      
         
      --&gt;</script>
				</xsl:if>
			</head>

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
										</a>     </xsl:for-each>



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
												<xsl:value-of select="substring-before(@href,&quot;.&quot;)"/>
											</xsl:variable>

											<xsl:variable name="icslink">
												<a title="Télécharger votre emploi au format Icalendar">
													<xsl:attribute name="type">text/ical</xsl:attribute>

													<xsl:attribute name="href">
														<!--Création de la variable représentant le nom du fichier ICS
                        Si vous voulez ajouter un suffixe remplacez la ligne ci-dessous par la suivante
                        <xsl:value-of select='concat($icslinkFile,"_suffix.ics")'/>
                        ou suffix = votre suffixe-->
														<xsl:value-of select="concat($icslinkFile,&quot;.ics&quot;)"/>
													</xsl:attribute>
													<!--Nom du lien de téléchargement du fichier Ics sur la page Web-->ICS</a>     </xsl:variable>

											<xsl:copy-of select="$icslink"/>
										</xsl:if>
									</xsl:for-each>
									<!--Code ajoutée par CELCAT S.A.R.L. 21/01/2008
              ***************************************************************************************-->
								</td>
								<xsl:if test="$r_option = 'm' or $r_option = 'g' or $r_option = 'r' or $r_option = 't' or $r_option = 's' or $r_option = 'e' or $r_option = 'p' or $r_option = 'g' or $r_option = 'c'">
									<td class="changeview" onmouseover="showmenu('views')" onmouseout="hidemenu('views')">
										<a style="cursor:pointer; text-decoration:underline">Changer de vue</a>
										<br/>
										<table class="menu" id="views" style="position:absolute;visibility:hidden">
											<tr>
												<td class="menu">   
													<a style="font-weight:bold" class="menu_item" title="Affiche ce même emploi du temps sous forme de liste" onclick="ShowEventsList('List')">Vue Liste</a>
												</td>
											</tr>
											<xsl:if test="not($combined) and $r_option = 'g'">
												<tr>
													<td class="menu">   
														<a style="font-weight:bold" class="menu_item" title="Affiche ce même emploi du temps sous forme de diagramme" onclick="ShowEventsList('UsageChart')">Vue Diagramme</a>
													</td>
												</tr>
											</xsl:if>
										</table>
									</td>
								</xsl:if>

								<td class="noprint_middle"/>
								<td class="noprint_right">


									<!-- *************************************************************************************
			 Section ajoutée pour incorporer un lien vers les demandes de salles, sans activer l'option dans 
			 web publisher-->


									<!--<xsl:variable name="RoomBooker">
                        -->
									<!--dans la ligne suivante, veuillez spécifier l'URL vers l'acceuil du room booker-->
									<!--
                        <a class="noprint_right" href="http://LOCALHOST:8080/roombooker" title="Effectuer une demande de réservation de salle" target="_blank" >
                          <img class="noprint_right" src="roomreq.gif"/>
                          Réservation de salles
                        </a> 
                      </xsl:variable>
                      <xsl:copy-of select="$RoomBooker"/>-->


									<!--Code ajoutée par CELCAT S.A.R.L. 18/02/2009
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
											<a class="noprint_right">
												<xsl:attribute name="href">#<xsl:value-of select="$property"/></xsl:attribute>
												<xsl:attribute name="onclick">toggle('<xsl:value-of select="$property"/>', 1);</xsl:attribute>
												<xsl:value-of select="$title"/>
											</a>     </xsl:for-each>
										<xsl:if test="$rbroom">

											<a class="noprint_right">
												<xsl:attribute name="href">javascript:rbr(<xsl:value-of select="$rbroom"/>);</xsl:attribute>
												<img class="noprint_right" src="roomreq.gif">
													<xsl:attribute name="alt">
														<xsl:value-of select="$termrb2"/>
													</xsl:attribute>
													<xsl:attribute name="xonClick">rbe(<xsl:value-of select="$rbroom"/>);</xsl:attribute>
												</img>
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
              if(c &gt;= 0)
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

								<xsl:value-of select="$termweeks"/>:  
			<xsl:for-each select="//timetable/span">
                  <xsl:variable name="actual_week" select="@rawix"/>
                  
									<a target="_self">
										<xsl:attribute name="href">
											<xsl:text>#w</xsl:text>
											<xsl:value-of select="@id"/>
										</xsl:attribute>
                    <xsl:choose>
                      <xsl:when test="count(//timetable/event[substring(rawweeks,$actual_week,1)='Y']) = 0">
                        <xsl:attribute name="class">
                          <xsl:value-of select="'empty_week'"/>
                        </xsl:attribute>
                        <xsl:attribute name="title">
                          <xsl:value-of select="'Sans événement'"/>
                        </xsl:attribute>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:attribute name="class">
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
								<xsl:value-of select="$termdates"/>:  
								<xsl:for-each select="//timetable/span">
                  <xsl:variable name="actual_week" select="@rawix"/>
                  
									<a target="_self">
										<xsl:attribute name="href">
											<xsl:text>#w</xsl:text>
											<xsl:value-of select="@id"/>
										</xsl:attribute>
                    <xsl:choose>
                      <xsl:when test="count(//timetable/event[substring(rawweeks,$actual_week,1)='Y']) = 0">
                        <xsl:attribute name="class">
                          <xsl:value-of select="'empty_week'"/>
                        </xsl:attribute>
                        <xsl:attribute name="title">
                          <xsl:value-of select="'Sans événement'"/>
                        </xsl:attribute>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:attribute name="class">
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
							<ln> </ln>
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
					<xsl:variable name="span_date" select="@date"/>
					<xsl:variable name="week_nb_events" select="count(//timetable/event[substring(rawweeks,$actual_week,1)='Y'])"/>

					<xsl:if test="position() !=1">
						<xsl:choose>
							<xsl:when test="$week_nb_events = 0 and $print_empty=1">
								<div class="break" style="page-break-before:always">
									<xsl:attribute name="id">
										<xsl:value-of select="concat('break',@id)"/>
									</xsl:attribute>
									<xsl:text> </xsl:text>
									<!--Fix IE7 Doesn't break for empty item-->
								</div>
							</xsl:when>

							<xsl:when test="$week_nb_events = 0 and $print_empty=0">
								<xsl:text> </xsl:text>
							</xsl:when>

							<xsl:otherwise>
								<div class="break" style="page-break-before:always">
									<xsl:attribute name="id">
										<xsl:value-of select="concat('break',@id)"/>
									</xsl:attribute>
									<xsl:text> </xsl:text>
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

								<table align="center">
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


									<!--Première ligne pour définir les limites de la table-->
									<tr>
										<!--Création de la première case vide de la première ligne-->
										<th/>

										<!--Création des colonnes de la table-->
										<xsl:call-template name="for.loop_timeslot">
											<xsl:with-param name="i" select="1"/>
											<xsl:with-param name="count" select="ceiling(number($day_duration div $time_unit))"/>
										</xsl:call-template>
									</tr>

									<xsl:if test="description != '' ">
										<tr>
											<td class="span_description">
												<xsl:attribute name="colspan">
													<xsl:value-of select="1 + ceiling(number($day_duration div $time_unit))"/>
												</xsl:attribute>

												<xsl:if test="not($combined)">
													<a target="_self" href="#top">
														<xsl:value-of select="description"/>
													</a>
												</xsl:if>
												<xsl:if test="$combined">
													<xsl:value-of select="description"/>
												</xsl:if>
											</td>
										</tr>
									</xsl:if>


									<!--Création de la ligne des heures-->
									<tr>
										<th class="times_days"/>

										<xsl:for-each select="$Grid/day/time">
											<xsl:variable name="timeslot_duration">
												<xsl:call-template name="get_duration">
													<xsl:with-param name="starttime" select="starttime"/>
													<xsl:with-param name="endtime" select="endtime"/>
												</xsl:call-template>
											</xsl:variable>


											<th class="times">
												<xsl:attribute name="colspan">
													<xsl:value-of select="ceiling(number($timeslot_duration div $time_unit))"/>
												</xsl:attribute>
												<xsl:attribute name="width">
													<xsl:value-of select="concat ($num_periods, '%')"/>
												</xsl:attribute>

												<xsl:value-of select="concat (starttime, ' - ' , endtime)"/>
											</th>
										</xsl:for-each>
									</tr>


									<!--Début de l'itération pour le placement des événements par jour-->
									<xsl:for-each select="day">
										<xsl:variable name="actual_day" select="@id"/>
										<xsl:variable name="events_node" select="//timetable/event[day=$actual_day and substring(rawweeks,$actual_week,1)='Y']"/>
										<xsl:variable name="nb_events" select="count($events_node)"/>

										<!--Si des événements pour cette journée alors on lance le placement. Si non on regarde si on imprime les jours vides-->
										<xsl:choose>
											<xsl:when test="$nb_events &gt; 0">

												<!--Crée une chaine référençant toutes les heures de début des événements de cette journée-->
												<xsl:variable name="startstr">
													<xsl:for-each select="$events_node">
														<xsl:sort select="starttime"/>
														<xsl:sort select="endtime"/>

														<xsl:variable name="time">
															<xsl:call-template name="get_timevalue">
																<xsl:with-param name="value" select="starttime"/>
															</xsl:call-template>
														</xsl:variable>
														<!--On rajoute des 0000 pour s'assurer que les nombres soient enregistrés sous forme de strings tous de la même longueur-->
														<xsl:value-of select="concat(substring(concat('0000',$time),string-length(concat('0000',$time))-4,5),',')"/>
													</xsl:for-each>
												</xsl:variable>

												<!--Crée une chaine référençant toutes les heures de fin des événements de cette journée-->
												<xsl:variable name="endstr">
													<xsl:for-each select="$events_node">
														<xsl:sort select="starttime"/>
														<xsl:sort select="endtime"/>

														<xsl:variable name="time">
															<xsl:call-template name="get_timevalue">
																<xsl:with-param name="value" select="endtime"/>
															</xsl:call-template>
														</xsl:variable>
														<!--On rajoute des 0000 pour s'assurer que les nombres soient enregistrés sous forme de strings tous de la même longueur-->
														<xsl:value-of select="concat(substring(concat('0000',$time),string-length(concat('0000',$time))-4,5),',')"/>
													</xsl:for-each>
												</xsl:variable>


												<!--Crée une chaîne avec le niveau de superposition (la ligne) de chaque événement-->
												<xsl:variable name="myindexes">
													<xsl:call-template name="indexes_string3">
														<xsl:with-param name="last_position" select="1"/>
														<xsl:with-param name="startstr" select="$startstr"/>
														<xsl:with-param name="endstr" select="$endstr"/>
														<xsl:with-param name="result"/>
														<xsl:with-param name="max" select="$nb_events"/>
													</xsl:call-template>
												</xsl:variable>

												<!--Crée une chaîne avec les temps vides avant chaque événement-->
												<xsl:variable name="before_durations">
													<xsl:call-template name="get_before_duration_string">
														<xsl:with-param name="startstr" select="$startstr"/>
														<xsl:with-param name="endstr" select="$endstr"/>
														<xsl:with-param name="max" select="$nb_events"/>
														<xsl:with-param name="day_start" select="$day_start"/>
														<xsl:with-param name="last_position" select="1"/>
														<xsl:with-param name="indexes_string" select="$myindexes"/>
														<xsl:with-param name="result"/>
													</xsl:call-template>
												</xsl:variable>


												<!--Crée une chaîne avec les durées de chaque événement-->
												<xsl:variable name="event_durations">
													<xsl:call-template name="get_event_duration_string">
														<xsl:with-param name="startstr" select="$startstr"/>
														<xsl:with-param name="max" select="$nb_events"/>
														<xsl:with-param name="endstr" select="$endstr"/>
														<xsl:with-param name="last_position" select="1"/>
														<xsl:with-param name="result"/>
													</xsl:call-template>
												</xsl:variable>

												<!--Indique le nombre maximum de superposition dans une journée-->
												<xsl:variable name="max_rows">
													<xsl:call-template name="get_max">
														<xsl:with-param name="instr" select="$myindexes"/>
														<xsl:with-param name="last_position" select="1"/>
														<xsl:with-param name="count" select="$nb_events"/>
														<xsl:with-param name="max" select="0"/>
													</xsl:call-template>
												</xsl:variable>

												<!--Crée une chaîne avec les heures de début de chaque colonne heures-->
												<xsl:variable name="timeslots_string">
													<xsl:for-each select="$Grid/day/time">
														<xsl:value-of select="concat(starttime,',')"/>
													</xsl:for-each>
												</xsl:variable>

												<!--Lance le placement des événements-->
												<xsl:call-template name="events">
													<xsl:with-param name="last_position" select="1"/>
													<xsl:with-param name="max" select="$max_rows"/>
													<xsl:with-param name="actual_week" select="$actual_week"/>
													<xsl:with-param name="actual_day" select="$actual_day"/>
													<xsl:with-param name="day_duration" select="$day_duration"/>
													<xsl:with-param name="day_start" select="$day_start"/>
													<xsl:with-param name="indexes_string" select="$myindexes"/>
													<xsl:with-param name="before_durations" select="$before_durations"/>
													<xsl:with-param name="event_durations" select="$event_durations"/>
													<xsl:with-param name="timeslots_string" select="$timeslots_string"/>
													<xsl:with-param name="endstr" select="$endstr"/>
													<xsl:with-param name="span_date" select="$span_date"/>
													<xsl:with-param name="events_node" select="$events_node"/>
												</xsl:call-template>
											</xsl:when>

											<xsl:otherwise>
												<!--La journée est vide. $showemptydays nous dit quoi faire-->
												<xsl:if test="$showemptydays = 1 and @id &lt; $nb_days">
													<tr>
														<td class="days">
															<!--<xsl:attribute name="width">
																<xsl:value-of select="concat ($num_periods , '%')"/>
															</xsl:attribute>-->
															<xsl:value-of select="name"/>
															<br/>

															<xsl:choose>
																<xsl:when test="date != ''">
																	<xsl:value-of select="date"/>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:variable name="day" select="substring($span_date,1,2)"/>
																	<xsl:variable name="month" select="substring($span_date,4,2)"/>
																	<xsl:variable name="year" select="substring($span_date,string-length($span_date)-1,2)"/>

																	<xsl:call-template name="get_date">
																		<xsl:with-param name="day" select="$day"/>
																		<xsl:with-param name="month" select="$month"/>
																		<xsl:with-param name="year" select="$year"/>
																		<xsl:with-param name="dayid" select="$actual_day"/>
																	</xsl:call-template>
																</xsl:otherwise>
															</xsl:choose>
														</td>

														<xsl:for-each select="$Grid/day/time">
															<xsl:variable name="timeslot_duration" select="number(60 *number(substring-before(endtime , ':')) + number(substring-after(endtime, ':')))-number(60 *number(substring-before(starttime , ':')) + number(substring-after(starttime, ':')))"/>

															<td class="time_limits">
																<xsl:attribute name="colspan">
																	<xsl:value-of select="ceiling(number($timeslot_duration div $time_unit))"/>
																</xsl:attribute>
															</td>
														</xsl:for-each>
													</tr>
												</xsl:if>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:for-each>
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
									<span class="noprint">  <a target="_self" class="toplink" href="#top">^</a></span>
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
					<IFRAME id="rbhidden" style="display:none"/>
				</xsl:if>
			</body>
		</html>
	</xsl:template>


	<!-- indexes_string : crée une chaine avec le numéro de ligne pour chaque événement-->
	<xsl:template name="indexes_string3">
		<xsl:param name="last_position"/>
		<xsl:param name="startstr"/>
		<xsl:param name="endstr"/>
		<xsl:param name="result"/>
		<xsl:param name="max"/>
		<xsl:param name="overlay"/>

		<xsl:if test="$last_position &lt;= $max">

			<xsl:if test="$last_position = 1">

				<xsl:call-template name="indexes_string3">
					<xsl:with-param name="last_position" select="$last_position + 1"/>
					<xsl:with-param name="startstr" select="$startstr"/>
					<xsl:with-param name="endstr" select="$endstr"/>
					<xsl:with-param name="result" select="'001'"/>
					<xsl:with-param name="max" select="$max"/>
					<xsl:with-param name="overlay" select="1"/>
				</xsl:call-template>
			</xsl:if>

			<xsl:if test="$last_position &gt; 1">

				<xsl:variable name="previous_index_end" select="substring($endstr,1 + ($last_position - 2) * 6,5)"/>


				<xsl:variable name="current_start" select="substring($startstr,1 + ($last_position - 1) * 6,5)"/>

				<xsl:choose>
					<xsl:when test="$current_start &lt; $previous_index_end">
						<xsl:variable name="new_overlay">
							<xsl:call-template name="loop_through_suboverlays">
								<xsl:with-param name="overlay" select="$overlay"/>
								<xsl:with-param name="indexes_string" select="$result"/>
								<xsl:with-param name="current_start" select="$current_start"/>
								<xsl:with-param name="endstr" select="$endstr"/>
								<xsl:with-param name="last_position" select="$last_position"/>
							</xsl:call-template>
						</xsl:variable>

						<xsl:if test="$new_overlay = 0">
							<xsl:variable name="value_to_pass" select="concat('00',$overlay + 1)"/>
							<xsl:call-template name="indexes_string3">
								<xsl:with-param name="last_position" select="$last_position + 1"/>
								<xsl:with-param name="startstr" select="$startstr"/>
								<xsl:with-param name="endstr" select="$endstr"/>
								<xsl:with-param name="result" select="concat($result,',',substring($value_to_pass,string-length($value_to_pass)-2,3))"/>
								<xsl:with-param name="max" select="$max"/>
								<xsl:with-param name="overlay" select="$overlay + 1"/>
							</xsl:call-template>
						</xsl:if>

						<xsl:if test="$new_overlay &gt; 0">
							<xsl:variable name="value_to_pass" select="concat('00',$new_overlay)"/>
							<xsl:call-template name="indexes_string3">
								<xsl:with-param name="last_position" select="$last_position + 1"/>
								<xsl:with-param name="startstr" select="$startstr"/>
								<xsl:with-param name="endstr" select="$endstr"/>
								<xsl:with-param name="result" select="concat($result,',',substring($value_to_pass,string-length($value_to_pass)-2,3))"/>
								<xsl:with-param name="max" select="$max"/>
								<xsl:with-param name="overlay" select="$overlay"/>
							</xsl:call-template>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="new_overlay">
							<xsl:call-template name="loop_through_suboverlays">
								<xsl:with-param name="overlay" select="$overlay"/>
								<xsl:with-param name="indexes_string" select="$result"/>
								<xsl:with-param name="current_start" select="$current_start"/>
								<xsl:with-param name="endstr" select="$endstr"/>
								<xsl:with-param name="last_position" select="$last_position"/>
							</xsl:call-template>
						</xsl:variable>

						<xsl:if test="$new_overlay = 0">
							<xsl:variable name="value_to_pass" select="concat('00',$overlay)"/>
							<xsl:call-template name="indexes_string3">
								<xsl:with-param name="last_position" select="$last_position + 1"/>
								<xsl:with-param name="startstr" select="$startstr"/>
								<xsl:with-param name="endstr" select="$endstr"/>
								<xsl:with-param name="result" select="concat($result,',',substring($value_to_pass,string-length($value_to_pass)-2,3) )"/>
								<xsl:with-param name="max" select="$max"/>
								<xsl:with-param name="overlay" select="$overlay "/>
							</xsl:call-template>
						</xsl:if>

						<xsl:if test="$new_overlay &gt; 0">
							<xsl:variable name="value_to_pass" select="concat('00',$new_overlay)"/>
							<xsl:call-template name="indexes_string3">
								<xsl:with-param name="last_position" select="$last_position + 1"/>
								<xsl:with-param name="startstr" select="$startstr"/>
								<xsl:with-param name="endstr" select="$endstr"/>
								<xsl:with-param name="result" select="concat($result,',',substring($value_to_pass,string-length($value_to_pass)-2,3))"/>
								<xsl:with-param name="max" select="$max"/>
								<xsl:with-param name="overlay" select="$overlay"/>
							</xsl:call-template>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:if>


		<xsl:if test="$last_position &gt; $max ">
			<xsl:value-of select="$result"/>
		</xsl:if>
	</xsl:template>

	<!-- loop_through_suboverlays: Cherche si on ne peut pas placer l'événement dans une ligne de niveau inférieure. 0 si Non >= 1 si Oui-->
	<xsl:template name="loop_through_suboverlays">
		<xsl:param name="overlay"/>
		<xsl:param name="indexes_string"/>
		<xsl:param name="current_start"/>
		<xsl:param name="endstr"/>
		<xsl:param name="last_position"/>

		<xsl:if test=" $overlay &gt;= 1 ">



			<xsl:variable name="previous_event_in_overlay">
				<xsl:call-template name="get_eventpos_in_indexes_string">
					<xsl:with-param name="overlay" select="$overlay"/>
					<xsl:with-param name="indexes_string" select="$indexes_string"/>
					<xsl:with-param name="current_event_pos" select="$last_position"/>
					<xsl:with-param name="i" select="1"/>
					<xsl:with-param name="result" select="0"/>
				</xsl:call-template>
			</xsl:variable>

			<xsl:if test="$previous_event_in_overlay &gt; 0">



				<xsl:variable name="previous_index_end" select="substring($endstr,1 + ($previous_event_in_overlay - 1) * 6,5)"/>


				<xsl:choose>
					<xsl:when test="$current_start &lt; $previous_index_end">


						<xsl:call-template name="loop_through_suboverlays">
							<xsl:with-param name="overlay" select="$overlay - 1"/>
							<xsl:with-param name="indexes_string" select="$indexes_string"/>
							<xsl:with-param name="current_start" select="$current_start"/>
							<xsl:with-param name="endstr" select="$endstr"/>
							<xsl:with-param name="last_position" select="$last_position "/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>

						<xsl:value-of select="$overlay"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>

			<xsl:if test="$previous_event_in_overlay = 0">
				<xsl:value-of select="0"/>
			</xsl:if>
		</xsl:if>

		<xsl:if test="$overlay = 0">
			<xsl:value-of select="0"/>
		</xsl:if>
	</xsl:template>


	<!--get_timevalue: obtient la valeur en minutes d'une composant heure : '04:09' -->
	<xsl:template name="get_timevalue">
		<xsl:param name="value"/>
		<xsl:value-of select="number(60 *number(substring-before($value , ':')) + number(substring-after($value, ':')))"/>
	</xsl:template>

	<!--get_duration : obtient une durée en minutes-->
	<xsl:template name="get_duration">
		<xsl:param name="starttime"/>
		<xsl:param name="endtime"/>
		<xsl:value-of select="number(60 *number(substring-before($endtime , ':')) + number(substring-after($endtime, ':')))-number(60 *number(substring-before($starttime , ':')) + number(substring-after($starttime, ':')))"/>
	</xsl:template>

	<!--get_before_duration_string: crée une chaine des durées qui sépare les événements des événements précédents en tenant compte d la ligne à laquelle ils appartiennent-->
	<xsl:template name="get_before_duration_string">
		<xsl:param name="startstr"/>
		<xsl:param name="endstr"/>
		<xsl:param name="max"/>
		<xsl:param name="day_start"/>
		<xsl:param name="last_position"/>
		<xsl:param name="indexes_string"/>
		<xsl:param name="result"/>

		<xsl:if test="$last_position &lt;= $max">

			<!--Toujours le day_start comme référence -->
			<xsl:if test="$last_position = 1">

				<xsl:variable name="current_start" select="substring($startstr,1 +( ($last_position - 1 ) * 6),5)"/>


				<xsl:variable name="previous_end">
					<xsl:value-of select="$day_start"/>
				</xsl:variable>

				<!-- On ajoute des zéros pour s'assurer que la taille du string est toujours la même pour ensuite récupérer dans les substrings-->
				<xsl:choose>
					<xsl:when test="$current_start &gt;= $previous_end">
						<xsl:variable name="value_to_pass" select="concat('0000',$current_start - $previous_end)"/>

						<xsl:call-template name="get_before_duration_string">
							<xsl:with-param name="startstr" select="$startstr"/>
							<xsl:with-param name="endstr" select="$endstr"/>
							<xsl:with-param name="max" select="$max"/>
							<xsl:with-param name="day_start" select="$day_start"/>
							<xsl:with-param name="last_position" select="$last_position + 1"/>
							<xsl:with-param name="indexes_string" select="$indexes_string"/>
							<xsl:with-param name="result" select="concat($result,substring($value_to_pass,string-length($value_to_pass)-3,4),',') "/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>

						<!-- Cas où l'événement démarre avant la grille-->
						<xsl:variable name="value_to_pass" select="'00000'"/>

						<xsl:call-template name="get_before_duration_string">
							<xsl:with-param name="startstr" select="$startstr"/>
							<xsl:with-param name="endstr" select="$endstr"/>
							<xsl:with-param name="max" select="$max"/>
							<xsl:with-param name="day_start" select="$day_start"/>
							<xsl:with-param name="last_position" select="$last_position + 1"/>
							<xsl:with-param name="indexes_string" select="$indexes_string"/>
							<xsl:with-param name="result" select="concat($result,substring($value_to_pass,string-length($value_to_pass)-3,4),',') "/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>

			<!--Référence = event précedent mais sur la même ligne-->
			<xsl:if test="$last_position &gt; 1">

				<xsl:choose>
					<!-- Event courant et précédent sur la même ligne-->
					<xsl:when test="substring($indexes_string,1+($last_position - 1)*4,3)=substring($indexes_string,1+($last_position - 2)*4,3)">
						<xsl:variable name="current_start" select="substring($startstr,1 +( ($last_position - 1 ) * 6),5)"/>

						<xsl:variable name="previous_endstr" select="substring($endstr,1 +( ($last_position -2)  * 6),5)"/>
						<xsl:variable name="previous_end">
							<xsl:choose>
								<xsl:when test="$previous_endstr != ''">
									<xsl:value-of select="$previous_endstr"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$day_start"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<!-- On ajoute des zéos pour s'assurer que la taille du string est toujours la même pour ensuite récupérer dans les substrings-->
						<xsl:variable name="value_to_pass" select="concat('0000',$current_start - $previous_end)"/>


						<xsl:call-template name="get_before_duration_string">
							<xsl:with-param name="startstr" select="$startstr"/>
							<xsl:with-param name="endstr" select="$endstr"/>
							<xsl:with-param name="max" select="$max"/>
							<xsl:with-param name="day_start" select="$day_start"/>
							<xsl:with-param name="last_position" select="$last_position + 1"/>
							<xsl:with-param name="indexes_string" select="$indexes_string"/>
							<xsl:with-param name="result" select="concat($result,substring($value_to_pass,string-length($value_to_pass)-3,4),',') "/>
						</xsl:call-template>
					</xsl:when>

					<!-- Event courant et précédent sur des lignes différentes. On recherche End événement précédent de cette ligne-->
					<xsl:otherwise>
						<xsl:variable name="previous_event_pos">
							<xsl:call-template name="get_eventpos_in_indexes_string">
								<xsl:with-param name="overlay" select="substring($indexes_string,1+($last_position - 1)*4,3)"/>
								<xsl:with-param name="indexes_string" select="$indexes_string"/>
								<xsl:with-param name="current_event_pos" select="$last_position"/>
								<xsl:with-param name="i" select="1"/>
								<xsl:with-param name="result" select="0"/>
							</xsl:call-template>
						</xsl:variable>

						<!--Pas d'événement précédent sur cette ligne. day_start devient référence-->
						<xsl:if test="$previous_event_pos = 0">
							<xsl:variable name="current_start" select="substring($startstr,1 +( ($last_position - 1 ) * 6),5)"/>

							<xsl:variable name="previous_end">
								<xsl:value-of select="$day_start"/>
							</xsl:variable>

							<!-- On ajoute des zéros pour s'assurer que la taille du string est toujours la même pour ensuite récupérer dans les substrings-->
							<xsl:variable name="value_to_pass" select="concat('0000',$current_start - $previous_end)"/>


							<xsl:call-template name="get_before_duration_string">
								<xsl:with-param name="startstr" select="$startstr"/>
								<xsl:with-param name="endstr" select="$endstr"/>
								<xsl:with-param name="max" select="$max"/>
								<xsl:with-param name="day_start" select="$day_start"/>
								<xsl:with-param name="last_position" select="$last_position + 1"/>
								<xsl:with-param name="indexes_string" select="$indexes_string"/>
								<xsl:with-param name="result" select="concat($result,substring($value_to_pass,string-length($value_to_pass)-3,4),',') "/>
							</xsl:call-template>
						</xsl:if>

						<!-- Event précédent trouvé. Event End devient référence-->
						<xsl:if test="$previous_event_pos &gt; 0">
							<xsl:variable name="current_start" select="substring($startstr,1 +( ($last_position - 1 ) * 6),5)"/>


							<xsl:variable name="previous_endstr" select="substring($endstr,1 +( ($previous_event_pos - 1 ) * 6),5)"/>
							<xsl:variable name="previous_end">
								<xsl:choose>
									<xsl:when test="$previous_endstr != ''">
										<xsl:value-of select="$previous_endstr"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$day_start"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>

							<!-- On ajoute des zéos pour s'assurer que la taille du string est toujours la même pour ensuite récupérer dans les substrings-->
							<xsl:variable name="value_to_pass" select="concat('0000',$current_start - $previous_end)"/>


							<xsl:call-template name="get_before_duration_string">
								<xsl:with-param name="startstr" select="$startstr"/>
								<xsl:with-param name="endstr" select="$endstr"/>
								<xsl:with-param name="max" select="$max"/>
								<xsl:with-param name="day_start" select="$day_start"/>
								<xsl:with-param name="last_position" select="$last_position + 1"/>
								<xsl:with-param name="indexes_string" select="$indexes_string"/>
								<xsl:with-param name="result" select="concat($result,substring($value_to_pass,string-length($value_to_pass)-3,4),',') "/>
							</xsl:call-template>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:if>

		<xsl:if test="$last_position &gt; $max">
			<xsl:value-of select="$result"/>
		</xsl:if>
	</xsl:template>

	<!--get_event_duration_string: crée une chaine des durées des évenements pour une journée donnée-->
	<xsl:template name="get_event_duration_string">
		<xsl:param name="startstr"/>
		<xsl:param name="endstr"/>
		<xsl:param name="max"/>
		<xsl:param name="last_position"/>
		<xsl:param name="result"/>

		<xsl:if test="$last_position &lt;= $max">

			<xsl:variable name="EventEndStr">
				<xsl:choose>
					<xsl:when test="substring($endstr,1 +( ($last_position - 1 ) * 6),5) &gt; $day_end">
						<xsl:value-of select="$day_end"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring($endstr,1 +( ($last_position - 1 ) * 6),5)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:variable name="EventStartStr">
				<xsl:choose>
					<xsl:when test="substring($startstr,1 +( ($last_position - 1 ) * 6),5) &lt; $day_start">
						<xsl:value-of select="$day_start"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring($startstr,1 +( ($last_position - 1 ) * 6),5)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:variable name="event_duration">
				<xsl:value-of select="$EventEndStr - $EventStartStr"/>
			</xsl:variable>

			<!-- On ajoute des zéros pour créer un buffer de taille fixe-->
			<xsl:variable name="value_to_pass" select="concat('0000',$event_duration)"/>


			<xsl:call-template name="get_event_duration_string">
				<xsl:with-param name="startstr" select="$startstr"/>
				<xsl:with-param name="max" select="$max"/>
				<xsl:with-param name="endstr" select="$endstr"/>
				<xsl:with-param name="last_position" select="$last_position + 1"/>
				<xsl:with-param name="result" select="concat($result,substring($value_to_pass,string-length($value_to_pass)-3,4),',') "/>
			</xsl:call-template>
		</xsl:if>

		<xsl:if test="$last_position &gt; $max">
			<xsl:value-of select="$result"/>
		</xsl:if>
	</xsl:template>

	<!--get_eventpos_in_indexes_string : recherche la position du dernier événement placé pour une ligne donnée d'une journée donnée-->
	<xsl:template name="get_eventpos_in_indexes_string">
		<xsl:param name="overlay"/>
		<xsl:param name="indexes_string"/>
		<xsl:param name="current_event_pos"/>
		<xsl:param name="i"/>
		<xsl:param name="result"/>

		<xsl:if test="$i &lt; $current_event_pos">
			<xsl:choose>
				<xsl:when test="substring($indexes_string,(($current_event_pos - $i) * 4) - 3 , 3)=$overlay and $result=0">
					<xsl:value-of select="($current_event_pos - $i)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="get_eventpos_in_indexes_string">
						<xsl:with-param name="overlay" select="$overlay"/>
						<xsl:with-param name="indexes_string" select="$indexes_string"/>
						<xsl:with-param name="current_event_pos" select="$current_event_pos"/>
						<xsl:with-param name="i" select="$i + 1"/>
						<xsl:with-param name="result" select="0"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>

		<xsl:if test="$i &gt;= $current_event_pos">
			<xsl:value-of select="$result"/>
		</xsl:if>
	</xsl:template>


	<!-- Get_max: obtient le nombre de lignes max dû aux superpositions d'événements sur une journée-->
	<xsl:template name="get_max">
		<xsl:param name="instr"/>
		<xsl:param name="last_position"/>
		<xsl:param name="count"/>
		<xsl:param name="max"/>

		<xsl:if test="$last_position &lt;= $count">

			<xsl:variable name="overlay" select="substring($instr,(1 + ($last_position -1) * 4),3)"/>
			<xsl:choose>
				<xsl:when test="$max &lt; $overlay">
					<xsl:call-template name="get_max">
						<xsl:with-param name="instr" select="$instr"/>
						<xsl:with-param name="last_position" select="$last_position + 1"/>
						<xsl:with-param name="count" select="$count"/>
						<xsl:with-param name="max" select="$overlay"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="get_max">
						<xsl:with-param name="instr" select="$instr"/>
						<xsl:with-param name="last_position" select="$last_position + 1"/>
						<xsl:with-param name="count" select="$count"/>
						<xsl:with-param name="max" select="$max"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>



		<xsl:if test="$last_position &gt; $count">
			<xsl:value-of select="$max"/>
		</xsl:if>
	</xsl:template>

	<!-- Events : lance la création des événements pour une journée donnée-->
	<xsl:template name="events">
		<xsl:param name="last_position"/>
		<xsl:param name="max"/>
		<xsl:param name="actual_week"/>
		<xsl:param name="actual_day"/>
		<xsl:param name="day_duration"/>
		<xsl:param name="day_start"/>
		<xsl:param name="indexes_string"/>
		<xsl:param name="before_durations"/>
		<xsl:param name="event_durations"/>
		<xsl:param name="timeslots_string"/>
		<xsl:param name="endstr"/>
		<xsl:param name="span_date"/>
		<xsl:param name="events_node"/>
		<xsl:if test="$last_position &lt;= $max">

			<xsl:variable name="last_event" select="$max - $last_position "/>

			<xsl:choose>
				<xsl:when test="$last_position=1">

					<tr>
						<td class="days">
							<xsl:attribute name="rowspan">
								<xsl:value-of select="$max"/>
							</xsl:attribute>
							<!--							<xsl:attribute name="width">
								<xsl:value-of select="concat ($num_periods , '%')"/>
							</xsl:attribute>-->
							<xsl:value-of select="name"/>
							<br/>
							<xsl:choose>
								<xsl:when test="date != ''">
									<xsl:value-of select="date"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:variable name="day" select="substring($span_date,1,2)"/>
									<xsl:variable name="month" select="substring($span_date,4,2)"/>
									<xsl:variable name="year" select="substring($span_date,string-length($span_date)-1,2)"/>

									<xsl:call-template name="get_date">
										<xsl:with-param name="day" select="$day"/>
										<xsl:with-param name="month" select="$month"/>
										<xsl:with-param name="year" select="$year"/>
										<xsl:with-param name="dayid" select="$actual_day"/>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</td>



						<xsl:for-each select="$events_node">
							<xsl:sort select="starttime"/>
							<xsl:sort select="endtime"/>


							<xsl:if test="substring($indexes_string,1 + (position() - 1) * 4,3)=$last_position">
								<xsl:variable name="event_duration" select="substring($event_durations,1 + (position() - 1) * 5,4)"/>
								<xsl:variable name="before_duration" select="substring($before_durations,1 + (position() - 1) * 5,4)"/>

								<xsl:call-template name="event">
									<xsl:with-param name="day_duration" select="$day_duration"/>
									<xsl:with-param name="day_start" select="$day_start"/>
									<xsl:with-param name="before_duration" select="$before_duration"/>
									<xsl:with-param name="event_duration" select="$event_duration"/>
									<xsl:with-param name="last_event" select="$last_event"/>
									<xsl:with-param name="timeslots_string" select="$timeslots_string"/>
								</xsl:call-template>
							</xsl:if>


							<xsl:if test="position() = last()">

								<!--Obtient le dernier endtime le plus élevé-->
								<xsl:variable name="previous_last_event">
									<xsl:call-template name="get_eventpos_in_indexes_string">
										<xsl:with-param name="overlay" select="$last_position"/>
										<xsl:with-param name="indexes_string" select="$indexes_string"/>
										<xsl:with-param name="current_event_pos" select="position() + 1"/>
										<xsl:with-param name="i" select="1"/>
										<xsl:with-param name="result" select="0"/>
									</xsl:call-template>
								</xsl:variable>
								<xsl:variable name="previous_last_endstr" select="substring($endstr,1 + ($previous_last_event - 1)  * 6,5)"/>

								<xsl:variable name="previous_last_end">

									<xsl:choose>
										<xsl:when test="$previous_last_endstr != ''">
											<xsl:value-of select="$previous_last_endstr"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$day_start"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>

								<!--Crée les cellules vides après le dernier événement de la journée. Question mise en page des bordures de cellules-->


								<xsl:if test="($day_duration - ($previous_last_end - $day_start) ) &gt; 0">

									<xsl:choose>
										<xsl:when test="$last_event = 0">


											<xsl:call-template name="draw_timeslots">
												<xsl:with-param name="timeslots_string" select="$timeslots_string"/>
												<xsl:with-param name="period_start" select="$previous_last_end"/>
												<xsl:with-param name="period_end" select="$day_start + $day_duration"/>
												<xsl:with-param name="class_name" select="'empty_bottom'"/>
												<xsl:with-param name="last_position" select="1"/>
											</xsl:call-template>
										</xsl:when>
										<xsl:otherwise>

											<xsl:call-template name="draw_timeslots">
												<xsl:with-param name="timeslots_string" select="$timeslots_string"/>
												<xsl:with-param name="period_start" select="$previous_last_end"/>
												<xsl:with-param name="period_end" select="$day_start + $day_duration"/>
												<xsl:with-param name="class_name" select="'empty'"/>
												<xsl:with-param name="last_position" select="1"/>
											</xsl:call-template>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
							</xsl:if>
						</xsl:for-each>
					</tr>

					<xsl:call-template name="events">
						<xsl:with-param name="last_position" select="$last_position + 1"/>
						<xsl:with-param name="max" select="$max"/>
						<xsl:with-param name="actual_week" select="$actual_week"/>
						<xsl:with-param name="actual_day" select="$actual_day"/>
						<xsl:with-param name="day_duration" select="$day_duration"/>
						<xsl:with-param name="day_start" select="$day_start"/>
						<xsl:with-param name="indexes_string" select="$indexes_string"/>
						<xsl:with-param name="before_durations" select="$before_durations"/>
						<xsl:with-param name="event_durations" select="$event_durations"/>
						<xsl:with-param name="timeslots_string" select="$timeslots_string"/>
						<xsl:with-param name="endstr" select="$endstr"/>
						<xsl:with-param name="span_date" select="$span_date"/>
						<xsl:with-param name="events_node" select="$events_node"/>
					</xsl:call-template>
				</xsl:when>

				<xsl:otherwise>
					<tr>
						<xsl:for-each select="$events_node">
							<xsl:sort select="starttime"/>
							<xsl:sort select="endtime"/>


							<xsl:if test="substring($indexes_string,1 + (position() - 1) * 4,3)=$last_position">

								<xsl:variable name="event_duration" select="substring($event_durations,1 + (position() - 1) * 5,4)"/>
								<xsl:variable name="before_duration" select="substring($before_durations,1 + (position() - 1) * 5,4)"/>

								<xsl:call-template name="event">
									<xsl:with-param name="day_duration" select="$day_duration"/>
									<xsl:with-param name="day_start" select="$day_start"/>
									<xsl:with-param name="before_duration" select="$before_duration"/>
									<xsl:with-param name="event_duration" select="$event_duration"/>
									<xsl:with-param name="last_event" select="$last_event"/>
									<xsl:with-param name="timeslots_string" select="$timeslots_string"/>
								</xsl:call-template>
							</xsl:if>


							<xsl:if test="position() = last()">

								<!--Obtient le dernier endtime le plus élevé-->
								<xsl:variable name="previous_last_event">
									<xsl:call-template name="get_eventpos_in_indexes_string">
										<xsl:with-param name="overlay" select="$last_position"/>
										<xsl:with-param name="indexes_string" select="$indexes_string"/>
										<xsl:with-param name="current_event_pos" select="position() + 1"/>
										<xsl:with-param name="i" select="1"/>
										<xsl:with-param name="result" select="0"/>
									</xsl:call-template>
								</xsl:variable>
								<xsl:variable name="previous_last_endstr" select="substring($endstr,1 + ($previous_last_event - 1)  * 6,5)"/>

								<xsl:variable name="previous_last_end">

									<xsl:choose>
										<xsl:when test="$previous_last_endstr != ''">
											<xsl:value-of select="$previous_last_endstr"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$day_start"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>

								<!--Crée les cellules vides après le dernier événement de la journée. Questionn mise en page des bordures de cellules-->


								<xsl:if test="($day_duration - ($previous_last_end - $day_start) ) &gt; 0">

									<xsl:choose>
										<xsl:when test="$last_event = 0">


											<xsl:call-template name="draw_timeslots">
												<xsl:with-param name="timeslots_string" select="$timeslots_string"/>
												<xsl:with-param name="period_start" select="$previous_last_end"/>
												<xsl:with-param name="period_end" select="$day_start + $day_duration"/>
												<xsl:with-param name="class_name" select="'empty_bottom'"/>
												<xsl:with-param name="last_position" select="1"/>
											</xsl:call-template>
										</xsl:when>
										<xsl:otherwise>

											<xsl:call-template name="draw_timeslots">
												<xsl:with-param name="timeslots_string" select="$timeslots_string"/>
												<xsl:with-param name="period_start" select="$previous_last_end"/>
												<xsl:with-param name="period_end" select="$day_start + $day_duration"/>
												<xsl:with-param name="class_name" select="'empty'"/>
												<xsl:with-param name="last_position" select="1"/>
											</xsl:call-template>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
							</xsl:if>
						</xsl:for-each>
					</tr>
					<xsl:call-template name="events">
						<xsl:with-param name="last_position" select="$last_position + 1"/>
						<xsl:with-param name="max" select="$max"/>
						<xsl:with-param name="actual_week" select="$actual_week"/>
						<xsl:with-param name="actual_day" select="$actual_day"/>
						<xsl:with-param name="day_duration" select="$day_duration"/>
						<xsl:with-param name="day_start" select="$day_start"/>
						<xsl:with-param name="indexes_string" select="$indexes_string"/>
						<xsl:with-param name="before_durations" select="$before_durations"/>
						<xsl:with-param name="event_durations" select="$event_durations"/>
						<xsl:with-param name="timeslots_string" select="$timeslots_string"/>
						<xsl:with-param name="endstr" select="$endstr"/>
						<xsl:with-param name="span_date" select="$span_date"/>
						<xsl:with-param name="events_node" select="$events_node"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>


	<!--Event : Création de l'événement et de son contenu-->
	<xsl:template name="event">
		<xsl:param name="day_duration"/>
		<xsl:param name="day_start"/>
		<xsl:param name="before_duration"/>
		<xsl:param name="event_duration"/>
		<xsl:param name="last_event"/>
		<xsl:param name="timeslots_string"/>


		<xsl:if test="$before_duration &gt; 0 ">

			<xsl:variable name="event_start">
				<xsl:call-template name="get_timevalue">
					<xsl:with-param name="value" select="starttime"/>
				</xsl:call-template>
			</xsl:variable>

			<xsl:choose>
				<xsl:when test="$last_event = 0">

					<xsl:call-template name="draw_timeslots">
						<xsl:with-param name="timeslots_string" select="$timeslots_string"/>
						<xsl:with-param name="period_start" select="$event_start - $before_duration"/>
						<xsl:with-param name="period_end" select="$event_start"/>
						<xsl:with-param name="class_name" select="'empty_bottom'"/>
						<xsl:with-param name="last_position" select="1"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>

					<xsl:call-template name="draw_timeslots">
						<xsl:with-param name="timeslots_string" select="$timeslots_string"/>
						<xsl:with-param name="period_start" select="$event_start  - $before_duration"/>
						<xsl:with-param name="period_end" select="$event_start"/>
						<xsl:with-param name="class_name" select="'empty'"/>
						<xsl:with-param name="last_position" select="1"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>

		<xsl:variable name="event_title">

			<xsl:value-of select="prettytimes"/>
			<xsl:text>
</xsl:text>

			<xsl:for-each select="resources/*">

				<xsl:if test="$show_event_title = 1 and @title != ''">
					<xsl:value-of select="concat(@title,': ')"/>
				</xsl:if>


				<xsl:variable name="resource_string">
					<xsl:for-each select="item">
						<xsl:value-of select="."/>
						<xsl:if test="position() != last()">
							<xsl:text>; </xsl:text>
						</xsl:if>
					</xsl:for-each>
				</xsl:variable>


				<xsl:value-of select="$resource_string"/>
				<xsl:text>
</xsl:text>
			</xsl:for-each>
		</xsl:variable>


		<xsl:choose>
			<xsl:when test="$nb_caracters &gt; 0 ">
				<xsl:variable name="event_id">
					<xsl:text>ev</xsl:text>
					<xsl:value-of select="@id"/>
				</xsl:variable>


				<td class="grid_event">
					<xsl:attribute name="colspan">
						<xsl:value-of select="ceiling(number($event_duration div $time_unit))"/>
					</xsl:attribute>
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
					<xsl:attribute name="title">
						<xsl:value-of select="$event_title"/>
					</xsl:attribute>
					<a>
						<xsl:attribute name="name">
							<xsl:value-of select="$event_id"/>
						</xsl:attribute>
					</a>

					<span class="grid_event">
						<xsl:attribute name="id">
							<xsl:value-of select="$event_id"/>
						</xsl:attribute>


						<span class="event_title">
							<xsl:value-of select="prettytimes"/>
							<br/>
						</span>

						<span class="combined_dates">
							<xsl:if test="$combined = true">
								<xsl:value-of select="@date"/>
							</xsl:if>
							<br/>
						</span>

						<span class="event_resources">
							<xsl:for-each select="resources/*">
								<xsl:if test="$show_event_title = 1 and @title != ''">
									<span class="resource_title">
										<xsl:value-of select="concat(@title,': ')"/>
									</span>
								</xsl:if>

								<xsl:variable name="resource_string">
									<xsl:for-each select="item">
										<xsl:value-of select="."/>
										<xsl:if test="position() != last()">
											<xsl:text>; </xsl:text>
										</xsl:if>
									</xsl:for-each>
								</xsl:variable>

								<xsl:variable name="Node" select="name()"/>

								<span>
									<xsl:attribute name="class">
										<xsl:value-of select="concat('resource_grid_',$Node)"/>
									</xsl:attribute>

									<xsl:choose>
										<xsl:when test="string-length($resource_string) &gt; $nb_caracters">
											<xsl:value-of select="concat(substring($resource_string,1,$nb_caracters),'...') "/>
											<br/>
										</xsl:when>
										<xsl:otherwise>

											<!-- Hyperlink pour les ressources qui sont assez longues pour s'afficher sans les ellipses-->

											<xsl:for-each select="item">
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
											</xsl:for-each>
										</xsl:otherwise>
									</xsl:choose>
								</span>
							</xsl:for-each>
						</span>
					</span>



					<xsl:if test="($rburl) and not(resources/room)">
						<span class="no_room_in_event">
							<img class="no_room_in_event" src="roomreq.gif">
								<xsl:attribute name="alt">
									<xsl:value-of select="$termrb"/>
								</xsl:attribute>
							</img>
							<a target="_self">
								<xsl:attribute name="href">javascript:rbe(<xsl:value-of select="@id"/>);</xsl:attribute>
								<xsl:value-of select="$termrb"/>
							</a>
						</span>
						<br/>
					</xsl:if>


					<xsl:if test="id != ''">
						<span class="id_display">
							<xsl:value-of select="$termid"/>
							<xsl:text>: </xsl:text>
							<xsl:for-each select="id">
								<xsl:copy-of select="."/>
								<xsl:if test="position() != last()">
									<xsl:text>; </xsl:text>
								</xsl:if>
							</xsl:for-each>
						</span>
						<br/>
					</xsl:if>



					<xsl:if test="tag != ''">
						<span class="tag_display">
							<xsl:value-of select="$termtag"/>
							<xsl:text>: </xsl:text>
							<xsl:for-each select="tag">
								<xsl:copy-of select="."/>
								<xsl:if test="position() != last()">
									<xsl:text>; </xsl:text>
								</xsl:if>
							</xsl:for-each>
						</span>
						<br/>
					</xsl:if>

					<xsl:if test="notes != ''">
						<span class="notes_display">
							<xsl:value-of select="$termnotes"/>
							<xsl:text>: </xsl:text>
							<xsl:copy-of select="notes"/>
						</span>
						<br/>
					</xsl:if>
				</td>
			</xsl:when>


			<xsl:otherwise>
				<xsl:variable name="event_id">
					<xsl:text>ev</xsl:text>
					<xsl:value-of select="@id"/>
				</xsl:variable>

				<td class="grid_event">
					<xsl:attribute name="colspan">
						<xsl:value-of select="ceiling(number($event_duration div $time_unit))"/>
					</xsl:attribute>
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

					<span class="event">
						<span class="event_title">
							<xsl:value-of select="prettytimes"/>
							<br/>
						</span>

						<span class="combined_dates">
							<xsl:if test="$combined = true">
								<xsl:value-of select="@date"/>
							</xsl:if>
							<br/>
						</span>

						<span class="event_resources">
							<xsl:for-each select="resources/*">
								<xsl:if test="$show_event_title = 1 and @title != ''">
									<span class="resource_title">
										<xsl:value-of select="concat(@title,': ')"/>
									</span>
								</xsl:if>

								<xsl:variable name="Node" select="name()"/>

								<span>
									<xsl:attribute name="class">
										<xsl:value-of select="concat('resource_grid_',$Node)"/>
									</xsl:attribute>

									<xsl:for-each select="item">
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
									</xsl:for-each>
									<br/>
								</span>
							</xsl:for-each>
						</span>
					</span>

					<xsl:if test="($rburl) and not(resources/room)">
						<span class="no_room_in_event">
							<img class="no_room_in_event" src="roomreq.gif">
								<xsl:attribute name="alt">
									<xsl:value-of select="$termrb"/>
								</xsl:attribute>
							</img>
							<a target="_self">
								<xsl:attribute name="href">javascript:rbe(<xsl:value-of select="@id"/>);</xsl:attribute>
								<xsl:value-of select="$termrb"/>
							</a>
						</span>
						<br/>
					</xsl:if>


					<xsl:if test="id != ''">
						<span class="id_display">
							<xsl:value-of select="$termid"/>
							<xsl:text>: </xsl:text>
							<xsl:for-each select="id">
								<xsl:copy-of select="."/>
								<xsl:if test="position() != last()">
									<xsl:text>; </xsl:text>
								</xsl:if>
							</xsl:for-each>
						</span>
						<br/>
					</xsl:if>



					<xsl:if test="tag != ''">
						<span class="tag_display">
							<xsl:value-of select="$termtag"/>
							<xsl:text>: </xsl:text>
							<xsl:for-each select="tag">
								<xsl:copy-of select="."/>
								<xsl:if test="position() != last()">
									<xsl:text>; </xsl:text>
								</xsl:if>
							</xsl:for-each>
						</span>
						<br/>
					</xsl:if>


					<xsl:if test="notes != ''">
						<span class="notes_display">
							<xsl:value-of select="$termnotes"/>
							<xsl:text>: </xsl:text>
							<xsl:copy-of select="notes"/>
						</span>
						<br/>
					</xsl:if>
				</td>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>



	<!-- draw_timeslots : dessine les lignes verticales des heures -->
	<xsl:template name="draw_timeslots">
		<xsl:param name="timeslots_string"/>
		<xsl:param name="period_start"/>
		<xsl:param name="period_end"/>
		<xsl:param name="class_name"/>
		<xsl:param name="last_position"/>





		<xsl:variable name="timeslot">
			<xsl:call-template name="get_timevalue">
				<xsl:with-param name="value" select="substring($timeslots_string,1 + ($last_position - 1 )* 6, 5)"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="$timeslot &lt; $period_end">

				<xsl:choose>
					<xsl:when test="$timeslot &gt; $period_start">
						<td>
							<xsl:attribute name="colspan">
								<xsl:value-of select="ceiling(number(($timeslot - $period_start) div $time_unit))"/>
							</xsl:attribute>
							<xsl:attribute name="class">
								<xsl:value-of select="$class_name"/>
							</xsl:attribute>
						</td>

						<xsl:call-template name="draw_timeslots">
							<xsl:with-param name="timeslots_string" select="$timeslots_string"/>
							<xsl:with-param name="period_start" select="$timeslot"/>
							<xsl:with-param name="period_end" select="$period_end"/>
							<xsl:with-param name="class_name" select="$class_name"/>
							<xsl:with-param name="last_position" select="$last_position + 1"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>

						<xsl:call-template name="draw_timeslots">
							<xsl:with-param name="timeslots_string" select="$timeslots_string"/>
							<xsl:with-param name="period_start" select="$period_start"/>
							<xsl:with-param name="period_end" select="$period_end"/>
							<xsl:with-param name="class_name" select="$class_name"/>
							<xsl:with-param name="last_position" select="$last_position + 1"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<td>
					<xsl:attribute name="colspan">
						<xsl:value-of select="ceiling(number(($period_end - $period_start) div $time_unit))"/>
					</xsl:attribute>
					<xsl:attribute name="class">
						<xsl:value-of select="$class_name"/>
					</xsl:attribute>
				</td>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<!--Obtient la date des jours à partir du premier jour de la semaine du span. Base lundi = 0-->
	<xsl:template name="get_date">
		<xsl:param name="day"/>
		<xsl:param name="month"/>
		<xsl:param name="year"/>
		<xsl:param name="dayid"/>

		<xsl:choose>

			<!-- Années bi-->
			<xsl:when test="$year=12 or $year=16 or $year=20">

				<xsl:choose>
					<!-- Mois de 31 jours sauf décembre-->
					<xsl:when test="$month=1 or $month=3 or $month=5 or $month =7 or $month=8 or $month=10  ">

						<xsl:choose>
							<xsl:when test="($day + $dayid) &gt; 31">
								<xsl:value-of select="concat('0',($day + $dayid) - 31 ,'/', $month + 1,'/',$year)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="($day + $dayid) &lt; 10">
									<xsl:value-of select="concat('0',($day + $dayid) ,'/', $month ,'/',$year)"/>
								</xsl:if>
								<xsl:if test="($day + $dayid) &gt;= 10">
									<xsl:value-of select="concat(($day + $dayid) ,'/', $month ,'/',$year)"/>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>

					<!--Février bi-->
					<xsl:when test="$month=2">
						<xsl:choose>
							<xsl:when test="($day + $dayid) &gt; 29">
								<xsl:value-of select="concat('0',($day + $dayid) - 31 ,'/','01','/',$year + 1)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="($day + $dayid) &lt; 10">
									<xsl:value-of select="concat('0',($day + $dayid) ,'/', $month ,'/',$year)"/>
								</xsl:if>
								<xsl:if test="($day + $dayid) &gt;= 10">
									<xsl:value-of select="concat(($day + $dayid) ,'/', $month ,'/',$year)"/>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>

					<!--Décembre-->
					<xsl:when test="$month=12">
						<xsl:choose>
							<xsl:when test="($day + $dayid) &gt; 31">
								<xsl:value-of select="concat('0',($day + $dayid) - 31 ,'/','01','/',$year + 1)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="($day + $dayid) &lt; 10">
									<xsl:value-of select="concat('0',($day + $dayid) ,'/', $month ,'/',$year)"/>
								</xsl:if>
								<xsl:if test="($day + $dayid) &gt;= 10">
									<xsl:value-of select="concat(($day + $dayid) ,'/', $month ,'/',$year)"/>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>

					<!-- Mois de 30 jours -->
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="($day + $dayid) &gt; 30">
								<xsl:value-of select="concat('0',($day + $dayid) - 30 ,'/',$month + 1,'/',$year)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="($day + $dayid) &lt; 10">
									<xsl:value-of select="concat('0',($day + $dayid) ,'/', $month ,'/',$year)"/>
								</xsl:if>
								<xsl:if test="($day + $dayid) &gt;= 10">
									<xsl:value-of select="concat(($day + $dayid) ,'/', $month ,'/',$year)"/>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>

			<!-- Années non bi-->
			<xsl:otherwise>

				<xsl:choose>
					<!-- Mois de 31 jours sauf décembre-->
					<xsl:when test="$month=1 or $month=3 or $month=5 or $month =7 or $month=8 or $month=10  ">

						<xsl:choose>
							<xsl:when test="($day + $dayid) &gt; 31">
								<xsl:value-of select="concat('0',($day + $dayid) - 31 ,'/', $month + 1,'/',$year)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="($day + $dayid) &lt; 10">
									<xsl:value-of select="concat('0',($day + $dayid) ,'/', $month ,'/',$year)"/>
								</xsl:if>
								<xsl:if test="($day + $dayid) &gt;= 10">
									<xsl:value-of select="concat(($day + $dayid) ,'/', $month ,'/',$year)"/>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>

					<!--Février -->
					<xsl:when test="$month=2">
						<xsl:choose>
							<xsl:when test="($day + $dayid) &gt; 28">
								<xsl:value-of select="concat('0',($day + $dayid) - 28 ,'/','01','/',$year + 1)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="($day + $dayid) &lt; 10">
									<xsl:value-of select="concat('0',($day + $dayid) ,'/', $month ,'/',$year)"/>
								</xsl:if>
								<xsl:if test="($day + $dayid) &gt;= 10">
									<xsl:value-of select="concat(($day + $dayid) ,'/', $month ,'/',$year)"/>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>

					<!--Décembre-->
					<xsl:when test="$month=12">
						<xsl:choose>
							<xsl:when test="($day + $dayid) &gt; 31">
								<xsl:value-of select="concat('0',($day + $dayid) - 31 ,'/','01','/',$year + 1)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="($day + $dayid) &lt; 10">
									<xsl:value-of select="concat('0',($day + $dayid) ,'/', $month ,'/',$year)"/>
								</xsl:if>
								<xsl:if test="($day + $dayid) &gt;= 10">
									<xsl:value-of select="concat(($day + $dayid) ,'/', $month ,'/',$year)"/>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>

					<!-- Mois de 30 jours -->
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="($day + $dayid) &gt; 30">
								<xsl:value-of select="concat('0',($day + $dayid) - 30 ,'/',$month + 1,'/',$year)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="($day + $dayid) &lt; 10">
									<xsl:value-of select="concat('0',($day + $dayid) ,'/', $month ,'/',$year)"/>
								</xsl:if>
								<xsl:if test="($day + $dayid) &gt;= 10">
									<xsl:value-of select="concat(($day + $dayid) ,'/', $month ,'/',$year)"/>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Loop pour créer les colonnes de la table en fonction de la durée de la journée-->
	<xsl:template name="for.loop_timeslot">
		<xsl:param name="i"/>
		<xsl:param name="count"/>

		<!--begin_: Line_by_Line_Output -->
		<xsl:if test="$i &lt;= $count">

			<th>
				<!--<xsl:value-of select ="'.'"/>-->
			</th>
		</xsl:if>
		<!--begin_: RepeatTheLoopUntilFinished-->
		<xsl:if test="$i &lt;= $count">
			<xsl:call-template name="for.loop_timeslot">
				<xsl:with-param name="i">
					<xsl:value-of select="$i + 1"/>
				</xsl:with-param>
				<xsl:with-param name="count">
					<xsl:value-of select="$count"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
<!-- Stylus Studio meta-information - (c) 2004-2008. Progress Software Corporation. All rights reserved.

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