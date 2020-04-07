import os

import testinfra.utils.ansible_runner

# https://testinfra.readthedocs.io/en/latest/modules.html

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('instance')

def test_services_running(host):
    nginx = host.process.filter(user='www-data', comm='nginx')
    phpfpm = host.process.filter(user='cycloid', comm='php-fpm7.2')
    fluentd = host.process.filter(user='root', comm='fluentd')
    telegraf = host.process.filter(user='telegraf', comm='telegraf')

    assert len(nginx) >= 1
    assert len(phpfpm) >= 1
    assert len(fluentd) >= 1
    assert len(telegraf) >= 1

def test_telegraf(host):
    r = host.ansible("uri", "url=http://localhost:9100/metrics return_content=yes", check=False)

    assert '# HELP' in r['content']

def test_nginx_vhosts(host):
    nginx_metrics = host.ansible("uri", "url=http://127.0.0.1/fpm-status return_content=yes", check=False)
    application = host.ansible("uri", "url=http://127.0.0.1/ return_content=yes headers={'Host':'application.com'}", check=False)
    healthcheck = host.ansible("uri", "url=http://127.0.0.1/health-check return_content=yes headers={'Host':'application.com'}", check=False)

    assert 'pool' in nginx_metrics['content']
    assert 'lemp website' in application['content']
    assert 'ok' in healthcheck['content']
