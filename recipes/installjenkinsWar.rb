bash 'jenkins.war' do
  cwd '/home'
  code 'java -Djenkins.install.runSetupWizard=false -jar jenkins.war'
end
