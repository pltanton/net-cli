module SystemUtils
  # Returns first wlp iface from iwconfig
  def self.wlan_iface
    `iwconfig | grep wlp`.split.first
  end

  def self.wlan_list(iface)
    result = []
    `iwlist #{iface} scan | grep 'Frequency\\|ESSID'`
      .split("\n").map(&:strip).each_slice 2 do |a, e|
      result << {
        essid: e[/^ESSID:"(.*)"$/, 1],
        freq: a[/^Frequency:(\d+\.\d+) GHz .*/, 1]&.to_f
      }
    end
    result.sort_by { |e| -e[:freq] }
  end
end
