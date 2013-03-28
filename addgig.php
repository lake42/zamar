<?php
$file = 'gig.xml';
$bakfile = 'gig.xml~';
if (!copy($file, $bakfile)){
	echo "failed to make back up file";
}
?>

<!DOCTYPE html>
<html>
	<head>
		<title>Gig List Management</title>

		<link href="russell.css" rel="stylesheet" type="text/css" />
		<script src="http://code.jquery.com/jquery-1.7.1.min.js"></script>
		<link rel="stylesheet" href="css/datepicker.css" type="text/css" />		 
		<script type="text/javascript" src="functions.js"></script>
		<script type="text/javascript" src="js/datepicker.js"></script>
	    <script type="text/javascript" src="js/eye.js"></script>
	    <script type="text/javascript" src="js/utils.js"></script>
	    <script type="text/javascript" src="js/layout.js?ver=1.0.2"></script>
		</head>
	
	<body id="zamar">
		<div class="container">
		<table cellpadding="0" cellspacing="0" width="600" border="0">
			<tr>
				<td valign="top" align="center"><img src="russell.jpg" border="0" alt="A Picture of Russell Sledge."></td>
			</tr>
		</table>
		<div id="nav">
			&nbsp;&nbsp;&nbsp;<a href='../index.html'>Home</a>
			&nbsp;&nbsp;&nbsp;<a href='../bio.html'>Bio</a>
			&nbsp;&nbsp;&nbsp;<a href='../disc.html'>Discography</a>
			&nbsp;&nbsp;&nbsp;<a href='cgi-bin/tourdates.pl'>Dates</a>
			&nbsp;&nbsp;&nbsp;<a href='../samples.html'>Samples</a>
			&nbsp;&nbsp;&nbsp;<a href=''>Get A Quote</a>
			&nbsp;&nbsp;&nbsp;<a href='../ayw.html'>As You Wish</a>
		</div>
		<br>
		<div class="gigform">
			<fieldset>
				<legend>Add a Gig</legend>
				<ul>
					<li>
						<label><b>Date of the Gig:</b></label>
						<input type="text" name="gigdate" id="gigdate" class="text date-pick" value="" />
<!--

						<div id="widget">
					<div id="widgetField">
						<span>28 July, 2008 &divide; 31 July, 2008</span>
						<a href="#">Select date range</a>
					</div>
					<div id="widgetCalendar">
					</div>
-->

				</div>
					</li>
					<li>
						<label><b>Details of the Gig:</b></label>
						<textarea name="gigdetails" id="gigdetails" cols="60" rows="7" value=""></textarea>
					</li>
				</ul>
			</fieldset>
		</div>
	<!--	
		<table cellpadding="5" cellspacing="8" border="0" width="700" id="gigform">
			<form method="POST" name="newgig" id="newgig">
				<input type="hidden" name="id" value="2" />
				<tr>
					<td align="right" valign="top">Date of Gig:</td><td align="left">
						<input type="text" name="gigdate" id="gigdate" class="text date-pick" value="" />
					</td>
				</tr>
				<tr><td align="right" valign="top">Details of Gig:</td><td align="left"><textarea name="gigdetails" id="gigdetails" cols="60" rows="7" value=""></textarea></td></tr>
				<tr><td>&nbsp;</td><td align="left"><input type="button" value="add gig" name="submit" id="submit" />&nbsp;&nbsp;&nbsp;<input type="reset"></td></tr>
			</form>
		</table>
		-->
		<ul id="gig_list">
		</ul>
		</div>
	</body>
</html>