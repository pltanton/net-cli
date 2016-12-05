require 'thor'
require 'net_cli/template_generator'
require 'net_cli/wifi'

class NetCli < Thor
  desc 'wifi SUBCOMMAND ...ARGS', 'manage wifi connections'
  subcommand 'wifi', Wifi
end
