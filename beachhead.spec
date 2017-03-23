%{!?python_sitelib: %global python_sitelib %(%{__python} -c "from distutils.sysconfig import get_python_lib; print get_python_lib()")}

Summary:       Eucalyptus cloud platform
Name:          eucalyptus-beachhead
Version:       0.1.0
Release:       0%{?build_id:.%build_id}%{?dist}
License:       GPLv3
URL:           http://www.eucalyptus.com

BuildRequires: python-devel
BuildRequires: python-setuptools

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

%changelog
* Thu Mar 23 2017 Matt Bacchi <mbacchi@hpe.com> - 0.1.0
- Initial packaging.
