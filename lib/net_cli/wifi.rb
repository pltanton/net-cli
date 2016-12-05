require 'net_cli/system_utils'
require 'net_cli/template_generator'

class Wifi < Thor
  option :essid
  option :hidden, type: :boolean
  option :iface
  option :type
  desc 'new OPTIONS', 'generates net entry in /etc/netctl/'
  def new
    iface = options[:iface] || SystemUtils::wlan_iface
    puts iface
    wlan_list = SystemUtils::wlan_list iface
    p wlan_list
  end
end
