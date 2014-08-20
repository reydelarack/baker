baker.sh
========

Bash scripts for scripted server deployments on Openstack.

Dependencies
============

supernova. pip install it. Also install rackspace-novaclient (metapackage), or python-novaclient if not on Rackspace.

Setting up Supernova for Rackspace
==================================

~/.supernova:

```
[account-region]
NOVA_URL=https://identity.api.rackspacecloud.com/v2.0/
NOVA_RAX_AUTH=1
NOVA_REGION_NAME=REGION
NOVA_SERVICE_NAME=cloudServersOpenStack
NOVA_USERNAME=USERNAME
OS_PASSWORD=APIKEY
OS_TENANT_ID=ACCOUNTNUMBER
OS_AUTH_SYSTEM=rackspace
```

You can make multiple of those entries per datacenter if you like. Use lon.identity for NOVA_URL on UK accounts.

Protip: Make a [default] account/region. Some recipies use this as a feature.

Gotchas
=======

Generate an SSH key if you don't already have it. This will use the "default" key of ~/.ssh/id_rsa{,.pub}.

baker.sh nukes the server after you log out or the script is done. You can
prevent this by making sure the server is still accessible (at least momentarily)
after logout, and touching /root/.baker_preserve.

Nifty features
==============

baker.sh will log you directly into the server if you don't give it a script
argument.

Examples
========

 * baker.sh account # Boots FreeBSD performance1-1 server, works for Rackspace.
 * baker.sh account imageuuid flavor

Example recipies
================

 * https://github.com/teran-mckinney/bitnoder
 * https://github.com/teran-mckinney/freebsd-flash-plugin

Installation
============

Symlink baker.sh to your $PATH.
