%{!?python_sitelib: %global python_sitelib %(%{__python} -c "from distutils.sysconfig import get_python_lib; print get_python_lib()")}

Summary:       Eucalyptus cloud platform
Name:          eucalyptus-beachhead
Version:       0.1.0
Release:       0%{?build_id:.%build_id}%{?dist}
License:       GPLv3
URL:           http://www.eucalyptus.com

BuildRequires: python-devel
BuildRequires: python-setuptools

Requires: httpd

Source0: /tmp/beachhead_dependencies/eucalyptus_dependencies.tar.xz

%description

Eucalyptus beachhead is an RPM with a tar.xz archive containing 
all components required to install Eucalyptus in your environment
with ZERO internet connectivity.

%install
mkdir -p %{buildroot}/tmp/beachhead_dependencies/
install -p -m 755 %{SOURCE0} %{buildroot}/tmp/beachhead_dependencies/

%files
%defattr(755,root,root,755)
%attr(-,root,root) /tmp/beachhead_dependencies/eucalyptus_dependencies.tar.xz

%pre
touch /etc/yum.repos.d/beachhead.repo
echo "[beachhead-repo]" >> /etc/yum.repos.d/beachhead.repo
echo "name=beachhead-repo" >> /etc/yum.repos.d/beachhead.repo
echo "baseurl=http://localhost/beachhead_dependencies/rpms/" >> /etc/yum.repos.d/beachhead.repo
echo "enabled=1" >> /etc/yum.repos.d/beachhead.repo
echo "gpgcheck=0" >> /etc/yum.repos.d/beachhead.repo
touch /etc/httpd/conf.d/beachhead-repo.conf
echo "<Directory \"/var/www/html/beachhead_dependencies/rpms\">" >> /etc/httpd/conf.d/beachhead-repo.conf
echo "Options +Indexes" >> /etc/httpd/conf.d/beachhead-repo.conf
echo "</Directory>" >> /etc/httpd/conf.d/beachhead-repo.conf
exit 0

%post
tar -C /tmp/beachhead_dependencies/ -xJvf /tmp/beachhead_dependencies/eucalyptus_dependencies.tar.xz > /dev/null 2>&1
mv /tmp/beachhead_dependencies /var/www/html/
chown -R apache:apache /var/www/html/beachhead_dependencies/
systemctl start httpd > /dev/null 2>&1
exit 0

%preun
systemctl stop httpd > /dev/null 2>&1
rm /etc/yum.repos.d/beachhead.repo
rm /etc/httpd/conf.d/beachhead-repo.conf
exit 0

%changelog
* Thu Mar 23 2017 Matt Bacchi <mbacchi@hpe.com> - 0.1.0
- Initial packaging.
