resource "azurerm_storage_account" "MFBIz" {
  tags = {
    project = var.azurerm_storage_account_mfbiz__tc_tags_project
  }

  access_tier              = var.azurerm_storage_account_mfbiz_access_tier
  account_kind             = var.azurerm_storage_account_mfbiz_account_kind
  account_replication_type = var.azurerm_storage_account_mfbiz_account_replication_type
  account_tier             = var.azurerm_storage_account_mfbiz_account_tier
  blob_properties {
    container_delete_retention_policy {
      days = var.azurerm_storage_account_mfbiz_blob_properties_0_container_delete_retention_policy_0_days
    }

    delete_retention_policy {
      days = var.azurerm_storage_account_mfbiz_blob_properties_0_delete_retention_policy_0_days
    }

  }

  cross_tenant_replication_enabled = var.azurerm_storage_account_mfbiz_cross_tenant_replication_enabled
  enable_https_traffic_only        = var.azurerm_storage_account_mfbiz_enable_https_traffic_only
  location                         = var.azurerm_storage_account_mfbiz_location
  min_tls_version                  = var.azurerm_storage_account_mfbiz_min_tls_version
  name                             = var.azurerm_storage_account_mfbiz_name
  network_rules {
    bypass         = var.azurerm_storage_account_mfbiz_network_rules_0_bypass
    default_action = var.azurerm_storage_account_mfbiz_network_rules_0_default_action
  }

  queue_encryption_key_type = var.azurerm_storage_account_mfbiz_queue_encryption_key_type
  queue_properties {
    hour_metrics {
      enabled               = var.azurerm_storage_account_mfbiz_queue_properties_0_hour_metrics_0_enabled
      include_apis          = var.azurerm_storage_account_mfbiz_queue_properties_0_hour_metrics_0_include_apis
      retention_policy_days = var.azurerm_storage_account_mfbiz_queue_properties_0_hour_metrics_0_retention_policy_days
      version               = var.azurerm_storage_account_mfbiz_queue_properties_0_hour_metrics_0_version
    }

    logging {
      delete  = var.azurerm_storage_account_mfbiz_queue_properties_0_logging_0_delete
      read    = var.azurerm_storage_account_mfbiz_queue_properties_0_logging_0_read
      version = var.azurerm_storage_account_mfbiz_queue_properties_0_logging_0_version
      write   = var.azurerm_storage_account_mfbiz_queue_properties_0_logging_0_write
    }

    minute_metrics {
      enabled = var.azurerm_storage_account_mfbiz_queue_properties_0_minute_metrics_0_enabled
      version = var.azurerm_storage_account_mfbiz_queue_properties_0_minute_metrics_0_version
    }

  }

  resource_group_name = var.azurerm_storage_account_mfbiz_resource_group_name
  share_properties {
    retention_policy {
      days = var.azurerm_storage_account_mfbiz_share_properties_0_retention_policy_0_days
    }

  }

  shared_access_key_enabled = var.azurerm_storage_account_mfbiz_shared_access_key_enabled
  table_encryption_key_type = var.azurerm_storage_account_mfbiz_table_encryption_key_type
}

resource "azurerm_storage_account" "SPIxI" {
  access_tier                     = var.azurerm_storage_account_spixi_access_tier
  account_kind                    = var.azurerm_storage_account_spixi_account_kind
  account_replication_type        = var.azurerm_storage_account_spixi_account_replication_type
  account_tier                    = var.azurerm_storage_account_spixi_account_tier
  allow_nested_items_to_be_public = var.azurerm_storage_account_spixi_allow_nested_items_to_be_public
  blob_properties {
    container_delete_retention_policy {
      days = var.azurerm_storage_account_spixi_blob_properties_0_container_delete_retention_policy_0_days
    }

    delete_retention_policy {
      days = var.azurerm_storage_account_spixi_blob_properties_0_delete_retention_policy_0_days
    }

  }

  cross_tenant_replication_enabled = var.azurerm_storage_account_spixi_cross_tenant_replication_enabled
  enable_https_traffic_only        = var.azurerm_storage_account_spixi_enable_https_traffic_only
  location                         = var.azurerm_storage_account_spixi_location
  min_tls_version                  = var.azurerm_storage_account_spixi_min_tls_version
  name                             = var.azurerm_storage_account_spixi_name
  network_rules {
    bypass         = var.azurerm_storage_account_spixi_network_rules_0_bypass
    default_action = var.azurerm_storage_account_spixi_network_rules_0_default_action
  }

  queue_encryption_key_type = var.azurerm_storage_account_spixi_queue_encryption_key_type
  queue_properties {
    hour_metrics {
      enabled               = var.azurerm_storage_account_spixi_queue_properties_0_hour_metrics_0_enabled
      include_apis          = var.azurerm_storage_account_spixi_queue_properties_0_hour_metrics_0_include_apis
      retention_policy_days = var.azurerm_storage_account_spixi_queue_properties_0_hour_metrics_0_retention_policy_days
      version               = var.azurerm_storage_account_spixi_queue_properties_0_hour_metrics_0_version
    }

    logging {
      delete  = var.azurerm_storage_account_spixi_queue_properties_0_logging_0_delete
      read    = var.azurerm_storage_account_spixi_queue_properties_0_logging_0_read
      version = var.azurerm_storage_account_spixi_queue_properties_0_logging_0_version
      write   = var.azurerm_storage_account_spixi_queue_properties_0_logging_0_write
    }

    minute_metrics {
      enabled = var.azurerm_storage_account_spixi_queue_properties_0_minute_metrics_0_enabled
      version = var.azurerm_storage_account_spixi_queue_properties_0_minute_metrics_0_version
    }

  }

  resource_group_name = var.azurerm_storage_account_spixi_resource_group_name
  share_properties {
    retention_policy {
      days = var.azurerm_storage_account_spixi_share_properties_0_retention_policy_0_days
    }

  }

  shared_access_key_enabled = var.azurerm_storage_account_spixi_shared_access_key_enabled
  table_encryption_key_type = var.azurerm_storage_account_spixi_table_encryption_key_type
}

resource "azurerm_storage_account" "YejCK" {
  tags = {
    created_by  = var.azurerm_storage_account_yejck__tc_tags_created_by
    customer    = var.azurerm_storage_account_yejck__tc_tags_customer
    cycloid     = var.azurerm_storage_account_yejck__tc_tags_cycloid
    env         = var.azurerm_storage_account_yejck__tc_tags_env
    environment = var.azurerm_storage_account_yejck__tc_tags_environment
    project     = var.azurerm_storage_account_yejck__tc_tags_project
  }

  access_tier                     = var.azurerm_storage_account_yejck_access_tier
  account_kind                    = var.azurerm_storage_account_yejck_account_kind
  account_replication_type        = var.azurerm_storage_account_yejck_account_replication_type
  account_tier                    = var.azurerm_storage_account_yejck_account_tier
  allow_nested_items_to_be_public = var.azurerm_storage_account_yejck_allow_nested_items_to_be_public
  enable_https_traffic_only       = var.azurerm_storage_account_yejck_enable_https_traffic_only
  location                        = var.azurerm_storage_account_yejck_location
  min_tls_version                 = var.azurerm_storage_account_yejck_min_tls_version
  name                            = var.azurerm_storage_account_yejck_name
  network_rules {
    bypass         = var.azurerm_storage_account_yejck_network_rules_0_bypass
    default_action = var.azurerm_storage_account_yejck_network_rules_0_default_action
  }

  queue_encryption_key_type = var.azurerm_storage_account_yejck_queue_encryption_key_type
  queue_properties {
    hour_metrics {
      enabled               = var.azurerm_storage_account_yejck_queue_properties_0_hour_metrics_0_enabled
      include_apis          = var.azurerm_storage_account_yejck_queue_properties_0_hour_metrics_0_include_apis
      retention_policy_days = var.azurerm_storage_account_yejck_queue_properties_0_hour_metrics_0_retention_policy_days
      version               = var.azurerm_storage_account_yejck_queue_properties_0_hour_metrics_0_version
    }

    logging {
      delete  = var.azurerm_storage_account_yejck_queue_properties_0_logging_0_delete
      read    = var.azurerm_storage_account_yejck_queue_properties_0_logging_0_read
      version = var.azurerm_storage_account_yejck_queue_properties_0_logging_0_version
      write   = var.azurerm_storage_account_yejck_queue_properties_0_logging_0_write
    }

    minute_metrics {
      enabled = var.azurerm_storage_account_yejck_queue_properties_0_minute_metrics_0_enabled
      version = var.azurerm_storage_account_yejck_queue_properties_0_minute_metrics_0_version
    }

  }

  resource_group_name = var.azurerm_storage_account_yejck_resource_group_name
  share_properties {
    retention_policy {
      days = var.azurerm_storage_account_yejck_share_properties_0_retention_policy_0_days
    }

  }

  shared_access_key_enabled = var.azurerm_storage_account_yejck_shared_access_key_enabled
  table_encryption_key_type = var.azurerm_storage_account_yejck_table_encryption_key_type
}

resource "azurerm_storage_account" "_subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_defaultresourcegroup_weu_providers_microsoft_storage_storageaccounts_cycloidtestobs" {
  access_tier                     = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_defaultresourcegroup_weu_providers_microsoft_storage_storageaccounts_cycloidtestobs_access_tier
  account_kind                    = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_defaultresourcegroup_weu_providers_microsoft_storage_storageaccounts_cycloidtestobs_account_kind
  account_replication_type        = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_defaultresourcegroup_weu_providers_microsoft_storage_storageaccounts_cycloidtestobs_account_replication_type
  account_tier                    = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_defaultresourcegroup_weu_providers_microsoft_storage_storageaccounts_cycloidtestobs_account_tier
  allow_nested_items_to_be_public = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_defaultresourcegroup_weu_providers_microsoft_storage_storageaccounts_cycloidtestobs_allow_nested_items_to_be_public
  blob_properties {
    container_delete_retention_policy {
      days = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_defaultresourcegroup_weu_providers_microsoft_storage_storageaccounts_cycloidtestobs_blob_properties_0_container_delete_retention_policy_0_days
    }

    delete_retention_policy {
      days = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_defaultresourcegroup_weu_providers_microsoft_storage_storageaccounts_cycloidtestobs_blob_properties_0_delete_retention_policy_0_days
    }

  }

  cross_tenant_replication_enabled = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_defaultresourcegroup_weu_providers_microsoft_storage_storageaccounts_cycloidtestobs_cross_tenant_replication_enabled
  enable_https_traffic_only        = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_defaultresourcegroup_weu_providers_microsoft_storage_storageaccounts_cycloidtestobs_enable_https_traffic_only
  location                         = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_defaultresourcegroup_weu_providers_microsoft_storage_storageaccounts_cycloidtestobs_location
  min_tls_version                  = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_defaultresourcegroup_weu_providers_microsoft_storage_storageaccounts_cycloidtestobs_min_tls_version
  name                             = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_defaultresourcegroup_weu_providers_microsoft_storage_storageaccounts_cycloidtestobs_name
  network_rules {
    bypass         = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_defaultresourcegroup_weu_providers_microsoft_storage_storageaccounts_cycloidtestobs_network_rules_0_bypass
    default_action = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_defaultresourcegroup_weu_providers_microsoft_storage_storageaccounts_cycloidtestobs_network_rules_0_default_action
  }

  queue_encryption_key_type = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_defaultresourcegroup_weu_providers_microsoft_storage_storageaccounts_cycloidtestobs_queue_encryption_key_type
  queue_properties {
    hour_metrics {
      enabled               = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_defaultresourcegroup_weu_providers_microsoft_storage_storageaccounts_cycloidtestobs_queue_properties_0_hour_metrics_0_enabled
      include_apis          = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_defaultresourcegroup_weu_providers_microsoft_storage_storageaccounts_cycloidtestobs_queue_properties_0_hour_metrics_0_include_apis
      retention_policy_days = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_defaultresourcegroup_weu_providers_microsoft_storage_storageaccounts_cycloidtestobs_queue_properties_0_hour_metrics_0_retention_policy_days
      version               = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_defaultresourcegroup_weu_providers_microsoft_storage_storageaccounts_cycloidtestobs_queue_properties_0_hour_metrics_0_version
    }

    logging {
      delete  = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_defaultresourcegroup_weu_providers_microsoft_storage_storageaccounts_cycloidtestobs_queue_properties_0_logging_0_delete
      read    = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_defaultresourcegroup_weu_providers_microsoft_storage_storageaccounts_cycloidtestobs_queue_properties_0_logging_0_read
      version = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_defaultresourcegroup_weu_providers_microsoft_storage_storageaccounts_cycloidtestobs_queue_properties_0_logging_0_version
      write   = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_defaultresourcegroup_weu_providers_microsoft_storage_storageaccounts_cycloidtestobs_queue_properties_0_logging_0_write
    }

    minute_metrics {
      enabled = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_defaultresourcegroup_weu_providers_microsoft_storage_storageaccounts_cycloidtestobs_queue_properties_0_minute_metrics_0_enabled
      version = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_defaultresourcegroup_weu_providers_microsoft_storage_storageaccounts_cycloidtestobs_queue_properties_0_minute_metrics_0_version
    }

  }

  resource_group_name = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_defaultresourcegroup_weu_providers_microsoft_storage_storageaccounts_cycloidtestobs_resource_group_name
  share_properties {
    retention_policy {
      days = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_defaultresourcegroup_weu_providers_microsoft_storage_storageaccounts_cycloidtestobs_share_properties_0_retention_policy_0_days
    }

  }

  shared_access_key_enabled = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_defaultresourcegroup_weu_providers_microsoft_storage_storageaccounts_cycloidtestobs_shared_access_key_enabled
  table_encryption_key_type = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_defaultresourcegroup_weu_providers_microsoft_storage_storageaccounts_cycloidtestobs_table_encryption_key_type
}

resource "azurerm_storage_account" "_subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_rg_myappname1_providers_microsoft_storage_storageaccounts_stmyappname18hgij0" {
  tags = {
    created_by  = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_rg_myappname1_providers_microsoft_storage_storageaccounts_stmyappname18hgij0__tc_tags_created_by
    customer    = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_rg_myappname1_providers_microsoft_storage_storageaccounts_stmyappname18hgij0__tc_tags_customer
    cycloid     = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_rg_myappname1_providers_microsoft_storage_storageaccounts_stmyappname18hgij0__tc_tags_cycloid
    env         = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_rg_myappname1_providers_microsoft_storage_storageaccounts_stmyappname18hgij0__tc_tags_env
    environment = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_rg_myappname1_providers_microsoft_storage_storageaccounts_stmyappname18hgij0__tc_tags_environment
    project     = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_rg_myappname1_providers_microsoft_storage_storageaccounts_stmyappname18hgij0__tc_tags_project
  }

  access_tier                     = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_rg_myappname1_providers_microsoft_storage_storageaccounts_stmyappname18hgij0_access_tier
  account_kind                    = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_rg_myappname1_providers_microsoft_storage_storageaccounts_stmyappname18hgij0_account_kind
  account_replication_type        = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_rg_myappname1_providers_microsoft_storage_storageaccounts_stmyappname18hgij0_account_replication_type
  account_tier                    = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_rg_myappname1_providers_microsoft_storage_storageaccounts_stmyappname18hgij0_account_tier
  allow_nested_items_to_be_public = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_rg_myappname1_providers_microsoft_storage_storageaccounts_stmyappname18hgij0_allow_nested_items_to_be_public
  enable_https_traffic_only       = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_rg_myappname1_providers_microsoft_storage_storageaccounts_stmyappname18hgij0_enable_https_traffic_only
  location                        = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_rg_myappname1_providers_microsoft_storage_storageaccounts_stmyappname18hgij0_location
  min_tls_version                 = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_rg_myappname1_providers_microsoft_storage_storageaccounts_stmyappname18hgij0_min_tls_version
  name                            = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_rg_myappname1_providers_microsoft_storage_storageaccounts_stmyappname18hgij0_name
  network_rules {
    bypass         = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_rg_myappname1_providers_microsoft_storage_storageaccounts_stmyappname18hgij0_network_rules_0_bypass
    default_action = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_rg_myappname1_providers_microsoft_storage_storageaccounts_stmyappname18hgij0_network_rules_0_default_action
  }

  queue_encryption_key_type = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_rg_myappname1_providers_microsoft_storage_storageaccounts_stmyappname18hgij0_queue_encryption_key_type
  queue_properties {
    hour_metrics {
      enabled               = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_rg_myappname1_providers_microsoft_storage_storageaccounts_stmyappname18hgij0_queue_properties_0_hour_metrics_0_enabled
      include_apis          = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_rg_myappname1_providers_microsoft_storage_storageaccounts_stmyappname18hgij0_queue_properties_0_hour_metrics_0_include_apis
      retention_policy_days = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_rg_myappname1_providers_microsoft_storage_storageaccounts_stmyappname18hgij0_queue_properties_0_hour_metrics_0_retention_policy_days
      version               = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_rg_myappname1_providers_microsoft_storage_storageaccounts_stmyappname18hgij0_queue_properties_0_hour_metrics_0_version
    }

    logging {
      delete  = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_rg_myappname1_providers_microsoft_storage_storageaccounts_stmyappname18hgij0_queue_properties_0_logging_0_delete
      read    = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_rg_myappname1_providers_microsoft_storage_storageaccounts_stmyappname18hgij0_queue_properties_0_logging_0_read
      version = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_rg_myappname1_providers_microsoft_storage_storageaccounts_stmyappname18hgij0_queue_properties_0_logging_0_version
      write   = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_rg_myappname1_providers_microsoft_storage_storageaccounts_stmyappname18hgij0_queue_properties_0_logging_0_write
    }

    minute_metrics {
      enabled = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_rg_myappname1_providers_microsoft_storage_storageaccounts_stmyappname18hgij0_queue_properties_0_minute_metrics_0_enabled
      version = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_rg_myappname1_providers_microsoft_storage_storageaccounts_stmyappname18hgij0_queue_properties_0_minute_metrics_0_version
    }

  }

  resource_group_name = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_rg_myappname1_providers_microsoft_storage_storageaccounts_stmyappname18hgij0_resource_group_name
  share_properties {
    retention_policy {
      days = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_rg_myappname1_providers_microsoft_storage_storageaccounts_stmyappname18hgij0_share_properties_0_retention_policy_0_days
    }

  }

  shared_access_key_enabled = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_rg_myappname1_providers_microsoft_storage_storageaccounts_stmyappname18hgij0_shared_access_key_enabled
  table_encryption_key_type = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_rg_myappname1_providers_microsoft_storage_storageaccounts_stmyappname18hgij0_table_encryption_key_type
}

resource "azurerm_storage_account" "_subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_youdeploy_backend_tests_providers_microsoft_storage_storageaccounts_cccmtests" {
  tags = {
    project = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_youdeploy_backend_tests_providers_microsoft_storage_storageaccounts_cccmtests__tc_tags_project
  }

  access_tier              = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_youdeploy_backend_tests_providers_microsoft_storage_storageaccounts_cccmtests_access_tier
  account_kind             = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_youdeploy_backend_tests_providers_microsoft_storage_storageaccounts_cccmtests_account_kind
  account_replication_type = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_youdeploy_backend_tests_providers_microsoft_storage_storageaccounts_cccmtests_account_replication_type
  account_tier             = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_youdeploy_backend_tests_providers_microsoft_storage_storageaccounts_cccmtests_account_tier
  blob_properties {
    container_delete_retention_policy {
      days = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_youdeploy_backend_tests_providers_microsoft_storage_storageaccounts_cccmtests_blob_properties_0_container_delete_retention_policy_0_days
    }

    delete_retention_policy {
      days = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_youdeploy_backend_tests_providers_microsoft_storage_storageaccounts_cccmtests_blob_properties_0_delete_retention_policy_0_days
    }

  }

  cross_tenant_replication_enabled = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_youdeploy_backend_tests_providers_microsoft_storage_storageaccounts_cccmtests_cross_tenant_replication_enabled
  enable_https_traffic_only        = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_youdeploy_backend_tests_providers_microsoft_storage_storageaccounts_cccmtests_enable_https_traffic_only
  location                         = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_youdeploy_backend_tests_providers_microsoft_storage_storageaccounts_cccmtests_location
  min_tls_version                  = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_youdeploy_backend_tests_providers_microsoft_storage_storageaccounts_cccmtests_min_tls_version
  name                             = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_youdeploy_backend_tests_providers_microsoft_storage_storageaccounts_cccmtests_name
  network_rules {
    bypass         = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_youdeploy_backend_tests_providers_microsoft_storage_storageaccounts_cccmtests_network_rules_0_bypass
    default_action = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_youdeploy_backend_tests_providers_microsoft_storage_storageaccounts_cccmtests_network_rules_0_default_action
  }

  queue_encryption_key_type = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_youdeploy_backend_tests_providers_microsoft_storage_storageaccounts_cccmtests_queue_encryption_key_type
  queue_properties {
    hour_metrics {
      enabled               = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_youdeploy_backend_tests_providers_microsoft_storage_storageaccounts_cccmtests_queue_properties_0_hour_metrics_0_enabled
      include_apis          = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_youdeploy_backend_tests_providers_microsoft_storage_storageaccounts_cccmtests_queue_properties_0_hour_metrics_0_include_apis
      retention_policy_days = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_youdeploy_backend_tests_providers_microsoft_storage_storageaccounts_cccmtests_queue_properties_0_hour_metrics_0_retention_policy_days
      version               = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_youdeploy_backend_tests_providers_microsoft_storage_storageaccounts_cccmtests_queue_properties_0_hour_metrics_0_version
    }

    logging {
      delete  = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_youdeploy_backend_tests_providers_microsoft_storage_storageaccounts_cccmtests_queue_properties_0_logging_0_delete
      read    = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_youdeploy_backend_tests_providers_microsoft_storage_storageaccounts_cccmtests_queue_properties_0_logging_0_read
      version = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_youdeploy_backend_tests_providers_microsoft_storage_storageaccounts_cccmtests_queue_properties_0_logging_0_version
      write   = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_youdeploy_backend_tests_providers_microsoft_storage_storageaccounts_cccmtests_queue_properties_0_logging_0_write
    }

    minute_metrics {
      enabled = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_youdeploy_backend_tests_providers_microsoft_storage_storageaccounts_cccmtests_queue_properties_0_minute_metrics_0_enabled
      version = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_youdeploy_backend_tests_providers_microsoft_storage_storageaccounts_cccmtests_queue_properties_0_minute_metrics_0_version
    }

  }

  resource_group_name = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_youdeploy_backend_tests_providers_microsoft_storage_storageaccounts_cccmtests_resource_group_name
  share_properties {
    retention_policy {
      days = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_youdeploy_backend_tests_providers_microsoft_storage_storageaccounts_cccmtests_share_properties_0_retention_policy_0_days
    }

  }

  shared_access_key_enabled = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_youdeploy_backend_tests_providers_microsoft_storage_storageaccounts_cccmtests_shared_access_key_enabled
  table_encryption_key_type = var.azurerm_storage_account__subscriptions_edce4685_4988_4a09_8b4a_3d5b917022cd_resourcegroups_youdeploy_backend_tests_providers_microsoft_storage_storageaccounts_cccmtests_table_encryption_key_type
}

