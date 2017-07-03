#
# Cookbook:: jenkins
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

# yum_repository "jenkins" do
#    description "repository for jenkins"
#    baseurl "http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo"
#    gpgkey "http://pkg.jenkins-ci.org/redhat-stable/jenkins-ci.org.key"
#    action :add
# end

  execute 'jenkins-repo' do
   command 'rpm --import http://pkg.jenkins-ci.org/redhat-stable/jenkins-ci.org.key'
  end

  execute 'jenkins-repo' do
   command 'wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo'
  end 

 yum_package "jenkins" do
   action :install
 end

 service 'jenkins' do
    action [:start, :enable]
 end

