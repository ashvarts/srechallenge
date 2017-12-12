control 'Firewall is enabled and only allowing ssh and web traffic' do
  expected_rules = [
    %r{Status: active},
    %r{deny \(incoming\)},
    %r{22/tcp + ALLOW IN + Anywhere},
    %r{80,443/tcp + ALLOW IN + Anywhere},
    %r{22/tcp \(v6\) + ALLOW IN + Anywhere},
    %r{80,443/tcp \(v6\) + ALLOW IN + Anywhere},
  ]
  describe service('ufw') do
    it { should be_enabled }
    it { should be_running }
  end

  describe command('ufw status verbose') do
    its(:stdout) { should include 'Status: active' }
    its(:stdout) { should include 'deny (incoming)' }
    expected_rules.each do |r|
      its(:stdout) { should match(r) }
    end
  end
end