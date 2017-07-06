remote_file '/home/jenkins-cli.jar' do
  source 'http://localhost:8080/jnlpJars/jenkins-cli.jar'
  not_if 'grep jenkins-cli.jar', :cwd => '/home'
end

execute 'jenkins-plugins' do
   command 'java -jar jenkins-cli.jar -s http://localhost:8080 -auth shivanjali:ee54abad6721146b15e03dbbcedbc6aa install-plugin Claim CppCheck Git Findbugs HGCA HTM$'
end
