import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('instance')

def test_services_running(host):
    nginx = host.process.filter(user='www-data', comm='nginx')

    assert len(nginx) >= 1

def test_prometheus_homepage(host):
    r = host.ansible("uri", "url=http://localhost:9090/graph return_content=yes", check=False)

    assert '<title>Prometheus' in r['content']

def test_alertmanager_homepage(host):
    r = host.ansible("uri", "url=http://localhost:9093/#/alerts return_content=yes", check=False)

    assert '<title>Alertmanager' in r['content']

def test_grafana(host):
    r = host.ansible("uri", "url=http://localhost:3000/login return_content=yes", check=False)
    r_datasources = host.ansible("uri", "url=http://localhost:3000/api/datasources force_basic_auth=yes user=admin password=admin return_content=yes", check=False)

    assert '<title>Grafana' in r['content']
    assert 'prometheus' in r_datasources['content']

def test_telegraf(host):
    r = host.ansible("uri", "url=http://localhost:9100/metrics return_content=yes", check=False)

    assert '# HELP' in r['content']

def test_nginx_vhosts(host):
    prometheus = host.ansible("uri", "url=http://localhost/graph return_content=yes headers={'Host':'prometheus.localhost'} user=prometheus password=prometheus", check=False)
    alertmanager = host.ansible("uri", "url=http://localhost/#/alerts return_content=yes headers={'Host':'alertmanager.localhost'} user=alertmanager password=alertmanager", check=False)
    grafana = host.ansible("uri", "url=http://localhost/login return_content=yes headers={'Host':'grafana.localhost'}", check=False)

    assert '<title>Prometheus' in prometheus['content']
    assert '<title>Grafana' in grafana['content']

def test_prometheus_rules(host):
    assert host.file("/opt/prometheus/prometheus-data/telegraf.rules").contains('- alert: MemoryUsage')
    assert host.file("/opt/prometheus/prometheus-data/telegraf.rules").contains('- alert: CPUUsageDev')
    assert host.file("/opt/prometheus/prometheus-data/telegraf.rules").contains('- alert: CPUUsageProd')
