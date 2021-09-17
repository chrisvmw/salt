# /app-installation/windows/install_base_windows_packages.sls

{% if grains.os == 'Windows' %}

Install_filezilla:
  pkg.installed:
    - name: filezilla

Install_firefox:
  pkg.installed:
    - name: firefox_x64

Install_keepass:
  pkg.installed:
    - name: keepass-2x

Install_putty:
  pkg.installed:
    - name: putty

{% endif %}
