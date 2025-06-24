1) OSI Layers.
2) TCP and UDP protocals.
3) Type of azure load balancers. regional and global loadbalancers.

1) OSI layers
---------------
1) Application layer  -- http/https Application gateway or loayer 7 load balancers.
2) Presentation layer --
3) Session layer      --- 
4) Transport layer    -- TCP and UDP ---> azure load balancers or layer 4 load balancer
5) Network layer       --
6) data link layer     -- switches and VLAN's
7) Phisical layer      -- phisycal devices 

2) TCP and UDP Protocal:  Internet traffic from browser.
------------------------
TCP -->> The TCP (Transmission Control Protocol) is one of the core protocols of the Internet Protocol (IP) suite. It is a connection-oriented, reliable protocol that ensures data is delivered in order and without loss between computers over a network.

==> Before data transfer, TCP establishes a reliable connection between two devices (Client and Server) using a three-step process
Data Transmission:-
Once the connection is established:
Data is broken into packets.
Each packet has a sequence number.
The receiver sends back an ACK for each packet received.

UDP : -  webcam , video games, 
--------
The UDP (User Datagram Protocol) is a connectionless, lightweight, and fast transport layer protocol used for sending data without establishing a connection.

==> Unlike TCP, UDP doesn’t guarantee delivery, order, or error checking. But it is very useful when speed matters more than reliability—like in live video streaming, gaming, or DNS queries.

==> No Handshake.
==> UDP does not establish a connection before sending data.
==> It simply sends datagrams (packets) to the recipient.

Types of Load balancers:-
--------------------------
Load balancers can be classified into 2 types one is regional load balancers and 2nd one is Global load balancer.

Regional load balancers: vNET specified LB's, There are 2 types of load balancers in regional one.
       1) Azure Load balancers which is for TCP and UDP Based Traffic, Operate at layer 4.
       2) Azure Application gateway http(80)/https(443) load applications. Operates at layer 7.

==>> Azure load balancers main use case is UDP based traffic, 
==>> Azure application gateway load balncer does not support UDP protocal.
==>  We can not compare these two load balancers becoz they have different type of purposes of some on eask about which one is usefull we can't compare like this.



Global Load balancers:
----------------------
1) Azure Traffic manager --> DNS based load balancer between regions.
2) Azure Frontdoor  --> same as application load balancer but global scale

