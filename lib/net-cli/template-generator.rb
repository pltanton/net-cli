class NetCli::TemplateGenerator
  ##
  # This method generates a configuration for for wireless connection.
  #
  # Arguments:
  #   type: type of wireless connection it could be _:open_, _:wpa_ or _:wep_
  #
  #   interface: an interface to configure
  #
  #   essid: ESSID of wireless network
  #
  # Optional arguments:
  #   ip: ip to bind dhcp used by default
  #   hidden: by default false
  def self.wireless(type, interface, essid, ip: 'dhcp', hidden: false,
                    adhoc: false, kwargs)
    result = <<~HEREDOC
      Description='Autogenerated configuration by net-cli'
      Interface=#{interface}
      Connection=wireless

      IP=#{ip}
      ESSID='#{essid}'
      #{'Hidden=yes' if hidden}
      #{'AdHoc=yes' if adhoc}
      #{"Priority=#{kwargs[:proirity]}" if kwargs[:priority]}

    HEREDOC
    result += if %i(wpa wep).include? type
      <<~HEREDOC
        Security=#{type.to_s}
        Key=\"#{kwarks[:key]}
      HEREDOC
    else
      "Security: none\n"
    end
  end
end
