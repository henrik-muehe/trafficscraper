define 'app',['controllers/traffic_graph'], (TrafficGraph) ->
	route=window.location.search?.replace("?","") || "muc"
	new TrafficGraph "#traffic_inbound", {url:"/traffic_#{route}_inbound.txt"}
	new TrafficGraph "#traffic_outbound", {url:"/traffic_#{route}_outbound.txt"}
