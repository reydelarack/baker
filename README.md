baker
=====

Bash scripts for scripted server deployments via Openstack

Dependencies
============

supernova. pip install it. rackspace-novaclient or python-novaclient also recommended.

Gotchas
=======

baker.sh nukes the server after you log out or the script is done. Don't use it if you
want persistent servers.
