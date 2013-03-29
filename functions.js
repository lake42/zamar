// the whole shebang here
// once page is loaded is tries to see which page its on then loads the appropriate xml file.
$(document).ready(function() {
	if($('#gig_list').length){
	loadXML('gig.xml');
//	console.log('found it');		
	}
	if($('#gig_list2').length){
	loadXML2('gig2.xml');
	console.log('found it 2');		
	}
}); 

//function to find each instance of a gig node in the xml file and wrap it in a link structure 
function parseXml(xml) {  
		$("ul#gig_list").hide();

	$(xml).find("gig").each(function() {  
	if ($(this).find("details").text() !== ''){		
		$("ul#gig_list").prepend('<li class="date"><strong>' + $(this).find("date").text() + "</strong><br/>" + $(this).find("details").text() + '<br/>' + '</li>');
		} 
 	
 	});
		$("ul#gig_list").show();
}

// same as above  
function parseXml2(xml) {  
		$("ul#gig_list2").hide();

	$(xml).find("gig").each(function() {  
	if ($(this).find("details").text() !== ''){		
		$("ul#gig_list2").prepend('<li class="date"><strong>' + $(this).find("date").text() + "</strong><br/>" + $(this).find("details").text() + '<br/>' + '</li>');
		} 
 	
 	});
		$("ul#gig_list2").show();
}  

function loadXML(f){
  $.ajax({  
    type: "GET",  
    url: f,  
    dataType: "xml",  
    success: parseXml
    })  
}
function loadXML2(f){
  $.ajax({  
    type: "GET",  
    url: f,  
    dataType: "xml",  
    success: parseXml2
    })  
}


$("#submit").live('click',function(){
  $.ajax({
    	type:'POST',
    	url:'xml2.php?id=1',
	  	data:
	  	{	  	
	  		gigdate: $("#gigdate").val(),
	  		gigdetails: $("#gigdetails").val(),
	  	},
	  	
  		dataType:'',
	  	success: function(){
	  		location.reload();  
	  	},
	  	error: function(){
	  		 alert("the is an error");
	  	}
  		})
});

$("#submit2").live('click',function(){
  $.ajax({
    	type:'POST',
    	url:'xml2.php?id=2',
	  	data:
	  	{	  		
	  		gigdate: $("#gigdate").val(),
	  		gigdetails: $("#gigdetails").val(),
	  	},
	  	
  		dataType:'',
	  	success: function(){
	  		location.reload();  
	  	},
	  	error: function(){
	  		 alert("the is an error");
	  	}
  		})
});



