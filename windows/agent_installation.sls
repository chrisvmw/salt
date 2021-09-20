# This is a fairly generic Salt state which can be repurposed to install
# agents or applications on Windows minions

# Explanation of Variables
#
# AGENT - Name of the agent as it appears in the Windows "Apps and Features". It will be used
#         to test if the agent is already installed
#
# FILE_TARGET - Location where the agent installer file will be copied to the minion
#
# FILE_SOURCE - Source for the installer file. This can be HTTPS / FTP / S3 / Salt filesystem / etc.
#               In this state, 'salt://' indicates the file is on the SaltStack config VM at /srv/salt.
#
# INSTALL_COMMAND - Switches and options required by the Windows package for installation

# Test if the target minion is running Windows before proceeding
{% if grains.os == 'Windows' %}

# Set variables using the Jinja templating language
#
# For more information on Jinja:
# https://docs.saltproject.io/en/latest/topics/jinja/index.html
{% set AGENT = "IncrediBuild" %}
{% set FILE_TARGET = "C:\IBSetupConsole.exe" %}
{% set FILE_SOURCE = "salt://IBSetupConsole.exe" %}
{% set INSTALL_COMMAND = "/Install /Components=Agent,Coordinator" %}

# Test if the agent is already installed by listing the applications and comparing the output to the
# AGENT variable
#
# For more information on test states:
# https://docs.saltproject.io/en/latest/ref/states/all/salt.states.test.html
{% if AGENT | substring_in_list(salt['pkg.list_pkgs']('versions_as_list=True')) %}
agent_present:
  test.nop:
    - name: {{ AGENT }} is already installed.
    {% set AGENT_ALREADY_INSTALLED = 'Yes' %}
{% else %}
agent_absent:
  test.nop:
    - name: {{ AGENT }} is not present. Installing now.
    {% set AGENT_ALREADY_INSTALLED = 'No' %}
{% endif %}

{% if AGENT_ALREADY_INSTALLED == 'No' %}
# Copy the file to the target minion
#
# More information on file.managed:
# https://docs.saltproject.io/en/latest/ref/states/all/salt.states.file.html#salt.states.file.managed
agent_copy:
  file.managed:
     - name: {{ FILE_TARGET }}
     - source: {{ FILE_SOURCE }}

# Run the agent installer
#
# More information on cmd.run:
# https://docs.saltproject.io/en/latest/ref/states/all/salt.states.cmd.html
agent_install:
  cmd.run:
    - name: {{ FILE_TARGET }} {{ INSTALL_COMMAND }}

# Remove the agent file after installation completes
#
# More information on file.absent:
# https://docs.saltproject.io/en/latest/ref/states/all/salt.states.file.html#salt.states.file.absent
agent_installer_cleanup:
  file.absent:
    - name: {{ FILE_TARGET }}

{% endif %}

{% endif %}
