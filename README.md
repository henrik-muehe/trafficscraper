Traffic / Commute Time Screenscraper
====================================================

Work in progress, for monitoring commute time on a given route.

Deploy
------

	git clone https://github.com/henrik-muehe/trafficscraper.git
	cd trafficscraper
	make install

Then find a mysql database, load `traffic.sql`, adjust `config.coffee`, `make`, add cronjobs
which run the two following commands:

	node traffic "from" "to" > traffic_VARIABLE_inbound.log
	node traffic "to" "from" > traffic_VARIABLE_outbound.log

Then you should be all set. You can access the record at http://localhost:8080/?VARIABLE.

This -- honestly -- is not made for massive deployment and ease of use. Push
requests -- as always -- welcome.


LICENSE
=======

Copyright 2013 by Henrik Mühe <muehe@in.tum.de>

The code is licensed under the GNU Affero General Public License 3
