remote_file '/home/jenkins.war' do
  source 'https://updates.jenkins-ci.org/download/war/2.68/jenkins.war'
  action :create_if_missing
end

