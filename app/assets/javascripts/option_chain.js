// $(function(){
// 	var format_data, data_obj, option_symbol,strike_levels,strike_price_start, strike_price_end;

// 	$('.option_chains').on('click', function(){
// 	  option_symbol = $('#option_symbol').val();
// 	  console.log(option_symbol);
// 	  directToOpts(option_symbol);
// 	});

// 	var directToOpts = function(option_symbol){
// 	  $.ajax({
// 	              type: "GET",
// 	              url: '/option_chains/' + option_symbol,
// 	              dataType: 'json',
// 	              success: function (data) {
// 	                 console.log('hello');
// 	                 format_data = JSON.stringify(eval("(" + data + ")"));
// 	                 data_obj = JSON.parse(format_data);
// 	                 expiration_date = data_obj.calls[0].expiry;
// 	                 strike_levels = data_obj.calls.length;
// 	                 strike_price_start = data_obj.calls[0].strike;
// 	                 strike_price_end = data_obj.calls[strike_levels-1].strike;
// 	                 downloadOptionsChains(data_obj, option_symbol, expiration_date);
// 	                 calculateVolumes(data_obj, strike_levels);
// 	              },
// 	              error: function (result) {
// 	                  console.log('world');
// 	                  error();
// 	              }
// 	  });
// 	}

// 	var downloadOptionsChains = function(data_obj, option_symbol, expiration_date){
//       $.ajax({
//                   type: "POST",
//                   url: '/download_option_chains',
//                   data: { option_chain: {symbol: option_symbol, option_chains: data_obj, expiration_date: expiration_date}},
//                   dataType: 'json',
//                   success: function (data) {
//                      console.log('success');
//                   },
//                   error: function (result) {
//                       console.log('bad');
//                       error();
//                   }
//       });
// 	}

// 	var stacked_chart = function(call_put_volumes, strike_price_array, strike_levels){
// 		var margin = {top: 20, right: 20, bottom: 30, left: 40},
// 		    width = 960 - margin.left - margin.right,
// 		    height = 500 - margin.top - margin.bottom;

// 		var x = d3.scale.ordinal()
// 		    .rangeRoundBands([0, width], .1);

// 		var y = d3.scale.linear()
// 		    .rangeRound([height, 0]);

// 		var color = d3.scale.ordinal()
// 		    .range(["#98abc5", "#8a89a6", "#7b6888", "#6b486b", "#a05d56", "#d0743c", "#ff8c00"]);

// 		var xAxis = d3.svg.axis()
// 		    .scale(x)
// 		    .orient("bottom");

// 		var yAxis = d3.svg.axis()
// 		    .scale(y)
// 		    .orient("left")
// 		    .tickFormat(d3.format(".2s"));

// 		var svg = d3.select(".current_pain_diagram").append("svg")
// 		    .attr("width", width + margin.left + margin.right)
// 		    .attr("height", height + margin.top + margin.bottom)
// 		    .append("g")
// 		    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

// 	var data = call_put_volumes;

// 		  x.domain(data.map(function(d) { return d.strike; }));
// 		  y.domain([0, d3.max(data, function(d) { return d.total; })]);

// 		  svg.append("g")
// 		      .attr("class", "x axis")
// 		      .attr("transform", "translate(0," + height + ")")
// 		      .call(xAxis);

// 		  svg.append("g")
// 		      .attr("class", "y axis")
// 		      .call(yAxis)
// 		    .append("text")
// 		      .attr("transform", "rotate(-90)")
// 		      .attr("y", 6)
// 		      .attr("dy", ".71em")
// 		      .style("text-anchor", "end");

// 		  var strike = svg.selectAll(".strike")
// 		      .data(data)
// 		      .enter().append("g")
// 		      .attr("class", "g")
// 		      .attr("transform", function(d) { return "translate(" + x(d.strike) + ",0)"; });

// 		  strike.selectAll("rect")
// 		      .data(function(d) { return d.call_and_put; })
// 		      .enter().append("rect")
// 		      .attr("width", x.rangeBand())
// 		      .attr("y", function(d) { return y(d.y1); })
// 		      .attr("height", function(d) { return y(d.y0) - y(d.y1); })
// 		      .style("fill", function(d) { return color(d.type); });

// 		  var legend = svg.selectAll(".legend")
// 		      .data(color.domain().slice().reverse())
// 		      .enter().append("g")
// 		      .attr("class", "legend")
// 		      .attr("transform", function(d, i) { return "translate(0," + i * 20 + ")"; });

// 		  legend.append("rect")
// 		      .attr("x", width - 18)
// 		      .attr("width", 18)
// 		      .attr("height", 18)
// 		      .style("fill", color);

// 		  legend.append("text")
// 		      .attr("x", width - 24)
// 		      .attr("y", 9)
// 		      .attr("dy", ".35em")
// 		      .style("text-anchor", "end")
// 		      .text(function(d) { return d; });

// 	}

// 	var calculateVolumes = function(data_obj, strike_levels){
// 		console.log(data_obj);
// 		var call_volumes = [],
// 				put_volumes = [],
// 				strike_price_array = [],
// 				call_sum,
// 				put_sum;

// 		var calls = data_obj.calls,
// 				puts = data_obj.puts;

// 		for(var close = 0; close < strike_levels; close++){
// 			var close_price = 0, strike_price = 0, open_interest = 0, oi;
// 			call_sum = 0, put_sum = 0;

// 			strike_price_array.push(parseFloat(calls[close].strike, 10));

// 			for(var strike = 0; strike < strike_levels; strike++){

// 				close_price = parseFloat(calls[close].strike, 10);
// 				strike_price = parseFloat(calls[strike].strike, 10);
// 				oi = calls[strike].oi;

// 				if ( oi !== "-"){
// 					open_interest = parseFloat(oi, 10);
// 				}

// 				if ( close_price > strike_price ){
// 					call_sum += (close_price - strike_price) * open_interest;
// 				} else {
// 					put_sum += (strike_price - close_price) * open_interest;
// 				}
// 			}
// 			  call_volumes.push(call_sum);
// 				put_volumes.push(put_sum);
// 		}

// 		var call_put_volumes = [];

// 		console.log( "call: " + call_volumes); 
// 		console.log( "put: " + put_volumes);

// 		for(var k = 0; k < strike_levels; k++){
// 			call_put_volumes.push(
// 				{
// 					strike: strike_price_array[k],
// 					call_and_put: [
// 						{
// 							type: "Call",
// 							y0: 0,
// 							y1: parseInt(call_volumes[k])
// 						},
// 						{
// 							type: "Put",
// 							y0: parseInt(call_volumes[k]),
// 							y1: parseInt(call_volumes[k])+parseInt(put_volumes[k])
// 						}
// 					],
// 					total: call_volumes[k] + put_volumes[k]
// 				});
// 		}

// 		stacked_chart(call_put_volumes, strike_price_array, strike_levels);
// 		console.log(call_put_volumes);
// 	}

// 	// var put_call_objects = function(call_volumes, put_volumes, strike_price_arrays, strike_levels){
// 	// 	var call_volumes_objs = [],
// 	// 			put_volumes_objs = [];

// 	// 	for(var i = 0; i < strike_levels; i++){
// 	// 		var call_obj = new PutCallObj(strike_price_arrays[i], call_volumes[i]);
// 	// 		var put_obj = new PutCallObj(strike_price_arrays[i], put_volumes[i]);
// 	// 		call_volumes_objs.push(call_obj);
// 	// 		put_volumes_objs.push(put_obj);
// 	// 	}

// 	// 	return [call_volumes_objs, put_volumes_objs];
// 	// }
	
// });