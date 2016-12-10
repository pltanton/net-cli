require 'net_cli/system_utils'
require 'net_cli/template_generator'

class Wifi < Thor
  desc 'add', 'interactive generates net entry in /etc/netctl/'
  def new
    iface = options[:iface] || SystemUtils::wlan_iface
    ip = options[:ip] || 'dhcp'
    wlan_list = SystemUtils::wlan_list iface
    answer = ask_about_lan wlan_list
    wlan = wlan_list[answer]
    key = ask_about_password wlan
    puts TemplateGenerator::wireless type: wlan[0], essid: wlan[2], ip: ip,
                                     key: key
  end

  private

  def ask_about_lan(wlan_list)
    puts 'Please select a network'
    wlan_list.each_with_index do |entity, i|
      puts ('%2i) %-15s %3i dBm [%s]' % ([i] + entity))
    end
    ask('Please select:').to_i
  end

  def ask_about_password(wlan)
    retun if wlan[2] == :none
    ask 'Put a password:'
  end
end
