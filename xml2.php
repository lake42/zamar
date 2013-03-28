<?php

/*
$file = 'gig.xml';
$bakfile = 'gig.xml~';
//echo "hello";
if (!copy($file, $bakfile)){
		echo "failed to make back up file";
}

$xmlDoc = domxml_open_file($file);
$giglist = $xmlDoc->document_element();
$gigs = $giglist->get_elements_by_tagname('gig');
*/
//$nodecreation = $gigs->child_nodes()->get_elements_by_tagname('nodecreation'); 

//$gigs=$xmlDoc->get_elements_by_tagname('gig');
//$ncreate=$xmlDoc->get_elements_by_tagname('nodecreation');
//$dates=$xmlDoc->get_elements_by_tagname('date');
//$details=$xmlDoc->get_elements_by_tagname('details');

/*
for($i=0; $i<count($ncreate); $i++){
$nodecreation=$g->child_nodes();
$ndates

}
*/

// Check to see if functin exists 
if (!function_exists('file_get_contents')) { 

//    echo "does not extist";
    }
    else { 
  //  echo "does exists"; 
    } 

if (!function_exists('file_put_contents')) { 

//    echo "does not extist";
    }
    else { 
    
 //   echo "does exists"; 
 } 

// Check to see if functin exists 
if (!function_exists('file_put_contents')) { 

    // Define constants used by function, if not defined 
    if (!defined('FILE_USE_INCLUDE_PATH')) define('FILE_USE_INCLUDE_PATH', 1); 
    if (!defined('FILE_APPEND'))           define('FILE_APPEND', 8); 
     
    // Define function and arguments 
    function file_put_contents($file, &$data, $flags=0) 
    { 
        // Varify arguments are correct types 
        if (!is_string($file)) return(false); 
        if (!is_string($data) && !is_array($data)) return(false); 
        if (!is_int($flags)) return(false); 
         
        // Set the include path and mode for fopen 
        $include = false; 
        $mode    = 'wb'; 
         
        // If data in array type.. 
        if (is_array($data)) { 
            // Make sure it's not multi-dimensional 
            reset($data); 
            while (list(, $value) = each($data)) { 
                if (is_array($value)) return(false); 
            } 
            unset($value); 
            reset($data); 
            // Join the contents 
            $data = implode('', $data); 
        } 
         
        // Check for flags.. 
        // If include path flag givin, set include path 
        if ($flags&FILE_USE_INCLUDE_PATH) $include = true; 
        // If append flag givin, set append mode 
        if ($flags&FILE_APPEND) $mode = 'ab'; 
         
        // Open the file with givin options 
        if (!$handle = @fopen($file, $mode, $include)) return(false); 
        // Write data to file 
        if (($bytes = fwrite($handle, $data)) === false) return(false); 
        // Close file 
        fclose($handle); 
         
        // Return number of bytes written 
        return($bytes); 
    } 
} 

$dom = domxml_open_mem(file_get_contents('gig.xml'));
$dt = htmlspecialchars($_POST['gigdetails']);
//$nodeCR = htmlspecialchars($_POST(''));
$dateCR = $_POST['gigdate'];
$detailsCR = $_POST['gigdetails'];

  $gig = $dom->create_element('gig');
  $nodecreation = $dom->create_element('nodecreation');
  $date = $dom->create_element('date');
  $detail = $dom->create_element('details');

  $nodecreation->set_content('nodecreation here');
  $date->set_content($dateCR);
  $detail->set_content($dt);
    
  $gig->append_child($nodecreation);
  $gig->append_child($date);
  $gig->append_child($detail);

  $root = $dom->document_element();
  $root->append_child($gig);

  file_put_contents('gig.xml', $dom->dump_mem());
//  $dom->dump_file("gig3.xml", false, true);
//  echo "gig node added";
//  echo print_r($_POST);

/*
foreach ($gigs as $gig){
//	$nodecreation=$ncreate->child_nodes();
	echo $nodecreation->get_content() . "\n";

}
*/

//echo "<hr>";

//foreach($nc as $r){
// echo $r[0] . "<br/>";
//}


/*
foreach($nodecreation as $t){
	echo $t->node_value() . "<br/>";
}

*/


//$xmlDoc->load($file);
/*
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
*/


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


