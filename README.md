baker.sh
========

Bash scripts for scripted server deployments on Openstack.

Dependencies
============

supernova. pip install it. rackspace-novaclient or python-novaclient also recommended.

Gotchas
=======

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
