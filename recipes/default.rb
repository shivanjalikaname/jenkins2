# Copyright:: 2017, The Authors, All Rights Reserved.

execute 'jenkins.war' do
	command 'wget https://updates.jenkins-ci.org/download/war/2.68/jenkins.war'
#	not_if {File.exists?('/')}
end

execute 'jenkins-war' do
	command 'java -Djenkins.install.runSetupWizard=false -jar jenkins.war'
end

execute 'jenkinc-cli' do
	command 'http://localhost:8080/jnlpJars/jenkins-cli.jar'
	not_if {File.exists?('/root')}
end

execute 'jenkins-plugins' do
	command 'java -jar jenkins-cli.jar -s http://localhost:8080 -auth shivanjali:fe1e7afe393ca299baf1446467fe7898 install-plugin Claim CppCheck Git Findbugs HGCA HTMLPublisher'
end	
