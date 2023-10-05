import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('instance')


def test_magento_env(host):
    f = host.file('/home/magento/magento/current/app/etc/env.php')

    assert f.exists
    assert f.user == 'magento'
    assert f.group == 'magento'


def test_services_running(host):
    nginx = host.process.filter(user='www-data', comm='nginx')
    fpm = host.process.filter(user='magento', comm='php-fpm7.1')

    assert len(nginx) >= 1
    assert len(fpm) >= 1


def test_curl_homepage(host):
    f = host.run("curl -s  localhost | grep '<title>Home page</title>'")

    assert f.rc == 0


def test_magento_crons(host):

    cron = host.file("/var/spool/cron/crontabs/magento")
    assert cron.contains("Magento maintenance cron")
    assert cron.contains("Magento update cron")
    assert cron.contains("Magento setup cron")
    assert cron.exists
