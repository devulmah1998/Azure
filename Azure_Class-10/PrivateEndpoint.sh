#When we are diable the public access on the keyvaults we can not connect to the internet.
# ns keyvault1-mahesh.vault.azure.net
# so if we want to communicate internal services here we are creating azure private end point service.
# create private end point
# it will create one interface.
# traffic is routed to jumpserver to privateendpoint interface than name resolution than route to keyvalut.
