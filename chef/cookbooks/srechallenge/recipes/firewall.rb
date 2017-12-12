include_recipe "firewall"

firewall_rule 'ssh' do
  port     22
  command  :allow
end

firewall_rule 'http/https' do
  protocol :tcp
  port     [80, 443]
  command  :allow
end