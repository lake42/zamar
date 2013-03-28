<?php

$file = 'gig.xml';
$bakfile = 'gig.xml~';
//echo "hello";
if (!copy($file, $bakfile)){
		echo "failed to make back up file";
}

$xmlDoc = new DOMDocument();
$xmlDoc->load($file);

$giglist = $xmlDoc->getElementsByTagName("gig");

foreach ($giglist as $gig){
	$nodecreations = $gig->getElementsByTagName("nodecreation");
	$nodecreation = $nodecreations->item(0)->nodeValue;
	
	$dates = $gig->getElementsByTagName("date");
	$date = $dates->item(0)->nodeValue;
	
	$details = $gig->getElementsByTagName("details");
	$detail = $details->item(0)->nodeValue;
	
	echo $nodecreation . "<br/>";
	echo $date . "<br/>";
	echo $detail . "<br/><br/>";

} 



/*
$root = $xmlDoc->appendChild(
        $xmlDoc->createElement("russellgigs"));
        
$gigTag = $root->appendChild(
          $xmlDoc->createElement("gig"));
          
$gigTag->appendChild(
    	$xmlDoc->createElement("nodecreation", '1/2/12'));

$gigTag->appendChild(
    	$xmlDoc->createElement("date", 'August 21, 2011 :: 7:00 - 9:00pm'));

$gigTag->appendChild(
    	$xmlDoc->createElement("details"))->appendChild($xmlDoc->createCDATASection('The Russell Sledge Continuum will be appearing as a Duo this Thursday, August 21st from 7pm. - 9pm. at the Urban Eats Arts and Music Cafe, a new cafe just outside of DC located at 3311 Rhode Island Ave., Mount Rainier, MD 20712. When you stop in be sure to say hello!'));


header("Content-Type: text/plain");

//make the output pretty
$xmlDoc->formatOutput = true;

echo $xmlDoc->saveXML();
	<nodecreation>04/19/2012</nodecreation>
	<date>April 20, 2012 :: 7:00pm – 9:00pm</date>
	<details><![CDATA[The Russell Sledge Continuum has returned! Come join the quartet, with guest vocalist, for an evening of Jazz at the Agape Cafe, located at the St. Paul United Methodist Church, 6634 St. Barnabas Road Oxon Hill MD. 20745.]]></details>

*/


