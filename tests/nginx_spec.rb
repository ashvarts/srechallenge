control 'Nginx is listening on ports 80, 443' do
  describe service('nginx') do
    it { should be_enabled }
    it { should be_running }
  end

  describe port(80) do
    it { should be_listening }
  end

  describe port(443) do
    it { should be_listening }
  end
end

# redirect tests
web_public_ip = ENV['SRE_CHALLENGE_PUBLIC_IP']
control 'Requests over http is redirected to https' do
  describe http("http://#{web_public_ip}") do
    its('status') { should eq 301 }
    its('headers.location') {should eq "https://#{web_public_ip}/"}
  end
end

control 'Request over http returns home page' do
  describe http("https://#{web_public_ip}/", ssl_verify: false) do
    its('status') {should eq 200}
    its('body') {should include "<title>Hello World</title>" }
  end
end