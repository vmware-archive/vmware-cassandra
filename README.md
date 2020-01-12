# VMware has ended active development of this project, this repository will no longer be updated.

# Cassandra Module
===

This module installs Apache Cassandra.

## Installation
On the Puppet Master server:

$ cd /etc/puppetlabs/puppet/modules
$ git clone https://github.com/VMop/vmware-cassandra.git

## Usage
For a standard install use:

```puppet
node 'node1.local' {
  include cassandra
}
```

# To install Opscenter Community Edition on a node

```puppet
node 'node1.local' {
  include cassandra::opscenter
}
```

## Contributing
 1. Fork it
 2. Create your feature branch (git checkout -b my-new-feature)
 3. Commit your changes (git commit -am 'Add some feature')
 4. Push to the branch (git push origin my-new-feature)
 5. Create new Pull Request

## LICENSE
===
******************************************************

Copyright (c) 2012 VMware, Inc. All rights reserved.

******************************************************
