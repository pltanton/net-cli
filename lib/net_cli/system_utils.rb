# frozen_string_literal: true
# Utils to communicate with system
module SystemUtils
  # Returns first wlp iface from iwconfig
  def self.wlan_iface
    `ls /sys/class/net | grep wl`.split.first
  end

  # Returns list of triple about each founded network in format [essid,
  # level, encryption type].
  def self.wlan_list(iface)
    `iwlist #{iface} scan`
      .split(/\n(?=\s+Cell)/)[1..-1]
      .map { |e| e.split("\n").map(&:strip) }
      .map { |e| parse_wlan_entity e }
      .sort_by { |e| -e[1] }
  end

  def self.parse_wlan_entity(element)
    essid = nil
    level = nil
    type = nil
    element.each do |row|
      essid = row[/(?<=ESSID:").*(?="$)/] unless essid
      level = row[/(?<=Signal level=)\-\d+(?=\sdBm$)/]&.to_i unless level
      type = parse_enc_type row unless type
    end
    [essid, level, type]
  end
  private_class_method :parse_wlan_entity

  def self.parse_enc_type(row)
    if row.include? 'WPA'
      :wpa
    elsif row.include? 'WEP'
      :wep
    elsif row.include? 'Encryption key:off'
      :none
    end
  end
  private_class_method :parse_enc_type
end
