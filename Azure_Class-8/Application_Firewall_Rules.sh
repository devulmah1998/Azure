#Application rules used to allow traffic for websites and deny traffic for webistes based on website category or specific one webiste.
# We can see in the below pics how to route traffic to webites and deny to them.
# Allow all traffic to sp1 and sp2 by providing the sp1 and sp2 vnet ip ranges and destination would be all so we can enter *
# Destination type would be FQDN.
# Protocal would be http,https
# It allow all webiste access to sp1 and sp2 network through hub firewall.
# While creating policies we are used to give priority number like 1000, 900, 800, which number is small it will execute first.
# Rule collection action : we have 2 options here one is allow, 2nd one is deny.
# Rule colection type is : application 
# Based on web category(Destination type)  we can block the traffic to websites.
# 