# /patching/linux/init.sl

{% set upgrades = salt['pkg.list_upgrades']() %}

{% if upgrades | length %}
install_upgrades:
  pkg.latest:
    - refresh: True
    - pkgs: '
{% for pkg in upgrades.keys() %}
      - {{ pkg }}
{% endfor %}
    '
{% else %}
upgrade_list_empty:
  test.configurable_test_state:
    - result: True
    - changes: False
    - comment: No upgradable packages found, or other enumeration error.
{% endif %}
