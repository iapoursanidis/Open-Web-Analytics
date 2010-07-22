<div class="owa_reportSectionContent">
	<div id="trend-chart" style="height:125px; min-width:400px;padding-right:30px;"></div>
</div>
<div class="owa_reportSectionContent">
	<div id="visits-headline" class="owa_reportSectionHeader"></div> 

	<table style="width:auto;margin-top:-15px;">
		<TR>
			<TD valign="top" style="width:50%;">
				<div id="traffic-sources" style="width:250px;"></div>
			</TD>
			
			<TD valign="top" style="width:50%;">
				<div id="trend-metrics"></div>
			</TD>
			
		</TR>
	</table>
</div>

<table style="width:auto;margin-top:;">
	<tr>
		<td valign="top" style="width:50%;">
		
		<div class="owa_reportSectionContent">
		
			<div class="owa_reportSectionHeader">Related Reports</div>

			<UL>
				<LI>
					<a href="<?php echo $this->makeLink(array('do' => 'base.reportSearchEngines'));?>">Search Engines</a></span> - See which search engines your visitors are comming from.
				</LI>
				<LI>
					<a href="<?php echo $this->makeLink(array('do' => 'base.reportKeywords'));?>">Keywords</a></span> - See what keywords your visitor are using to find your web site.
				</LI>
				<LI>
					<a href="<?php echo $this->makeLink(array('do' => 'base.reportReferringSites'));?>">Referring Web Sites</a></span> - See which web sites are linking to your web site.
				</LI>
				<LI>
					<a href="<?php echo $this->makeLink(array('do' => 'base.reportAnchortext'));?>">Inbound Link Text</a></span> - See what words Referring Web Sites use to describe your web site.
				</LI>
			</UL>
			
			</div>
		
			<div class="owa_reportSectionContent" style="min-width:350px;">
				<div class="owa_reportSectionHeader">Top Keywords</div>
				
				<div id="top-keywords"></div>
				<div class="owa_genericHorizonalList owa_moreLinks">
					<UL>
						<LI>
							<a href="<?php echo $this->makeLink(array('do' => 'base.reportKeywords'), true);?>">View Full Report &raquo;</a>	
						</LI>
					</UL>
				</div>
			</div>
		
		</td>
		
		<td valign="top" style="width:50%;">
			
			<div class="owa_reportSectionContent" style="min-width:350px;">
				<div class="owa_reportSectionHeader">Top Referrals</div>
				<div id="top-referrals"></div>
				<div class="owa_genericHorizonalList owa_moreLinks">
					<UL>
						<LI>
							<a href="<?php echo $this->makeLink(array('do' => 'base.reportReferringSites'), true);?>">View Full Report &raquo;</a>	
						</LI>
					</UL>
				</div>
			</div>
		</td>
	</tr>
</table>




<script>
//OWA.setSetting('debug', true);

var aurl = '<?php echo $this->makeApiLink(array('do' => 'getResultSet', 
												'metrics' => 'visits', 
												'dimensions' => 'date', 
												'sort' => 'date',
												'format' => 'json',
												'constraints' => urlencode($this->substituteValue('siteId==%s,','siteId'))), true);?>';
												  
OWA.items.rsh = new OWA.resultSetExplorer('trend-chart');
OWA.items.rsh.asyncQueue.push(['makeAreaChart', [{x:'date',y:'visits'}]]);
OWA.items.rsh.asyncQueue.push(['renderTemplate','#visits-headline-template', {data: OWA.items.rsh}, 'replace', 'visits-headline']);
OWA.items.rsh.load(aurl);

var tturl = '<?php echo $this->makeApiLink(array('do' => 'getResultSet', 
														'metrics' => 'visits', 
														'dimensions' => 'date,medium', 
														'sort' => 'date',
														'format' => 'json',
														'constraints' => urlencode($this->substituteValue('siteId==%s,', 'siteId').',medium=@organic')),true);?>';
																	  
OWA.items.tt = new OWA.resultSetExplorer('trend-metrics');
OWA.items.tt.asyncQueue.push(['makeMetricBoxes','','','Visits From Search Engines', '',function(row) {if (row.medium.value === 'organic-search') return true;}]);
OWA.items.tt.load(tturl);

var tt1url = '<?php echo $this->makeApiLink(array('do' => 'getResultSet', 
														'metrics' => 'visits', 
														'dimensions' => 'date', 
														'sort' => 'date',
														'format' => 'json',
														'constraints' => urlencode($this->substituteValue('siteId==%s,', 'siteId')).'medium==direct'),true);?>';
																	  
var tt1 = new OWA.resultSetExplorer('trend-metrics');
tt1.asyncQueue.push(['makeMetricBoxes','','','Visits From Direct Navigation']);
tt1.load(tt1url);


var tt2url = '<?php echo $this->makeApiLink(array('do' => 'getResultSet', 
														'metrics' => 'visits', 
														'dimensions' => 'date', 
														'sort' => 'date',
														'format' => 'json',
														'constraints' => urlencode($this->substituteValue('siteId==%s,','siteId')).'medium==referral'),true);?>';
														  
OWA.items.tt2 = new OWA.resultSetExplorer('trend-metrics');

OWA.items.tt2.asyncQueue.push(['makeMetricBoxes','','','Visits From Referrals']);
OWA.items.tt2.load(tt2url);

var vmurl = '<?php echo $this->makeApiLink(array('do' => 'getResultSet', 
																	'metrics' => 'visits', 
																	'dimensions' => 'medium', 
																	'sort' => 'visits-',
																	'format' => 'json',
																	'constraints' => urlencode($this->substituteValue('siteId==%s,','siteId'))),true);?>';
																	  
OWA.items.vm = new OWA.resultSetExplorer('traffic-sources');
OWA.items.vm.options.pieChart.metric = 'visits';
OWA.items.vm.options.pieChart.dimension = 'medium';
OWA.items.vm.options.chartWidth = '300px';
OWA.items.vm.asyncQueue.push(['makePieChart']);
OWA.items.vm.load(vmurl);


var topkeywordsurl = '<?php echo $this->makeApiLink(array('do' => 'getResultSet', 
												'metrics' => 'visits', 
												'dimensions' => 'referralSearchTerms', 
												'sort' => 'visits-',
												'format' => 'json',
												'resultsPerPage' => 25,
												'constraints' => urlencode($this->substituteValue('siteId==%s,','siteId'))), true);?>';
												  
OWA.items.topkeywords = new OWA.resultSetExplorer('top-keywords');
OWA.items.topkeywords.asyncQueue.push(['refreshGrid']);
OWA.items.topkeywords.load(topkeywordsurl);

var topreferralsurl = '<?php echo $this->makeApiLink(array('do' => 'getResultSet', 
												'metrics' => 'visits', 
												'dimensions' => 'referralPageUrl', 
												'sort' => 'visits-',
												'format' => 'json',
												'resultsPerPage' => 25,
												'constraints' => urlencode($this->substituteValue('siteId==%s,','siteId'))), true);?>';
												  
OWA.items.topreferrals = new OWA.resultSetExplorer('top-referrals');
OWA.items.topreferrals.asyncQueue.push(['refreshGrid', 'top-referrals']);
OWA.items.topreferrals.load(topreferralsurl);


</script>

<?php require_once('js_report_templates.php');?>

<script type="text/x-jqote-template" id="visits-headline-template">
<![CDATA[
	There were <%= this.data.resultSet.aggregates.visits.value %> <% if (this.data.resultSet.aggregates.visits.value > 1) {this.label = 'visits';} else {this.label = 'visit';} %> <%= this.label %> from all sources.
]]> 
</script>

<script type="text/x-jqote-template" id="table-column">
<![CDATA[

<TD class="<%= this.result_type%>cell"><%= this.value %></TD>
		
]]> 
</script>

<script type="text/x-jqote-template" id="table-row">
<![CDATA[
<TR>
<%= this.columns%>
</TR>		
]]> 
</script>

<script type="text/x-jqote-template" id="simpleTable-outer">
<![CDATA[

<table id="<%= this.dom_id %>" class="simpleTable">
	<tr>
		<%= this.headers %>
	</tr>
</table>
]]>
</script>

<script type="text/x-jqote-template" id="simpleTable-headers">
<![CDATA[
<th class="<%= this.result_type %>"><%= this.label %></th>
]]>
</script>
