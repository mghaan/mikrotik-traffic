#!/usr/bin/perl
package main;

use strict;
use utf8;
use CGI;
use POSIX;
use DBD::SQLite;

print "HTTP/1.0 200 OK\n";
print "Content-Type: text/plain; charset=utf-8\n";
print "\n";

my $cgi = CGI->new;

my $rx = $cgi->param("rx");
$rx =~ s/ //g;

my $tx = $cgi->param("tx");
$tx =~ s/ //g;

my $id = $cgi->param("id");

my $ts = time;

if ($rx eq "" || $tx eq "" || $id eq "") {
    print "ERROR\n";
}
else {
    $rx = sprintf("%d", $rx);
    $tx = sprintf("%d", $tx);
    $id = sprintf("%d", $id);

    my $db = DBI->connect("dbi:SQLite:dbname=mikrotik.sqlite", "", "");
    my $sql = "with lastval as (select tx,rx from traffic where device = " . $id . " order by timestamp desc limit 1) insert into traffic (device, timestamp, tx, rx, dtx, drx) values (" . $id . ", " . $ts . ", " . $tx . ", " . $rx . ", case when " . $tx . " >= (select tx from lastval) then " . $tx . " - (select tx from lastval) else " . $tx . " end, case when " . $rx . " >= (select rx from lastval) then " . $rx . " - (select rx from lastval) else " . $rx . " end)";
    $db->do($sql);

    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
    my $timestamp = mktime(0, 0, 0, $mday, $mon-2, $year);
    $sql = "delete from traffic where timestamp <= " . $timestamp;
    $db->do($sql);

    $db->disconnect();

    print "OK\n";
}