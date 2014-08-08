var loadUserProfile = function(data) {
    $( "#user_profile" ).remove();

    var url = "/twitter_users/profile/" + data.name + ".html";
    $.ajax({
	url: url,
    }).done(function(html) {
	$( "#profile_pane" ).append(html);
	$( "#list_name_button" ).on('click', function() {
	    var list_name = $("#list_name_input").val();
	    var url = '/twitter_users/lists/' + data.name + '/' + list_name + '.json';
	    $.ajax({
		url: url,
	    }).done(function(json) {
		alert(JSON.stringify(json));
	    });
	});
    });
}

var loadMyUserProfilePage = function(graph) {

    var width = 800;
    var height = 800;
    
    var force = d3.layout.force()
	.charge(-50)
	.linkDistance( function(d) { return d.source.strength; })
	.size([width, height]);
    
    var svg = d3.select("#svg_pane").append("svg")
	.attr("width", width)
	.attr("height", height);
    
    force
	.nodes(graph.nodes)
	.links(graph.links)
	.start();
    
    var link = svg.selectAll(".link")
	.data(graph.links)
	.enter().append("line")
	.attr("class", "link")
	.style("stroke-width", function(d) { return Math.sqrt(d.value); });
    
    var node = svg.selectAll(".node")
	.data(graph.nodes)
	.enter().append("circle")
	.attr("class", "node")
	.attr("r", function(d) { return d.size; } )
	.style("fill", function(d) { return d3.rgb(d.color).darker(d.depth); } )
	.call(force.drag);
    
    node.append("title").text(function(d) { return d.name; });
    
    node.on("click", function(d) { return loadUserProfile(d); } );
    
    force.on("tick", function() {
	link.attr("x1", function(d) { return d.source.x; })
            .attr("y1", function(d) { return d.source.y; })
        .attr("x2", function(d) { return d.target.x; })
            .attr("y2", function(d) { return d.target.y; });
	node.attr("cx", function(d) { return d.x; })
            .attr("cy", function(d) { return d.y; });
    });

    loadUserProfile(graph['nodes'][0]);
}
