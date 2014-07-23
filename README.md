baker.sh
========

Bash scripts for scripted server deployments on Openstack.

Dependencies
============

supernova. pip install it. rackspace-novaclient or python-novaclient also recommended.

Gotchas
=======

Needs ~/.ssh/id_rsa.pub. nova keypair should probably be removed in advance
as bootng.sh expects it to be in a certain format.

baker.sh nukes the server after you log out or the script is done. You can
prevent this by making sure the server is still accessible (at least momentarily)
after logout, and touching /root/.baker_preserve.

Nifty features
==============

baker.sh will log you directly into the server if you don't give it a script
argument.

Installation
============

Symlink baker.sh to your $PATH.
