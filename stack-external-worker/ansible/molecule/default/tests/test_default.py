import os
import time

import testinfra.utils.ansible_runner

# https://testinfra.readthedocs.io/en/latest/modules.html

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('instance')

def test_generated_files(host):
    # Concourse
    assert host.file("/var/lib/concourse/worker_key").contains('BEGIN RSA PRIVATE KEY...')
    #wait for worker logs
    time.sleep( 30 )
    assert host.file("/var/log/concourse-worker.log").contains('...worker.beacon-runner.beacon...')

def test_mount_point(host):
    assert host.mount_point("/var/lib/concourse/datas").exists

def test_services_running(host):
    fluentd = host.process.filter(user='root', comm='fluentd')
    telegraf = host.process.filter(user='telegraf', comm='telegraf')
    concourse = host.process.filter(user='root', comm='concourse')

    assert len(fluentd) >= 1
    assert len(telegraf) >= 1
    assert len(concourse) >= 1

def test_telegraf(host):
    r = host.ansible("uri", "url=http://localhost:9100/metrics return_content=yes", check=False)

    assert '# HELP' in r['content']
