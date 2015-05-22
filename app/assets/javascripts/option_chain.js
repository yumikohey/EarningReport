$(function(){
	var format_data, data_obj, option_symbol,strike_levels,strike_price_start, strike_price_end;

	$('.option_chains').on('click', function(){
	  option_symbol = $('#option_symbol').val();
	  console.log(option_symbol);
	  directToOpts(option_symbol);
	});

	var directToOpts = function(option_symbol){
	  $.ajax({
	              type: "GET",
	              url: '/option_chains/' + option_symbol,
	              dataType: 'json',
	              success: function (data) {
	                 console.log('hello');
	                 format_data = JSON.stringify(eval("(" + data + ")"));
	                 data_obj = JSON.parse(format_data);
	                 expiration_date = data_obj.calls[0].expiry;
	                 strike_levels = data_obj.calls.length;
	                 strike_price_start = data_obj.calls[0].strike;
	                 strike_price_end = data_obj.calls[strike_levels-1].strike;
	                 downloadOptionsChains(data_obj, option_symbol, expiration_date);
	                 calculateVolumes(data_obj, strike_levels);
	              },
	              error: function (result) {
	                  console.log('world');
	                  error();
	              }
	  });
	}

	var downloadOptionsChains = function(data_obj, option_symbol, expiration_date){
      $.ajax({
                  type: "POST",
                  url: '/download_option_chains',
                  data: { option_chain: {symbol: option_symbol, option_chains: data_obj, expiration_date: expiration_date}},
                  dataType: 'json',
                  success: function (data) {
                     console.log('success');
                  },
                  error: function (result) {
                      console.log('bad');
                      error();
                  }
      });
	}

	var stacked_chart = function(call_put_volumes, strike_price_array, strike_levels){
		var dataset = call_put_volumes;

		var n = 2, // number of layers
		    m = strike_levels, // number of samples per layer
		    stack = d3.layout.stack(),
		    //layers = stack(d3.range(n).map(function() { return bumpLayer(m, .1); })),
		    layers = stack(d3.range(n).map(function(dat, idx1){
		    	return dataset.map(function(d,idx2){
		    		return {
		    			x: idx2,
		    			y: d[idx1],
		    		};
		    	});
		    })
		    );

		    yGroupMax = d3.max(layers, function(layer) { return d3.max(layer, function(d) { return d.y; }); }),
		    yStackMax = d3.max(layers, function(layer) { return d3.max(layer, function(d) { return d.y0 + d.y; }); });

		console.log(layers);


		var margin = {top: 40, right: 10, bottom: 20, left: 10},
		    width = 960 - margin.left - margin.right,
		    height = 500 - margin.top - margin.bottom;

		var x = d3.scale.ordinal()
				.domain(d3.range(m))
		    .rangeRoundBands([0, width], 0.1);

		var y = d3.scale.linear()
		    .domain([0, yStackMax])
		    .range([height, 0]);

		var color = d3.scale.linear()
		    .domain([0, n - 1])
		    .range(["#aad", "#556"]);

		var xAxis = d3.svg.axis()
		    .scale(x)
		    .tickSize(0)
		    .tickPadding(6)
		    .orient("bottom");

		var svg = d3.select(".current_pain_diagram").append("svg")
		    .attr("width", width + margin.left + margin.right)
		    .attr("height", height + margin.top + margin.bottom)
		    .append("g")
		    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

		var layer = svg.selectAll(".layer")
		    .data(layers)
		    .enter().append("g")
		    .attr("class", "layer")
		    .style("fill", function(d, i) { return color(i); });

		var rect = layer.selectAll("rect")
		    .data(function(d) { return d; })
		  .enter().append("rect")
		    .attr("x", function(d) { return x(d.x); })
		    .attr("y", height)
		    .attr("width", x.rangeBand())
		    .attr("height", 0);

		rect.transition()
		    .delay(function(d, i) { return i * 10; })
		    .attr("y", function(d) { return y(d.y0 + d.y); })
		    .attr("height", function(d) { return y(d.y0) - y(d.y0 + d.y); });

		svg.append("g")
		    .attr("class", "x axis")
		    .attr("transform", "translate(0," + height + ")")
		    .call(xAxis);

		d3.selectAll("input").on("change", change);

		var timeout = setTimeout(function() {
		  d3.select("input[value=\"grouped\"]").property("checked", true).each(change);
		}, 2000);

		function change() {
		  clearTimeout(timeout);
		  if (this.value === "grouped") transitionGrouped();
		  else transitionStacked();
		}

		function transitionGrouped() {
		  y.domain([0, yGroupMax]);

		  rect.transition()
		      .duration(500)
		      .delay(function(d, i) { return i * 10; })
		      .attr("x", function(d, i, j) { return x(d.x) + x.rangeBand() / n * j; })
		      .attr("width", x.rangeBand() / n)
		      .transition()
		      .attr("y", function(d) { return y(d.y); })
		      .attr("height", function(d) { return height - y(d.y); });
		}

		function transitionStacked() {
		  y.domain([0, yStackMax]);

		  rect.transition()
		      .duration(500)
		      .delay(function(d, i) { return i * 10; })
		      .attr("y", function(d) { return y(d.y0 + d.y); })
		      .attr("height", function(d) { return y(d.y0) - y(d.y0 + d.y); })
		      .transition()
		      .attr("x", function(d) { return x(d.x); })
		      .attr("width", x.rangeBand());
		}

		// Inspired by Lee Byron's test data generator.
		function bumpLayer(n, o) {

		  function bump(a) {
		    var x = 1 / (.1 + Math.random()),
		        y = 2 * Math.random() - .5,
		        z = 10 / (.1 + Math.random());
		    for (var i = 0; i < n; i++) {
		      var w = (i / n - y) * z;
		      a[i] += x * Math.exp(-w * w);
		    }
		  }

		  var a = [], i;
		  for (i = 0; i < n; ++i) a[i] = o + o * Math.random();
		  for (i = 0; i < 5; ++i) bump(a);
		  console.log("this is " + a);
		  return a.map(function(d, i) { return {x: i, y: Math.max(0, d)}; });
		}
	}

	var calculateVolumes = function(data_obj, strike_levels){
		console.log(data_obj);
		var call_volumes = [],
				put_volumes = [],
				strike_price_array = [],
				call_sum,
				put_sum;

		var calls = data_obj.calls,
				puts = data_obj.puts;

		for(var close = 0; close < strike_levels; close++){
			var close_price = 0, strike_price = 0, open_interest = 0, oi;
			call_sum = 0, put_sum = 0;

			strike_price_array.push(parseInt(calls[close].strike, 10));

			for(var strike = 0; strike < strike_levels; strike++){

				close_price = parseInt(calls[close].strike, 10);
				strike_price = parseInt(calls[strike].strike, 10);
				oi = calls[strike].oi;

				if ( oi !== "-"){
					open_interest = parseInt(oi, 10);
				}

				if ( close_price > strike_price ){
					call_sum += (close_price - strike_price) * open_interest;
				} else {
					put_sum += (strike_price - close_price) * open_interest;
				}
			}
			  call_volumes.push(call_sum);
				put_volumes.push(put_sum);
		}

		var call_put_volumes = [];

		console.log( "call: " + call_volumes); 
		console.log( "put: " + put_volumes);

		for(var k = 0; k < strike_levels; k++){
			call_put_volumes.push([call_volumes[k],put_volumes[k]]);
		}

		stacked_chart(call_put_volumes, strike_price_array, strike_levels);
		console.log(strike_price_array[47]);
	}

	// var PutCallObj = function(strike, dollar){
	// 	this.x:strike,
	// 	this.y:dollar,
	// };

	// var put_call_objects = function(call_volumes, put_volumes, strike_price_arrays, strike_levels){
	// 	var call_volumes_objs = [],
	// 			put_volumes_objs = [];

	// 	for(var i = 0; i < strike_levels; i++){
	// 		var call_obj = new PutCallObj(strike_price_arrays[i], call_volumes[i]);
	// 		var put_obj = new PutCallObj(strike_price_arrays[i], put_volumes[i]);
	// 		call_volumes_objs.push(call_obj);
	// 		put_volumes_objs.push(put_obj);
	// 	}

	// 	return [call_volumes_objs, put_volumes_objs];
	// }
	
});