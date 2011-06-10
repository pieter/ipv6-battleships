IPv6 Battleships
----------------

This is an implementation of Battleships using ICMPv6 ping request/reply commands. It was written as an entry for the IPv6 competition for ipv6day.nl. It was created in a few hours time, so they code is pretty hackish.

Every user playing the game will get 100 IPv6 addresses assigned to their interface. When a user hits the other player, they send an ICMP echo request. If the target is part of a ship, it will get replied with an ICMP echo reply. If not, the user will get an ICMP unreachable message. The game has a battlelog which allows you to follow what happens on the networking side.


Implementation
==============

The networking part is written in Ruby. The interface side is written in Objective-C. The two are tied together using MacRuby, which you will need to have installed to compile and run the program. If you don't have MacRuby, you can download a version of Battleships from the 'downloads' section in Github, which bundles it by default. Note that the application requires root access.

The networking code may also run on FreeBSD, but I doubt it. For the interface you'll need at least Mac OS X Snow Leopard on a 64-bit machine (Core 2 or better).
Graphics
========

The graphics were made by Kim Does <ipv6@kdoes.nl>.

Screenshot
==========

<img src="https://github.com/pieter/ipv6-battleships/raw/master/images/img2.png">