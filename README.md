# Modify instance attribute.

## Change DeleteOnTermination attribute for the volume

    Parker.connection.compute.modify_instance_attribute('i-37b57058', {'BlockDeviceMapping.2.DeviceName' => '/dev/sdf', 'BlockDeviceMapping.2.Ebs.DeleteOnTermination' => 'true'})

# Parker

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'parker'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install parker

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
