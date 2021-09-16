#
# /ib.sls
#
# https://incredibuild.atlassian.net/wiki/spaces/IUM/pages/17629701/Silent+Installation?showComments=true&showCommentArea=true
 
{% set IB_FILE_TARGET = "C:\\IBSetupConsole.exe" %}
{% set IB_FILE_SOURCE = "salt://IBSetupConsole.exe" %}
{% set IB_INSTALL_COMMAND = "/Install /Components=Agent,Coordinator" %}
{% set IB_INSTALL_FILE_PATH = "C:\IBSetupConsole.exe" %}
 
ib_copy:
  file.managed:
     - name: {{ IB_FILE_TARGET }}
     - source: {{ IB_FILE_SOURCE }}
 
ib_install:
  cmd.run:
    - name: {{ IB_INSTALL_FILE_PATH }} {{ IB_INSTALL_COMMAND }}
