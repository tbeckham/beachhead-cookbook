
.PHONY: all berkspkg chefdk clean distclean rpmbuild seddeps



all: berkspkg rpmbuild

berkspkg:
	/usr/bin/berks package bc.tgz
	/usr/bin/tar xzvf bc.tgz >/dev/null 2>&1

chefdk:
	/usr/bin/curl -L https://omnitruck.chef.io/install.sh | bash -s -- -P chefdk -v 0.13

clean:
	rm -rf cookbooks nodes bc.tgz Berksfile.lock >/dev/null 2>&1

distclean:
	rm -rf /tmp/beachhead_dependencies/ >/dev/null 2>&1

rpmbuild: clean berkspkg
	chef-client -z -r bc.tgz -o "recipe[beachhead-cookbook::create_beachhead_archive]"
	#rpmbuild --define '_sourcedir /tmp/beachhead_dependencies/' -bs beachhead.spec
	#mock --no-cleanup-after --resultdir=. -r ../rhel-7-x86_64.cfg rebuild /root/rpmbuild/SRPMS/eucalyptus-beachhead-0.1.0-0.el7.centos.src.rpm

seddeps:
	sed -i.bak "s#/tmp/beachhead_dependencies#dependencies#" attributes/default.rb
