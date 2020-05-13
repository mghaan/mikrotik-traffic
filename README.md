# mikrotik-traffic
MikroTik traffic stats and counter

## About

This is a set of files to collect network traffic from a Mikrotik device and to display the data in a nice graph. Mikrotik sends the data via HTTP to your own web server (e.g. Nginx) where the data is stored and processed via Perl scripts. Collection of HTML/Javascript then shows the data in a graph.

![graph](https://raw.githubusercontent.com/mghaan/mikrotik-traffic/master/mikrotik.png "Sample graph")

What's included:

* scripts for MikroTik to send data
* empty SQLite database to store data
* Nginx configuration file
* Perl scripts to collect and process data
* HTML/Javascript to show the graph

	This README is still yet incomplete.