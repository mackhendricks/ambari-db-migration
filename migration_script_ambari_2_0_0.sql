-- ----------------------------------------------------------------------------
-- MySQL Workbench Migration
-- Migrated Schemata: ambari
-- Source Schemata: ambari
-- Created: Thu Sep 10 02:55:35 2015
-- Workbench Version: 6.3.4
-- ----------------------------------------------------------------------------

SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------------------------------------------------------
-- Schema ambari
-- ----------------------------------------------------------------------------
DROP SCHEMA IF EXISTS `ambari` ;
CREATE SCHEMA IF NOT EXISTS `ambari` ;

-- ----------------------------------------------------------------------------
-- Table ambari.adminpermission
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`adminpermission` (
  `permission_id` BIGINT NOT NULL COMMENT '',
  `permission_name` VARCHAR(255) NOT NULL COMMENT '',
  `resource_type_id` INT NOT NULL COMMENT '',
  PRIMARY KEY (`permission_id`),
  UNIQUE INDEX `uq_perm_name_resource_type_id` (`permission_name` ASC, `resource_type_id` ASC),
  CONSTRAINT `fk_permission_resource_type_id`
    FOREIGN KEY (`resource_type_id`)
    REFERENCES `ambari`.`adminresourcetype` (`resource_type_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table ambari.adminprincipal
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`adminprincipal` (
  `principal_id` BIGINT NOT NULL COMMENT '',
  `principal_type_id` INT NOT NULL COMMENT '',
  PRIMARY KEY (`principal_id`),
  CONSTRAINT `fk_principal_principal_type_id`
    FOREIGN KEY (`principal_type_id`)
    REFERENCES `ambari`.`adminprincipaltype` (`principal_type_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table ambari.adminprincipaltype
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`adminprincipaltype` (
  `principal_type_id` INT NOT NULL COMMENT '',
  `principal_type_name` VARCHAR(255) NOT NULL COMMENT '',
  PRIMARY KEY (`principal_type_id`) );

-- ----------------------------------------------------------------------------
-- Table ambari.adminprivilege
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`adminprivilege` (
  `privilege_id` BIGINT NOT NULL COMMENT '',
  `permission_id` BIGINT NOT NULL COMMENT '',
  `resource_id` BIGINT NOT NULL COMMENT '',
  `principal_id` BIGINT NOT NULL COMMENT '',
  PRIMARY KEY (`privilege_id`),
  CONSTRAINT `fk_privilege_permission_id`
    FOREIGN KEY (`permission_id`)
    REFERENCES `ambari`.`adminpermission` (`permission_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_privilege_principal_id`
    FOREIGN KEY (`principal_id`)
    REFERENCES `ambari`.`adminprincipal` (`principal_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_privilege_resource_id`
    FOREIGN KEY (`resource_id`)
    REFERENCES `ambari`.`adminresource` (`resource_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table ambari.adminresource
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`adminresource` (
  `resource_id` BIGINT NOT NULL COMMENT '',
  `resource_type_id` INT NOT NULL COMMENT '',
  PRIMARY KEY (`resource_id`),
  CONSTRAINT `fk_resource_resource_type_id`
    FOREIGN KEY (`resource_type_id`)
    REFERENCES `ambari`.`adminresourcetype` (`resource_type_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table ambari.adminresourcetype
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`adminresourcetype` (
  `resource_type_id` INT NOT NULL COMMENT '',
  `resource_type_name` VARCHAR(255) NOT NULL COMMENT '',
  PRIMARY KEY (`resource_type_id`));

-- ----------------------------------------------------------------------------
-- Table ambari.alert_current
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`alert_current` (
  `alert_id` BIGINT NOT NULL COMMENT '',
  `definition_id` BIGINT NOT NULL COMMENT '',
  `history_id` BIGINT NOT NULL COMMENT '',
  `maintenance_state` VARCHAR(255) NOT NULL COMMENT '',
  `original_timestamp` BIGINT NOT NULL COMMENT '',
  `latest_timestamp` BIGINT NOT NULL COMMENT '',
  `latest_text` LONGTEXT NULL COMMENT '',
  PRIMARY KEY (`alert_id`),
  UNIQUE INDEX `alert_current_history_id_key` (`history_id` ASC),
  CONSTRAINT `alert_current_definition_id_fkey`
    FOREIGN KEY (`definition_id`)
    REFERENCES `ambari`.`alert_definition` (`definition_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `alert_current_history_id_fkey`
    FOREIGN KEY (`history_id`)
    REFERENCES `ambari`.`alert_history` (`alert_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table ambari.alert_definition
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`alert_definition` (
  `definition_id` BIGINT NOT NULL COMMENT '',
  `cluster_id` BIGINT NOT NULL COMMENT '',
  `definition_name` VARCHAR(255) NOT NULL COMMENT '',
  `service_name` VARCHAR(255) NOT NULL COMMENT '',
  `component_name` VARCHAR(255) NULL COMMENT '',
  `scope` VARCHAR(255) NOT NULL DEFAULT 'ANY' COMMENT '',
  `label` VARCHAR(255) NULL COMMENT '',
  `description` LONGTEXT NULL COMMENT '',
  `enabled` SMALLINT NOT NULL DEFAULT 1 COMMENT '',
  `schedule_interval` INT NOT NULL COMMENT '',
  `source_type` VARCHAR(255) NOT NULL COMMENT '',
  `alert_source` LONGTEXT NOT NULL COMMENT '',
  `hash` VARCHAR(64) NOT NULL COMMENT '',
  `ignore_host` SMALLINT NOT NULL DEFAULT 0 COMMENT '',
  PRIMARY KEY (`definition_id`),
  UNIQUE INDEX `uni_alert_def_name` (`cluster_id` ASC, `definition_name` ASC),
  CONSTRAINT `alert_definition_cluster_id_fkey`
    FOREIGN KEY (`cluster_id`)
    REFERENCES `ambari`.`clusters` (`cluster_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table ambari.alert_group
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`alert_group` (
  `group_id` BIGINT NOT NULL COMMENT '',
  `cluster_id` BIGINT NOT NULL COMMENT '',
  `group_name` VARCHAR(255) NOT NULL COMMENT '',
  `is_default` SMALLINT NOT NULL DEFAULT 0 COMMENT '',
  `service_name` VARCHAR(255) NULL COMMENT '',
  PRIMARY KEY (`group_id`),
  INDEX `idx_alert_group_name` (`group_name` ASC),
  UNIQUE INDEX `uni_alert_group_name` (`cluster_id` ASC, `group_name` ASC));

-- ----------------------------------------------------------------------------
-- Table ambari.alert_group_target
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`alert_group_target` (
  `group_id` BIGINT NOT NULL COMMENT '',
  `target_id` BIGINT NOT NULL COMMENT '',
  PRIMARY KEY (`group_id`, `target_id`),
  CONSTRAINT `alert_group_target_group_id_fkey`
    FOREIGN KEY (`group_id`)
    REFERENCES `ambari`.`alert_group` (`group_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `alert_group_target_target_id_fkey`
    FOREIGN KEY (`target_id`)
    REFERENCES `ambari`.`alert_target` (`target_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table ambari.alert_grouping
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`alert_grouping` (
  `definition_id` BIGINT NOT NULL COMMENT '',
  `group_id` BIGINT NOT NULL COMMENT '',
  PRIMARY KEY (`group_id`, `definition_id`),
  CONSTRAINT `alert_grouping_definition_id_fkey`
    FOREIGN KEY (`definition_id`)
    REFERENCES `ambari`.`alert_definition` (`definition_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `alert_grouping_group_id_fkey`
    FOREIGN KEY (`group_id`)
    REFERENCES `ambari`.`alert_group` (`group_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table ambari.alert_history
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`alert_history` (
  `alert_id` BIGINT NOT NULL COMMENT '',
  `cluster_id` BIGINT NOT NULL COMMENT '',
  `alert_definition_id` BIGINT NOT NULL COMMENT '',
  `service_name` VARCHAR(255) NOT NULL COMMENT '',
  `component_name` VARCHAR(255) NULL COMMENT '',
  `host_name` VARCHAR(255) NULL COMMENT '',
  `alert_instance` VARCHAR(255) NULL COMMENT '',
  `alert_timestamp` BIGINT NOT NULL COMMENT '',
  `alert_label` VARCHAR(1024) NULL COMMENT '',
  `alert_state` VARCHAR(255) NOT NULL COMMENT '',
  `alert_text` LONGTEXT NULL COMMENT '',
  PRIMARY KEY (`alert_id`),
  INDEX `idx_alert_history_def_id` (`alert_definition_id` ASC)  ,
  INDEX `idx_alert_history_host` (`host_name` ASC)  ,
  INDEX `idx_alert_history_service` (`service_name` ASC)  ,
  INDEX `idx_alert_history_state` (`alert_state` ASC)  ,
  INDEX `idx_alert_history_time` (`alert_timestamp` ASC)  ,
  CONSTRAINT `alert_history_alert_definition_id_fkey`
    FOREIGN KEY (`alert_definition_id`)
    REFERENCES `ambari`.`alert_definition` (`definition_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `alert_history_cluster_id_fkey`
    FOREIGN KEY (`cluster_id`)
    REFERENCES `ambari`.`clusters` (`cluster_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table ambari.alert_notice
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`alert_notice` (
  `notification_id` BIGINT NOT NULL COMMENT '',
  `target_id` BIGINT NOT NULL COMMENT '',
  `history_id` BIGINT NOT NULL COMMENT '',
  `notify_state` VARCHAR(255) NOT NULL COMMENT '',
  `uuid` VARCHAR(64) NOT NULL COMMENT '',
  PRIMARY KEY (`notification_id`),
  UNIQUE INDEX `alert_notice_uuid_key` (`uuid` ASC),
  INDEX `idx_alert_notice_state` (`notify_state` ASC) ,
  CONSTRAINT `alert_notice_history_id_fkey`
    FOREIGN KEY (`history_id`)
    REFERENCES `ambari`.`alert_history` (`alert_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `alert_notice_target_id_fkey`
    FOREIGN KEY (`target_id`)
    REFERENCES `ambari`.`alert_target` (`target_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table ambari.alert_target
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`alert_target` (
  `target_id` BIGINT NOT NULL COMMENT '',
  `target_name` VARCHAR(255) NOT NULL COMMENT '',
  `notification_type` VARCHAR(64) NOT NULL COMMENT '',
  `properties` LONGTEXT NULL COMMENT '',
  `description` VARCHAR(1024) NULL COMMENT '',
  `is_global` SMALLINT NOT NULL DEFAULT 0 COMMENT '',
  PRIMARY KEY (`target_id`),
  UNIQUE INDEX `alert_target_target_name_key` (`target_name` ASC)  );

-- ----------------------------------------------------------------------------
-- Table ambari.alert_target_states
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`alert_target_states` (
  `target_id` BIGINT NOT NULL COMMENT '',
  `alert_state` VARCHAR(255) NOT NULL COMMENT '',
  CONSTRAINT `alert_target_states_target_id_fkey`
    FOREIGN KEY (`target_id`)
    REFERENCES `ambari`.`alert_target` (`target_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table ambari.ambari_sequences
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`ambari_sequences` (
  `sequence_name` VARCHAR(255) NOT NULL COMMENT '',
  `sequence_value` BIGINT NOT NULL COMMENT '',
  PRIMARY KEY (`sequence_name`));

-- ----------------------------------------------------------------------------
-- Table ambari.artifact
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`artifact` (
  `artifact_name` VARCHAR(255) NOT NULL COMMENT '',
  `artifact_data` LONGTEXT NOT NULL COMMENT '',
  `foreign_keys` VARCHAR(255) NOT NULL COMMENT '',
  PRIMARY KEY (`artifact_name`, `foreign_keys`));

-- ----------------------------------------------------------------------------
-- Table ambari.blueprint
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`blueprint` (
  `blueprint_name` VARCHAR(255) NOT NULL COMMENT '',
  `stack_name` VARCHAR(255) NOT NULL COMMENT '',
  `stack_version` VARCHAR(255) NOT NULL COMMENT '',
  PRIMARY KEY (`blueprint_name`) );

-- ----------------------------------------------------------------------------
-- Table ambari.blueprint_configuration
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`blueprint_configuration` (
  `blueprint_name` VARCHAR(255) NOT NULL COMMENT '',
  `type_name` VARCHAR(255) NOT NULL COMMENT '',
  `config_data` LONGTEXT NOT NULL COMMENT '',
  `config_attributes` VARCHAR(32000) NULL COMMENT '',
  PRIMARY KEY (`blueprint_name`, `type_name`),
  CONSTRAINT `fk_cfg_blueprint_name`
    FOREIGN KEY (`blueprint_name`)
    REFERENCES `ambari`.`blueprint` (`blueprint_name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table ambari.cluster_version
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`cluster_version` (
  `id` BIGINT NOT NULL COMMENT '',
  `repo_version_id` BIGINT NOT NULL COMMENT '',
  `cluster_id` BIGINT NOT NULL COMMENT '',
  `state` VARCHAR(32) NOT NULL COMMENT '',
  `start_time` BIGINT NOT NULL COMMENT '',
  `end_time` BIGINT NULL COMMENT '',
  `user_name` VARCHAR(32) NULL COMMENT '',
  PRIMARY KEY (`id`) ,
  CONSTRAINT `fk_cluster_version_cluster_id`
    FOREIGN KEY (`cluster_id`)
    REFERENCES `ambari`.`clusters` (`cluster_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_cluster_version_repovers_id`
    FOREIGN KEY (`repo_version_id`)
    REFERENCES `ambari`.`repo_version` (`repo_version_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table ambari.clusterconfig
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`clusterconfig` (
  `config_id` BIGINT NOT NULL COMMENT '',
  `version_tag` VARCHAR(255) NOT NULL COMMENT '',
  `version` BIGINT NOT NULL COMMENT '',
  `type_name` VARCHAR(255) NOT NULL COMMENT '',
  `cluster_id` BIGINT NOT NULL COMMENT '',
  `config_data` LONGTEXT NOT NULL COMMENT '',
  `config_attributes` VARCHAR(32000) NULL COMMENT '',
  `create_timestamp` BIGINT NOT NULL COMMENT '',
  PRIMARY KEY (`config_id`) ,
  UNIQUE INDEX `uq_config_type_tag` (`version_tag` ASC, `type_name` ASC, `cluster_id` ASC)  ,
  UNIQUE INDEX `uq_config_type_version` (`version` ASC, `type_name` ASC, `cluster_id` ASC) ,
  CONSTRAINT `fk_clusterconfig_cluster_id`
    FOREIGN KEY (`cluster_id`)
    REFERENCES `ambari`.`clusters` (`cluster_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table ambari.clusterconfigmapping
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`clusterconfigmapping` (
  `cluster_id` BIGINT NOT NULL COMMENT '',
  `type_name` VARCHAR(255) NOT NULL COMMENT '',
  `version_tag` VARCHAR(255) NOT NULL COMMENT '',
  `create_timestamp` BIGINT NOT NULL COMMENT '',
  `selected` INT NOT NULL DEFAULT 0 COMMENT '',
  `user_name` VARCHAR(255) NOT NULL DEFAULT '_db' COMMENT '',
  PRIMARY KEY (`cluster_id`, `type_name`, `create_timestamp`),
  CONSTRAINT `clusterconfigmappingcluster_id`
    FOREIGN KEY (`cluster_id`)
    REFERENCES `ambari`.`clusters` (`cluster_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table ambari.clusterhostmapping
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`clusterhostmapping` (
  `cluster_id` BIGINT NOT NULL COMMENT '',
  `host_name` VARCHAR(255) NOT NULL COMMENT '',
  PRIMARY KEY (`cluster_id`, `host_name`),
  CONSTRAINT `clusterhostmapping_cluster_id`
    FOREIGN KEY (`host_name`)
    REFERENCES `ambari`.`hosts` (`host_name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `clusterhostmapping_host_name`
    FOREIGN KEY (`cluster_id`)
    REFERENCES `ambari`.`clusters` (`cluster_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table ambari.clusters
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`clusters` (
  `cluster_id` BIGINT NOT NULL COMMENT '',
  `resource_id` BIGINT NOT NULL COMMENT '',
  `cluster_info` VARCHAR(255) NOT NULL COMMENT '',
  `cluster_name` VARCHAR(100) NOT NULL COMMENT '',
  `provisioning_state` VARCHAR(255) NOT NULL DEFAULT 'INIT' COMMENT '',
  `security_type` VARCHAR(32) NOT NULL DEFAULT 'NONE' COMMENT '',
  `desired_cluster_state` VARCHAR(255) NOT NULL COMMENT '',
  `desired_stack_version` VARCHAR(255) NOT NULL COMMENT '',
  PRIMARY KEY (`cluster_id`),
  UNIQUE INDEX `clusters_cluster_name_key` (`cluster_name` ASC)  ,
  CONSTRAINT `fk_clusters_resource_id`
    FOREIGN KEY (`resource_id`)
    REFERENCES `ambari`.`adminresource` (`resource_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table ambari.clusterservices
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`clusterservices` (
  `service_name` VARCHAR(255) NOT NULL COMMENT '',
  `cluster_id` BIGINT NOT NULL COMMENT '',
  `service_enabled` INT NOT NULL COMMENT '',
  PRIMARY KEY (`service_name`, `cluster_id`),
  CONSTRAINT `fk_clusterservices_cluster_id`
    FOREIGN KEY (`cluster_id`)
    REFERENCES `ambari`.`clusters` (`cluster_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table ambari.clusterstate
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`clusterstate` (
  `cluster_id` BIGINT NOT NULL COMMENT '',
  `current_cluster_state` VARCHAR(255) NOT NULL COMMENT '',
  `current_stack_version` VARCHAR(255) NOT NULL COMMENT '',
  PRIMARY KEY (`cluster_id`),
  CONSTRAINT `fk_clusterstate_cluster_id`
    FOREIGN KEY (`cluster_id`)
    REFERENCES `ambari`.`clusters` (`cluster_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table ambari.confgroupclusterconfigmapping
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`confgroupclusterconfigmapping` (
  `config_group_id` BIGINT NOT NULL COMMENT '',
  `cluster_id` VARCHAR(255) NOT NULL COMMENT '',
  `config_type` VARCHAR(255) NOT NULL COMMENT '',
  `version_tag` BIGINT NOT NULL COMMENT '',
  `user_name` VARCHAR(255) NULL DEFAULT '_db' COMMENT '',
  `create_timestamp` BIGINT NOT NULL COMMENT '',
  PRIMARY KEY (`config_group_id`, `cluster_id`, `config_type`),
  CONSTRAINT `fk_cgccm_gid`
    FOREIGN KEY (`config_group_id`)
    REFERENCES `ambari`.`configgroup` (`group_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_confg`
    FOREIGN KEY (`version_tag` , `config_type` , `cluster_id`)
    REFERENCES `ambari`.`clusterconfig` (`cluster_id` , `type_name` , `version_tag`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table ambari.configgroup
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`configgroup` (
  `group_id` BIGINT NOT NULL COMMENT '',
  `cluster_id` BIGINT NOT NULL COMMENT '',
  `group_name` VARCHAR(255) NOT NULL COMMENT '',
  `tag` VARCHAR(1024) NOT NULL COMMENT '',
  `description` VARCHAR(1024) NULL COMMENT '',
  `create_timestamp` BIGINT NOT NULL COMMENT '',
  `service_name` VARCHAR(255) NULL COMMENT '',
  PRIMARY KEY (`group_id`),
  CONSTRAINT `fk_configgroup_cluster_id`
    FOREIGN KEY (`cluster_id`)
    REFERENCES `ambari`.`clusters` (`cluster_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table ambari.configgrouphostmapping
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`configgrouphostmapping` (
  `config_group_id` BIGINT NOT NULL COMMENT '',
  `host_name` VARCHAR(255) NOT NULL COMMENT '',
  PRIMARY KEY (`config_group_id`, `host_name`),
  CONSTRAINT `fk_cghm_cgid`
    FOREIGN KEY (`config_group_id`)
    REFERENCES `ambari`.`configgroup` (`group_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_cghm_hname`
    FOREIGN KEY (`host_name`)
    REFERENCES `ambari`.`hosts` (`host_name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table ambari.execution_command
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`execution_command` (
  `command` LONGBLOB NULL COMMENT '',
  `task_id` BIGINT NOT NULL COMMENT '',
  PRIMARY KEY (`task_id`) ,
  CONSTRAINT `fk_execution_command_task_id`
    FOREIGN KEY (`task_id`)
    REFERENCES `ambari`.`host_role_command` (`task_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table ambari.groups
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`groups` (
  `group_id` INT NOT NULL COMMENT '',
  `principal_id` BIGINT NOT NULL COMMENT '',
  `group_name` VARCHAR(255) NOT NULL COMMENT '',
  `ldap_group` INT NOT NULL DEFAULT 0 COMMENT '',
  PRIMARY KEY (`group_id`) ,
  UNIQUE INDEX `groups_ldap_group_key` (`group_name` ASC, `ldap_group` ASC)  ,
  CONSTRAINT `fk_groups_principal_id`
    FOREIGN KEY (`principal_id`)
    REFERENCES `ambari`.`adminprincipal` (`principal_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table ambari.host_role_command
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`host_role_command` (
  `task_id` BIGINT NOT NULL COMMENT '',
  `attempt_count` SMALLINT NOT NULL COMMENT '',
  `retry_allowed` SMALLINT NOT NULL DEFAULT 0 COMMENT '',
  `event` VARCHAR(32000) NOT NULL COMMENT '',
  `exitcode` INT NOT NULL COMMENT '',
  `host_name` VARCHAR(255) NOT NULL COMMENT '',
  `last_attempt_time` BIGINT NOT NULL COMMENT '',
  `request_id` BIGINT NOT NULL COMMENT '',
  `role` VARCHAR(255) NULL COMMENT '',
  `stage_id` BIGINT NOT NULL COMMENT '',
  `start_time` BIGINT NOT NULL COMMENT '',
  `end_time` BIGINT NULL COMMENT '',
  `status` VARCHAR(255) NULL COMMENT '',
  `std_error` LONGBLOB NULL COMMENT '',
  `std_out` LONGBLOB NULL COMMENT '',
  `output_log` VARCHAR(255) NULL COMMENT '',
  `error_log` VARCHAR(255) NULL COMMENT '',
  `structured_out` LONGBLOB NULL COMMENT '',
  `role_command` VARCHAR(255) NULL COMMENT '',
  `command_detail` VARCHAR(255) NULL COMMENT '',
  `custom_command_name` VARCHAR(255) NULL COMMENT '',
  PRIMARY KEY (`task_id`),
  CONSTRAINT `fk_host_role_command_host_name`
    FOREIGN KEY (`host_name`)
    REFERENCES `ambari`.`hosts` (`host_name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_host_role_command_stage_id`
    FOREIGN KEY (`stage_id` , `request_id`)
    REFERENCES `ambari`.`stage` (`stage_id` , `request_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table ambari.host_version
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`host_version` (
  `id` BIGINT NOT NULL COMMENT '',
  `host_name` VARCHAR(255) NOT NULL COMMENT '',
  `repo_version_id` BIGINT NOT NULL COMMENT '',
  `state` VARCHAR(32) NOT NULL COMMENT '',
  PRIMARY KEY (`id`) ,
  CONSTRAINT `fk_host_version_host_name`
    FOREIGN KEY (`host_name`)
    REFERENCES `ambari`.`hosts` (`host_name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_host_version_repovers_id`
    FOREIGN KEY (`repo_version_id`)
    REFERENCES `ambari`.`repo_version` (`repo_version_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table ambari.hostcomponentdesiredstate
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`hostcomponentdesiredstate` (
  `cluster_id` BIGINT NOT NULL COMMENT '',
  `component_name` VARCHAR(255) NOT NULL COMMENT '',
  `desired_stack_version` VARCHAR(255) NOT NULL COMMENT '',
  `desired_state` VARCHAR(255) NOT NULL COMMENT '',
  `host_name` VARCHAR(255) NOT NULL COMMENT '',
  `service_name` VARCHAR(255) NOT NULL COMMENT '',
  `admin_state` VARCHAR(32) NULL COMMENT '',
  `maintenance_state` VARCHAR(32) NOT NULL COMMENT '',
  `security_state` VARCHAR(32) NOT NULL DEFAULT 'UNSECURED' COMMENT '',
  `restart_required` SMALLINT NOT NULL DEFAULT 0 COMMENT '',
  PRIMARY KEY (`cluster_id`, `component_name`, `host_name`, `service_name`),
  CONSTRAINT `hstcmpnntdesiredstatecmpnntnme`
    FOREIGN KEY (`component_name` , `cluster_id` , `service_name`)
    REFERENCES `ambari`.`servicecomponentdesiredstate` (`component_name` , `cluster_id` , `service_name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `hstcmponentdesiredstatehstname`
    FOREIGN KEY (`host_name`)
    REFERENCES `ambari`.`hosts` (`host_name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table ambari.hostcomponentstate
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`hostcomponentstate` (
  `cluster_id` BIGINT NOT NULL COMMENT '',
  `component_name` VARCHAR(255) NOT NULL COMMENT '',
  `version` VARCHAR(32) NOT NULL DEFAULT 'UNKNOWN' COMMENT '',
  `current_stack_version` VARCHAR(255) NOT NULL COMMENT '',
  `current_state` VARCHAR(255) NOT NULL COMMENT '',
  `host_name` VARCHAR(255) NOT NULL COMMENT '',
  `service_name` VARCHAR(255) NOT NULL COMMENT '',
  `upgrade_state` VARCHAR(32) NOT NULL DEFAULT 'NONE' COMMENT '',
  `security_state` VARCHAR(32) NOT NULL DEFAULT 'UNSECURED' COMMENT '',
  PRIMARY KEY (`cluster_id`, `component_name`, `host_name`, `service_name`),
  CONSTRAINT `hostcomponentstate_host_name`
    FOREIGN KEY (`host_name`)
    REFERENCES `ambari`.`hosts` (`host_name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `hstcomponentstatecomponentname`
    FOREIGN KEY (`component_name` , `cluster_id` , `service_name`)
    REFERENCES `ambari`.`servicecomponentdesiredstate` (`component_name` , `cluster_id` , `service_name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table ambari.hostconfigmapping
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`hostconfigmapping` (
  `cluster_id` BIGINT NOT NULL COMMENT '',
  `host_name` VARCHAR(255) NOT NULL COMMENT '',
  `type_name` VARCHAR(255) NOT NULL COMMENT '',
  `version_tag` VARCHAR(255) NOT NULL COMMENT '',
  `service_name` VARCHAR(255) NULL COMMENT '',
  `create_timestamp` BIGINT NOT NULL COMMENT '',
  `selected` INT NOT NULL DEFAULT 0 COMMENT '',
  `user_name` VARCHAR(255) NOT NULL DEFAULT '_db' COMMENT '',
  PRIMARY KEY (`cluster_id`, `host_name`, `type_name`, `create_timestamp`),
  CONSTRAINT `fk_hostconfmapping_cluster_id`
    FOREIGN KEY (`cluster_id`)
    REFERENCES `ambari`.`clusters` (`cluster_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_hostconfmapping_host_name`
    FOREIGN KEY (`host_name`)
    REFERENCES `ambari`.`hosts` (`host_name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table ambari.hostgroup
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`hostgroup` (
  `blueprint_name` VARCHAR(255) NOT NULL COMMENT '',
  `name` VARCHAR(255) NOT NULL COMMENT '',
  `cardinality` VARCHAR(255) NOT NULL COMMENT '',
  PRIMARY KEY (`blueprint_name`, `name`),
  CONSTRAINT `fk_hg_blueprint_name`
    FOREIGN KEY (`blueprint_name`)
    REFERENCES `ambari`.`blueprint` (`blueprint_name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table ambari.hostgroup_component
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`hostgroup_component` (
  `blueprint_name` VARCHAR(255) NOT NULL COMMENT '',
  `hostgroup_name` VARCHAR(255) NOT NULL COMMENT '',
  `name` VARCHAR(255) NOT NULL COMMENT '',
  PRIMARY KEY (`blueprint_name`, `hostgroup_name`, `name`),
  CONSTRAINT `fk_hgc_blueprint_name`
    FOREIGN KEY (`blueprint_name` , `hostgroup_name`)
    REFERENCES `ambari`.`hostgroup` (`blueprint_name` , `name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table ambari.hostgroup_configuration
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`hostgroup_configuration` (
  `blueprint_name` VARCHAR(255) NOT NULL COMMENT '',
  `hostgroup_name` VARCHAR(255) NOT NULL COMMENT '',
  `type_name` VARCHAR(255) NOT NULL COMMENT '',
  `config_data` LONGTEXT NOT NULL COMMENT '',
  `config_attributes` VARCHAR(32000) NULL COMMENT '',
  PRIMARY KEY (`blueprint_name`, `hostgroup_name`, `type_name`) ,
  CONSTRAINT `fk_hg_cfg_bp_hg_name`
    FOREIGN KEY (`blueprint_name` , `hostgroup_name`)
    REFERENCES `ambari`.`hostgroup` (`blueprint_name` , `name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table ambari.hosts
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`hosts` (
  `host_name` VARCHAR(255) NOT NULL COMMENT '',
  `cpu_count` INT NOT NULL COMMENT '',
  `ph_cpu_count` INT NULL COMMENT '',
  `cpu_info` VARCHAR(255) NOT NULL COMMENT '',
  `discovery_status` VARCHAR(2000) NOT NULL COMMENT '',
  `host_attributes` VARCHAR(20000) NOT NULL COMMENT '',
  `ipv4` VARCHAR(255) NULL COMMENT '',
  `ipv6` VARCHAR(255) NULL COMMENT '',
  `public_host_name` VARCHAR(255) NULL COMMENT '',
  `last_registration_time` BIGINT NOT NULL COMMENT '',
  `os_arch` VARCHAR(255) NOT NULL COMMENT '',
  `os_info` VARCHAR(1000) NOT NULL COMMENT '',
  `os_type` VARCHAR(255) NOT NULL COMMENT '',
  `rack_info` VARCHAR(255) NOT NULL COMMENT '',
  `total_mem` BIGINT NOT NULL COMMENT '',
  PRIMARY KEY (`host_name`));

-- ----------------------------------------------------------------------------
-- Table ambari.hoststate
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`hoststate` (
  `agent_version` VARCHAR(255) NOT NULL COMMENT '',
  `available_mem` BIGINT NOT NULL COMMENT '',
  `current_state` VARCHAR(255) NOT NULL COMMENT '',
  `health_status` VARCHAR(255) NULL COMMENT '',
  `host_name` VARCHAR(255) NOT NULL COMMENT '',
  `time_in_state` BIGINT NOT NULL COMMENT '',
  `maintenance_state` VARCHAR(512) NULL COMMENT '',
  PRIMARY KEY (`host_name`) ,
  CONSTRAINT `fk_hoststate_host_name`
    FOREIGN KEY (`host_name`)
    REFERENCES `ambari`.`hosts` (`host_name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table ambari.kerberos_principal
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`kerberos_principal` (
  `principal_name` VARCHAR(255) NOT NULL COMMENT '',
  `is_service` SMALLINT NOT NULL DEFAULT 1 COMMENT '',
  `cached_keytab_path` VARCHAR(255) NULL COMMENT '',
  PRIMARY KEY (`principal_name`) );

-- ----------------------------------------------------------------------------
-- Table ambari.kerberos_principal_host
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`kerberos_principal_host` (
  `principal_name` VARCHAR(255) NOT NULL COMMENT '',
  `host_name` VARCHAR(255) NOT NULL COMMENT '',
  PRIMARY KEY (`principal_name`, `host_name`) ,
  CONSTRAINT `fk_krb_pr_host_hostname`
    FOREIGN KEY (`host_name`)
    REFERENCES `ambari`.`hosts` (`host_name`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_krb_pr_host_principalname`
    FOREIGN KEY (`principal_name`)
    REFERENCES `ambari`.`kerberos_principal` (`principal_name`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table ambari.key_value_store
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`key_value_store` (
  `key` VARCHAR(255) NOT NULL COMMENT '',
  `value` LONGTEXT NULL COMMENT '',
  PRIMARY KEY (`key`)  );

-- ----------------------------------------------------------------------------
-- Table ambari.members
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`members` (
  `member_id` INT NOT NULL COMMENT '',
  `group_id` INT NOT NULL COMMENT '',
  `user_id` INT NOT NULL COMMENT '',
  PRIMARY KEY (`member_id`) ,
  UNIQUE INDEX `members_group_id_key` (`group_id` ASC, `user_id` ASC) ,
  CONSTRAINT `fk_members_group_id`
    FOREIGN KEY (`group_id`)
    REFERENCES `ambari`.`groups` (`group_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_members_user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `ambari`.`users` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table ambari.metainfo
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`metainfo` (
  `metainfo_key` VARCHAR(255) NOT NULL COMMENT '',
  `metainfo_value` LONGTEXT NULL COMMENT '',
  PRIMARY KEY (`metainfo_key`) );

-- ----------------------------------------------------------------------------
-- Table ambari.qrtz_blob_triggers
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`qrtz_blob_triggers` (
  `sched_name` VARCHAR(120) NOT NULL COMMENT '',
  `trigger_name` VARCHAR(200) NOT NULL COMMENT '',
  `trigger_group` VARCHAR(200) NOT NULL COMMENT '',
  `blob_data` LONGBLOB NULL COMMENT '',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) ,
  CONSTRAINT `qrtz_blob_triggers_sched_name_fkey`
    FOREIGN KEY (`sched_name` , `trigger_name` , `trigger_group`)
    REFERENCES `ambari`.`qrtz_triggers` (`sched_name` , `trigger_name` , `trigger_group`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table ambari.qrtz_calendars
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`qrtz_calendars` (
  `sched_name` VARCHAR(120) NOT NULL COMMENT '',
  `calendar_name` VARCHAR(200) NOT NULL COMMENT '',
  `calendar` LONGBLOB NOT NULL COMMENT '',
  PRIMARY KEY (`sched_name`, `calendar_name`) );

-- ----------------------------------------------------------------------------
-- Table ambari.qrtz_cron_triggers
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`qrtz_cron_triggers` (
  `sched_name` VARCHAR(120) NOT NULL COMMENT '',
  `trigger_name` VARCHAR(200) NOT NULL COMMENT '',
  `trigger_group` VARCHAR(200) NOT NULL COMMENT '',
  `cron_expression` VARCHAR(120) NOT NULL COMMENT '',
  `time_zone_id` VARCHAR(80) NULL COMMENT '',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) ,
  CONSTRAINT `qrtz_cron_triggers_sched_name_fkey`
    FOREIGN KEY (`sched_name` , `trigger_name` , `trigger_group`)
    REFERENCES `ambari`.`qrtz_triggers` (`sched_name` , `trigger_name` , `trigger_group`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table ambari.qrtz_fired_triggers
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`qrtz_fired_triggers` (
  `sched_name` VARCHAR(120) NOT NULL COMMENT '',
  `entry_id` VARCHAR(95) NOT NULL COMMENT '',
  `trigger_name` VARCHAR(200) NOT NULL COMMENT '',
  `trigger_group` VARCHAR(200) NOT NULL COMMENT '',
  `instance_name` VARCHAR(200) NOT NULL COMMENT '',
  `fired_time` BIGINT NOT NULL COMMENT '',
  `sched_time` BIGINT NOT NULL COMMENT '',
  `priority` INT NOT NULL COMMENT '',
  `state` VARCHAR(16) NOT NULL COMMENT '',
  `job_name` VARCHAR(200) NULL COMMENT '',
  `job_group` VARCHAR(200) NULL COMMENT '',
  `is_nonconcurrent` TINYINT NULL COMMENT '',
  `requests_recovery` TINYINT NULL COMMENT '',
  PRIMARY KEY (`sched_name`, `entry_id`)  ,
  INDEX `idx_qrtz_ft_inst_job_req_rcvry` (`sched_name` ASC, `instance_name` ASC, `requests_recovery` ASC) ,
  INDEX `idx_qrtz_ft_j_g` (`sched_name` ASC, `job_name` ASC, `job_group` ASC)  ,
  INDEX `idx_qrtz_ft_jg` (`sched_name` ASC, `job_group` ASC)  ,
  INDEX `idx_qrtz_ft_t_g` (`sched_name` ASC, `trigger_name` ASC, `trigger_group` ASC) ,
  INDEX `idx_qrtz_ft_tg` (`sched_name` ASC, `trigger_group` ASC) ,
  INDEX `idx_qrtz_ft_trig_inst_name` (`sched_name` ASC, `instance_name` ASC) );

-- ----------------------------------------------------------------------------
-- Table ambari.qrtz_job_details
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`qrtz_job_details` (
  `sched_name` VARCHAR(120) NOT NULL COMMENT '',
  `job_name` VARCHAR(200) NOT NULL COMMENT '',
  `job_group` VARCHAR(200) NOT NULL COMMENT '',
  `description` VARCHAR(250) NULL COMMENT '',
  `job_class_name` VARCHAR(250) NOT NULL COMMENT '',
  `is_durable` TINYINT NOT NULL COMMENT '',
  `is_nonconcurrent` TINYINT NOT NULL COMMENT '',
  `is_update_data` TINYINT NOT NULL COMMENT '',
  `requests_recovery` TINYINT NOT NULL COMMENT '',
  `job_data` LONGBLOB NULL COMMENT '',
  PRIMARY KEY (`sched_name`, `job_name`, `job_group`) ,
  INDEX `idx_qrtz_j_grp` (`sched_name` ASC, `job_group` ASC) ,
  INDEX `idx_qrtz_j_req_recovery` (`sched_name` ASC, `requests_recovery` ASC) );

-- ----------------------------------------------------------------------------
-- Table ambari.qrtz_locks
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`qrtz_locks` (
  `sched_name` VARCHAR(120) NOT NULL COMMENT '',
  `lock_name` VARCHAR(40) NOT NULL COMMENT '',
  PRIMARY KEY (`sched_name`, `lock_name`) );

-- ----------------------------------------------------------------------------
-- Table ambari.qrtz_paused_trigger_grps
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`qrtz_paused_trigger_grps` (
  `sched_name` VARCHAR(120) NOT NULL COMMENT '',
  `trigger_group` VARCHAR(200) NOT NULL COMMENT '',
  PRIMARY KEY (`sched_name`, `trigger_group`) );

-- ----------------------------------------------------------------------------
-- Table ambari.qrtz_scheduler_state
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`qrtz_scheduler_state` (
  `sched_name` VARCHAR(120) NOT NULL COMMENT '',
  `instance_name` VARCHAR(200) NOT NULL COMMENT '',
  `last_checkin_time` BIGINT NOT NULL COMMENT '',
  `checkin_interval` BIGINT NOT NULL COMMENT '',
  PRIMARY KEY (`sched_name`, `instance_name`) );

-- ----------------------------------------------------------------------------
-- Table ambari.qrtz_simple_triggers
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`qrtz_simple_triggers` (
  `sched_name` VARCHAR(120) NOT NULL COMMENT '',
  `trigger_name` VARCHAR(200) NOT NULL COMMENT '',
  `trigger_group` VARCHAR(200) NOT NULL COMMENT '',
  `repeat_count` BIGINT NOT NULL COMMENT '',
  `repeat_interval` BIGINT NOT NULL COMMENT '',
  `times_triggered` BIGINT NOT NULL COMMENT '',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`)  ,
  CONSTRAINT `qrtz_simple_triggers_sched_name_fkey`
    FOREIGN KEY (`sched_name` , `trigger_name` , `trigger_group`)
    REFERENCES `ambari`.`qrtz_triggers` (`sched_name` , `trigger_name` , `trigger_group`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table ambari.qrtz_simprop_triggers
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`qrtz_simprop_triggers` (
  `sched_name` VARCHAR(120) NOT NULL COMMENT '',
  `trigger_name` VARCHAR(200) NOT NULL COMMENT '',
  `trigger_group` VARCHAR(200) NOT NULL COMMENT '',
  `str_prop_1` VARCHAR(512) NULL COMMENT '',
  `str_prop_2` VARCHAR(512) NULL COMMENT '',
  `str_prop_3` VARCHAR(512) NULL COMMENT '',
  `int_prop_1` INT NULL COMMENT '',
  `int_prop_2` INT NULL COMMENT '',
  `long_prop_1` BIGINT NULL COMMENT '',
  `long_prop_2` BIGINT NULL COMMENT '',
  `dec_prop_1` DECIMAL(13,4) NULL COMMENT '',
  `dec_prop_2` DECIMAL(13,4) NULL COMMENT '',
  `bool_prop_1` TINYINT NULL COMMENT '',
  `bool_prop_2` TINYINT NULL COMMENT '',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) ,
  CONSTRAINT `qrtz_simprop_triggers_sched_name_fkey`
    FOREIGN KEY (`sched_name` , `trigger_name` , `trigger_group`)
    REFERENCES `ambari`.`qrtz_triggers` (`sched_name` , `trigger_name` , `trigger_group`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table ambari.qrtz_triggers
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`qrtz_triggers` (
  `sched_name` VARCHAR(120) NOT NULL COMMENT '',
  `trigger_name` VARCHAR(200) NOT NULL COMMENT '',
  `trigger_group` VARCHAR(200) NOT NULL COMMENT '',
  `job_name` VARCHAR(200) NOT NULL COMMENT '',
  `job_group` VARCHAR(200) NOT NULL COMMENT '',
  `description` VARCHAR(250) NULL COMMENT '',
  `next_fire_time` BIGINT NULL COMMENT '',
  `prev_fire_time` BIGINT NULL COMMENT '',
  `priority` INT NULL COMMENT '',
  `trigger_state` VARCHAR(16) NOT NULL COMMENT '',
  `trigger_type` VARCHAR(8) NOT NULL COMMENT '',
  `start_time` BIGINT NOT NULL COMMENT '',
  `end_time` BIGINT NULL COMMENT '',
  `calendar_name` VARCHAR(200) NULL COMMENT '',
  `misfire_instr` SMALLINT NULL COMMENT '',
  `job_data` LONGBLOB NULL COMMENT '',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) ,
  INDEX `idx_qrtz_t_c` (`sched_name` ASC, `calendar_name` ASC) ,
  INDEX `idx_qrtz_t_g` (`sched_name` ASC, `trigger_group` ASC) ,
  INDEX `idx_qrtz_t_j` (`sched_name` ASC, `job_name` ASC, `job_group` ASC)  ,
  INDEX `idx_qrtz_t_jg` (`sched_name` ASC, `job_group` ASC) ,
  INDEX `idx_qrtz_t_n_g_state` (`sched_name` ASC, `trigger_group` ASC, `trigger_state` ASC)  ,
  INDEX `idx_qrtz_t_n_state` (`sched_name` ASC, `trigger_name` ASC, `trigger_group` ASC, `trigger_state` ASC)  ,
  INDEX `idx_qrtz_t_next_fire_time` (`sched_name` ASC, `next_fire_time` ASC)  ,
  INDEX `idx_qrtz_t_nft_misfire` (`sched_name` ASC, `next_fire_time` ASC, `misfire_instr` ASC)  ,
  INDEX `idx_qrtz_t_nft_st` (`sched_name` ASC, `next_fire_time` ASC, `trigger_state` ASC)  ,
  INDEX `idx_qrtz_t_nft_st_misfire` (`sched_name` ASC, `next_fire_time` ASC, `trigger_state` ASC, `misfire_instr` ASC) ,
  INDEX `idx_qrtz_t_nft_st_misfire_grp` (`sched_name` ASC, `trigger_group` ASC, `next_fire_time` ASC, `trigger_state` ASC, `misfire_instr` ASC)  ,
  INDEX `idx_qrtz_t_state` (`sched_name` ASC, `trigger_state` ASC)  ,
  CONSTRAINT `qrtz_triggers_sched_name_fkey`
    FOREIGN KEY (`sched_name` , `job_name` , `job_group`)
    REFERENCES `ambari`.`qrtz_job_details` (`sched_name` , `job_name` , `job_group`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table ambari.repo_version
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`repo_version` (
  `repo_version_id` BIGINT NOT NULL COMMENT '',
  `stack` VARCHAR(255) NOT NULL COMMENT '',
  `version` VARCHAR(255) NOT NULL COMMENT '',
  `display_name` VARCHAR(128) NOT NULL COMMENT '',
  `upgrade_package` VARCHAR(255) NOT NULL COMMENT '',
  `repositories` LONGTEXT NOT NULL COMMENT '',
  PRIMARY KEY (`repo_version_id`) ,
  UNIQUE INDEX `uq_repo_version_display_name` (`display_name` ASC)  ,
  UNIQUE INDEX `uq_repo_version_stack_version` (`stack` ASC, `version` ASC) );

-- ----------------------------------------------------------------------------
-- Table ambari.request
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`request` (
  `request_id` BIGINT NOT NULL COMMENT '',
  `cluster_id` BIGINT NULL COMMENT '',
  `command_name` VARCHAR(255) NULL COMMENT '',
  `create_time` BIGINT NOT NULL COMMENT '',
  `end_time` BIGINT NOT NULL COMMENT '',
  `exclusive_execution` SMALLINT NOT NULL DEFAULT 0 COMMENT '',
  `inputs` LONGBLOB NULL COMMENT '',
  `request_context` VARCHAR(255) NULL COMMENT '',
  `request_type` VARCHAR(255) NULL COMMENT '',
  `request_schedule_id` BIGINT NULL COMMENT '',
  `start_time` BIGINT NOT NULL COMMENT '',
  `status` VARCHAR(255) NULL COMMENT '',
  PRIMARY KEY (`request_id`) ,
  CONSTRAINT `fk_request_schedule_id`
    FOREIGN KEY (`request_schedule_id`)
    REFERENCES `ambari`.`requestschedule` (`schedule_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table ambari.requestoperationlevel
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`requestoperationlevel` (
  `operation_level_id` BIGINT NOT NULL COMMENT '',
  `request_id` BIGINT NOT NULL COMMENT '',
  `level_name` VARCHAR(255) NULL COMMENT '',
  `cluster_name` VARCHAR(255) NULL COMMENT '',
  `service_name` VARCHAR(255) NULL COMMENT '',
  `host_component_name` VARCHAR(255) NULL COMMENT '',
  `host_name` VARCHAR(255) NULL COMMENT '',
  PRIMARY KEY (`operation_level_id`)  ,
  CONSTRAINT `fk_req_op_level_req_id`
    FOREIGN KEY (`request_id`)
    REFERENCES `ambari`.`request` (`request_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table ambari.requestresourcefilter
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`requestresourcefilter` (
  `filter_id` BIGINT NOT NULL COMMENT '',
  `request_id` BIGINT NOT NULL COMMENT '',
  `service_name` VARCHAR(255) NULL COMMENT '',
  `component_name` VARCHAR(255) NULL COMMENT '',
  `hosts` LONGBLOB NULL COMMENT '',
  PRIMARY KEY (`filter_id`)  ,
  CONSTRAINT `fk_reqresfilter_req_id`
    FOREIGN KEY (`request_id`)
    REFERENCES `ambari`.`request` (`request_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table ambari.requestschedule
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`requestschedule` (
  `schedule_id` BIGINT NOT NULL COMMENT '',
  `cluster_id` BIGINT NOT NULL COMMENT '',
  `description` VARCHAR(255) NULL COMMENT '',
  `status` VARCHAR(255) NULL COMMENT '',
  `batch_separation_seconds` SMALLINT NULL COMMENT '',
  `batch_toleration_limit` SMALLINT NULL COMMENT '',
  `create_user` VARCHAR(255) NULL COMMENT '',
  `create_timestamp` BIGINT NULL COMMENT '',
  `update_user` VARCHAR(255) NULL COMMENT '',
  `update_timestamp` BIGINT NULL COMMENT '',
  `minutes` VARCHAR(10) NULL COMMENT '',
  `hours` VARCHAR(10) NULL COMMENT '',
  `days_of_month` VARCHAR(10) NULL COMMENT '',
  `month` VARCHAR(10) NULL COMMENT '',
  `day_of_week` VARCHAR(10) NULL COMMENT '',
  `yeartoschedule` VARCHAR(10) NULL COMMENT '',
  `starttime` VARCHAR(50) NULL COMMENT '',
  `endtime` VARCHAR(50) NULL COMMENT '',
  `last_execution_status` VARCHAR(255) NULL COMMENT '',
  PRIMARY KEY (`schedule_id`) );

-- ----------------------------------------------------------------------------
-- Table ambari.requestschedulebatchrequest
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`requestschedulebatchrequest` (
  `schedule_id` BIGINT NOT NULL COMMENT '',
  `batch_id` BIGINT NOT NULL COMMENT '',
  `request_id` BIGINT NULL COMMENT '',
  `request_type` VARCHAR(255) NULL COMMENT '',
  `request_uri` VARCHAR(1024) NULL COMMENT '',
  `request_body` LONGBLOB NULL COMMENT '',
  `request_status` VARCHAR(255) NULL COMMENT '',
  `return_code` SMALLINT NULL COMMENT '',
  `return_message` VARCHAR(20000) NULL COMMENT '',
  PRIMARY KEY (`schedule_id`, `batch_id`)  ,
  CONSTRAINT `fk_rsbatchrequest_schedule_id`
    FOREIGN KEY (`schedule_id`)
    REFERENCES `ambari`.`requestschedule` (`schedule_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table ambari.role_success_criteria
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`role_success_criteria` (
  `role` VARCHAR(255) NOT NULL COMMENT '',
  `request_id` BIGINT NOT NULL COMMENT '',
  `stage_id` BIGINT NOT NULL COMMENT '',
  `success_factor` DOUBLE NOT NULL COMMENT '',
  PRIMARY KEY (`role`, `request_id`, `stage_id`) ,
  CONSTRAINT `role_success_criteria_stage_id`
    FOREIGN KEY (`stage_id` , `request_id`)
    REFERENCES `ambari`.`stage` (`stage_id` , `request_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table ambari.servicecomponentdesiredstate
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`servicecomponentdesiredstate` (
  `component_name` VARCHAR(255) NOT NULL COMMENT '',
  `cluster_id` BIGINT NOT NULL COMMENT '',
  `desired_stack_version` VARCHAR(255) NOT NULL COMMENT '',
  `desired_state` VARCHAR(255) NOT NULL COMMENT '',
  `service_name` VARCHAR(255) NOT NULL COMMENT '',
  PRIMARY KEY (`component_name`, `cluster_id`, `service_name`)  ,
  CONSTRAINT `srvccmponentdesiredstatesrvcnm`
    FOREIGN KEY (`service_name` , `cluster_id`)
    REFERENCES `ambari`.`clusterservices` (`service_name` , `cluster_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table ambari.serviceconfig
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`serviceconfig` (
  `service_config_id` BIGINT NOT NULL COMMENT '',
  `cluster_id` BIGINT NOT NULL COMMENT '',
  `service_name` VARCHAR(255) NOT NULL COMMENT '',
  `version` BIGINT NOT NULL COMMENT '',
  `create_timestamp` BIGINT NOT NULL COMMENT '',
  `user_name` VARCHAR(255) NOT NULL DEFAULT '_db' COMMENT '',
  `group_id` BIGINT NULL COMMENT '',
  `note` LONGTEXT NULL COMMENT '',
  PRIMARY KEY (`service_config_id`)  ,
  UNIQUE INDEX `uq_scv_service_version` (`cluster_id` ASC, `service_name` ASC, `version` ASC)  );

-- ----------------------------------------------------------------------------
-- Table ambari.serviceconfighosts
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`serviceconfighosts` (
  `service_config_id` BIGINT NOT NULL COMMENT '',
  `hostname` VARCHAR(255) NOT NULL COMMENT '',
  PRIMARY KEY (`service_config_id`, `hostname`) ,
  CONSTRAINT `fk_scvhosts_scv`
    FOREIGN KEY (`service_config_id`)
    REFERENCES `ambari`.`serviceconfig` (`service_config_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table ambari.serviceconfigmapping
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`serviceconfigmapping` (
  `service_config_id` BIGINT NOT NULL COMMENT '',
  `config_id` BIGINT NOT NULL COMMENT '',
  PRIMARY KEY (`service_config_id`, `config_id`) ,
  CONSTRAINT `fk_scvm_config`
    FOREIGN KEY (`config_id`)
    REFERENCES `ambari`.`clusterconfig` (`config_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_scvm_scv`
    FOREIGN KEY (`service_config_id`)
    REFERENCES `ambari`.`serviceconfig` (`service_config_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table ambari.servicedesiredstate
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`servicedesiredstate` (
  `cluster_id` BIGINT NOT NULL COMMENT '',
  `desired_host_role_mapping` INT NOT NULL COMMENT '',
  `desired_stack_version` VARCHAR(255) NOT NULL COMMENT '',
  `desired_state` VARCHAR(255) NOT NULL COMMENT '',
  `service_name` VARCHAR(255) NOT NULL COMMENT '',
  `maintenance_state` VARCHAR(32) NOT NULL COMMENT '',
  `security_state` VARCHAR(32) NOT NULL DEFAULT 'UNSECURED' COMMENT '',
  PRIMARY KEY (`cluster_id`, `service_name`) ,
  CONSTRAINT `servicedesiredstateservicename`
    FOREIGN KEY (`service_name` , `cluster_id`)
    REFERENCES `ambari`.`clusterservices` (`service_name` , `cluster_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table ambari.stage
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`stage` (
  `stage_id` BIGINT NOT NULL COMMENT '',
  `request_id` BIGINT NOT NULL COMMENT '',
  `cluster_id` BIGINT NOT NULL COMMENT '',
  `skippable` SMALLINT NOT NULL DEFAULT 0 COMMENT '',
  `log_info` VARCHAR(255) NOT NULL COMMENT '',
  `request_context` VARCHAR(255) NULL COMMENT '',
  `cluster_host_info` LONGBLOB NOT NULL COMMENT '',
  `command_params` LONGBLOB NULL COMMENT '',
  `host_params` LONGBLOB NULL COMMENT '',
  PRIMARY KEY (`stage_id`, `request_id`) ,
  CONSTRAINT `fk_stage_request_id`
    FOREIGN KEY (`request_id`)
    REFERENCES `ambari`.`request` (`request_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table ambari.upgrade
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`upgrade` (
  `upgrade_id` BIGINT NOT NULL COMMENT '',
  `cluster_id` BIGINT NOT NULL COMMENT '',
  `request_id` BIGINT NOT NULL COMMENT '',
  `from_version` VARCHAR(255) NOT NULL DEFAULT '' COMMENT '',
  `to_version` VARCHAR(255) NOT NULL DEFAULT '' COMMENT '',
  `direction` VARCHAR(255) NOT NULL DEFAULT 'UPGRADE' COMMENT '',
  PRIMARY KEY (`upgrade_id`) ,
  CONSTRAINT `upgrade_cluster_id_fkey`
    FOREIGN KEY (`cluster_id`)
    REFERENCES `ambari`.`clusters` (`cluster_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `upgrade_request_id_fkey`
    FOREIGN KEY (`request_id`)
    REFERENCES `ambari`.`request` (`request_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table ambari.upgrade_group
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`upgrade_group` (
  `upgrade_group_id` BIGINT NOT NULL COMMENT '',
  `upgrade_id` BIGINT NOT NULL COMMENT '',
  `group_name` VARCHAR(255) NOT NULL DEFAULT '' COMMENT '',
  `group_title` VARCHAR(1024) NOT NULL DEFAULT '' COMMENT '',
  PRIMARY KEY (`upgrade_group_id`)  ,
  CONSTRAINT `upgrade_group_upgrade_id_fkey`
    FOREIGN KEY (`upgrade_id`)
    REFERENCES `ambari`.`upgrade` (`upgrade_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table ambari.upgrade_item
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`upgrade_item` (
  `upgrade_item_id` BIGINT NOT NULL COMMENT '',
  `upgrade_group_id` BIGINT NOT NULL COMMENT '',
  `stage_id` BIGINT NOT NULL COMMENT '',
  `state` VARCHAR(255) NOT NULL DEFAULT 'NONE' COMMENT '',
  `hosts` LONGTEXT NULL COMMENT '',
  `tasks` LONGTEXT NULL COMMENT '',
  `item_text` VARCHAR(1024) NULL COMMENT '',
  PRIMARY KEY (`upgrade_item_id`)  ,
  CONSTRAINT `upgrade_item_upgrade_group_id_fkey`
    FOREIGN KEY (`upgrade_group_id`)
    REFERENCES `ambari`.`upgrade_group` (`upgrade_group_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table ambari.users
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`users` (
  `user_id` INT NOT NULL COMMENT '',
  `principal_id` BIGINT NOT NULL COMMENT '',
  `ldap_user` INT NOT NULL DEFAULT 0 COMMENT '',
  `user_name` VARCHAR(255) NOT NULL COMMENT '',
  `create_time` DATETIME NULL COMMENT '',
  `user_password` VARCHAR(255) NULL COMMENT '',
  `active` INT NOT NULL DEFAULT 1 COMMENT '',
  PRIMARY KEY (`user_id`)  ,
  UNIQUE INDEX `users_ldap_user_key` (`ldap_user` ASC, `user_name` ASC)  ,
  CONSTRAINT `fk_users_principal_id`
    FOREIGN KEY (`principal_id`)
    REFERENCES `ambari`.`adminprincipal` (`principal_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table ambari.viewentity
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`viewentity` (
  `id` BIGINT NOT NULL COMMENT '',
  `view_name` VARCHAR(255) NOT NULL COMMENT '',
  `view_instance_name` VARCHAR(255) NOT NULL COMMENT '',
  `class_name` VARCHAR(255) NOT NULL COMMENT '',
  `id_property` VARCHAR(255) NULL COMMENT '',
  PRIMARY KEY (`id`)  ,
  CONSTRAINT `fk_viewentity_view_name`
    FOREIGN KEY (`view_name` , `view_instance_name`)
    REFERENCES `ambari`.`viewinstance` (`view_name` , `name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table ambari.viewinstance
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`viewinstance` (
  `view_instance_id` BIGINT NOT NULL COMMENT '',
  `resource_id` BIGINT NOT NULL COMMENT '',
  `view_name` VARCHAR(255) NOT NULL COMMENT '',
  `name` VARCHAR(255) NOT NULL COMMENT '',
  `label` VARCHAR(255) NULL COMMENT '',
  `description` VARCHAR(2048) NULL COMMENT '',
  `visible` CHAR(1) NULL COMMENT '',
  `icon` VARCHAR(255) NULL COMMENT '',
  `icon64` VARCHAR(255) NULL COMMENT '',
  `xml_driven` CHAR(1) NULL COMMENT '',
  PRIMARY KEY (`view_instance_id`) ,
  UNIQUE INDEX `uq_viewinstance_name` (`view_name` ASC, `name` ASC)  ,
  UNIQUE INDEX `uq_viewinstance_name_id` (`view_instance_id` ASC, `view_name` ASC, `name` ASC)  ,
  CONSTRAINT `fk_viewinstance_resource_id`
    FOREIGN KEY (`resource_id`)
    REFERENCES `ambari`.`adminresource` (`resource_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_viewinst_view_name`
    FOREIGN KEY (`view_name`)
    REFERENCES `ambari`.`viewmain` (`view_name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table ambari.viewinstancedata
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`viewinstancedata` (
  `view_instance_id` BIGINT NOT NULL COMMENT '',
  `view_name` VARCHAR(255) NOT NULL COMMENT '',
  `view_instance_name` VARCHAR(255) NOT NULL COMMENT '',
  `name` VARCHAR(255) NOT NULL COMMENT '',
  `user_name` VARCHAR(255) NOT NULL COMMENT '',
  `value` VARCHAR(2000) NULL COMMENT '',
  PRIMARY KEY (`view_instance_id`, `name`, `user_name`)  ,
  CONSTRAINT `fk_viewinstdata_view_name`
    FOREIGN KEY (`view_instance_id` , `view_name` , `view_instance_name`)
    REFERENCES `ambari`.`viewinstance` (`view_instance_id` , `view_name` , `name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table ambari.viewinstanceproperty
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`viewinstanceproperty` (
  `view_name` VARCHAR(255) NOT NULL COMMENT '',
  `view_instance_name` VARCHAR(255) NOT NULL COMMENT '',
  `name` VARCHAR(255) NOT NULL COMMENT '',
  `value` VARCHAR(2000) NULL COMMENT '',
  PRIMARY KEY (`view_name`, `view_instance_name`, `name`),
  CONSTRAINT `fk_viewinstprop_view_name`
    FOREIGN KEY (`view_name` , `view_instance_name`)
    REFERENCES `ambari`.`viewinstance` (`view_name` , `name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table ambari.viewmain
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`viewmain` (
  `view_name` VARCHAR(255) NOT NULL COMMENT '',
  `label` VARCHAR(255) NULL COMMENT '',
  `description` VARCHAR(2048) NULL COMMENT '',
  `version` VARCHAR(255) NULL COMMENT '',
  `resource_type_id` INT NOT NULL COMMENT '',
  `icon` VARCHAR(255) NULL COMMENT '',
  `icon64` VARCHAR(255) NULL COMMENT '',
  `archive` VARCHAR(255) NULL COMMENT '',
  `mask` VARCHAR(255) NULL COMMENT '',
  `system_view` SMALLINT NOT NULL DEFAULT 0 COMMENT '',
  PRIMARY KEY (`view_name`),
  CONSTRAINT `fk_view_resource_type_id`
    FOREIGN KEY (`resource_type_id`)
    REFERENCES `ambari`.`adminresourcetype` (`resource_type_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table ambari.viewparameter
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`viewparameter` (
  `view_name` VARCHAR(255) NOT NULL COMMENT '',
  `name` VARCHAR(255) NOT NULL COMMENT '',
  `description` VARCHAR(2048) NULL COMMENT '',
  `label` VARCHAR(255) NULL COMMENT '',
  `placeholder` VARCHAR(255) NULL COMMENT '',
  `default_value` VARCHAR(2000) NULL COMMENT '',
  `required` CHAR(1) NULL COMMENT '',
  `masked` CHAR(1) NULL COMMENT '',
  PRIMARY KEY (`view_name`, `name`)  ,
  CONSTRAINT `fk_viewparam_view_name`
    FOREIGN KEY (`view_name`)
    REFERENCES `ambari`.`viewmain` (`view_name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table ambari.viewresource
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ambari`.`viewresource` (
  `view_name` VARCHAR(255) NOT NULL COMMENT '',
  `name` VARCHAR(255) NOT NULL COMMENT '',
  `plural_name` VARCHAR(255) NULL COMMENT '',
  `id_property` VARCHAR(255) NULL COMMENT '',
  `subresource_names` VARCHAR(255) NULL COMMENT '',
  `provider` VARCHAR(255) NULL COMMENT '',
  `service` VARCHAR(255) NULL COMMENT '',
  `resource` VARCHAR(255) NULL COMMENT '',
  PRIMARY KEY (`view_name`, `name`) ,
  CONSTRAINT `fk_viewres_view_name`
    FOREIGN KEY (`view_name`)
    REFERENCES `ambari`.`viewmain` (`view_name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
SET FOREIGN_KEY_CHECKS = 1;
