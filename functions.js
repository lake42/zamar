// the whole shebang here
$(document).ready(function() {  
  $.ajax({  
    type: "GET",  
    url: "gig.xml",  
    dataType: "xml",  
    success: parseXml  
}); 

//function to find each instance of a gig in xml file and wrap it in a link 
function parseXml(xml) {  
		$("ul#gig_list").hide();

	$(xml).find("gig").each(function() {  
	if ($(this).find("details").text() !== ''){		
		$("ul#gig_list").prepend('<li class="date"><strong>' + $(this).find("date").text() + "</strong><br/>" + $(this).find("details").text() + '<br/>' + '</li>');
		} 
 	
 	});
		$("ul#gig_list").show();
	}  
});

$("#submit").live('click',function(){
  $.ajax({
    	type:'POST',
    	url:'xml2.php',
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

