# /srv/salt/

# Borrowed from Cody's site:
# https://thebluesnevrdie.github.io/salt-presentations/mini-workshop/

{% if grains.os_family == 'RedHat' %}
{% set web_path = '/usr/share/nginx' %}
{% set config_path = '/etc/nginx/default.d/test.conf' %}
{% elif grains.os_family == 'Debian' %}
{% set config_path = '/etc/nginx/sites-available/default' %}
{% set web_path = '/var/www' %}
{% endif %}

install_nginx_package:
  pkg.installed:
    - name: nginx

nginx_running:
  service.running:
    - name: nginx
    - require:
      - install_nginx_package

nginx_index_file:
  file.managed:
    - name: {{ web_path }}/html/index.html
    - source: salt://nginx_install/files/index.html.jinja
    - template: jinja
    - require:
      - install_nginx_package
