/*
SQLyog Ultimate v12.3.2 (64 bit)
MySQL - 5.7.18-log : Database - mekico_saas
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`mekico_saas` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `mekico_saas`;

/*Table structure for table `resource` */

DROP TABLE IF EXISTS `resource`;

CREATE TABLE `resource` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '资源ID',
  `parent_id` int(11) NOT NULL DEFAULT '0' COMMENT '上级资源ID，0为顶级',
  `resource_name` varchar(50) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '权限名称',
  `resource_type` tinyint(1) DEFAULT '1' COMMENT '资源类型，1:URL地址;2:按钮;',
  `resource_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT '' COMMENT 'url地址',
  `resource_method` enum('GET','POST','PUT','HEAD','DELETE','OPTIONS','TRACE','CONNECT') COLLATE utf8_unicode_ci DEFAULT 'GET' COMMENT 'url上发生的方法',
  `resource_icon` varbinary(255) DEFAULT '' COMMENT 'icon图标',
  `sort_level` int(1) NOT NULL DEFAULT '999' COMMENT '排序，越小越前',
  `is_show` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否显示，0:隐藏，1:显示',
  `status` tinyint(1) DEFAULT '1' COMMENT '有效状态，1:有效;0:禁用',
  `create_user_id` int(11) DEFAULT NULL COMMENT '创建账号ID',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `change_last_user_id` datetime DEFAULT NULL COMMENT '最后修改账号ID',
  `change_last_time` datetime DEFAULT NULL COMMENT '最后修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='资源信息';

/*Table structure for table `tenant` */

DROP TABLE IF EXISTS `tenant`;

CREATE TABLE `tenant` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '租户编号',
  `tenant_name` varchar(20) DEFAULT NULL COMMENT '租户名',
  `status` tinyint(1) DEFAULT '1' COMMENT '租户有效状态，1:有效;2:禁用',
  `create_user_id` int(11) DEFAULT NULL COMMENT '创建账号ID',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `change_last_user_id` datetime DEFAULT NULL COMMENT '最后修改账号ID',
  `change_last_time` datetime DEFAULT NULL COMMENT '最后修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_tenant_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='租户信息';

/*Table structure for table `tenant_role` */

DROP TABLE IF EXISTS `tenant_role`;

CREATE TABLE `tenant_role` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `tenant_id` int(11) DEFAULT NULL COMMENT '租户',
  `role_name` varchar(32) NOT NULL DEFAULT '0' COMMENT '角色名称',
  `remark` varchar(255) NOT NULL DEFAULT '0' COMMENT '备注',
  `status` tinyint(1) DEFAULT '1' COMMENT '有效状态，1:有效;0:禁用',
  `create_user_id` int(11) DEFAULT NULL COMMENT '创建账号ID',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `change_last_user_id` datetime DEFAULT NULL COMMENT '最后修改账号ID',
  `change_last_time` datetime DEFAULT NULL COMMENT '最后修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='角色表';

/*Table structure for table `tenant_role_resource` */

DROP TABLE IF EXISTS `tenant_role_resource`;

CREATE TABLE `tenant_role_resource` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `tenant_role_id` int(11) DEFAULT NULL,
  `tenant_resource_id` int(11) DEFAULT NULL,
  `create_user_id` int(11) DEFAULT NULL COMMENT '创建账号ID',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `change_last_user_id` datetime DEFAULT NULL COMMENT '最后修改账号ID',
  `change_last_time` datetime DEFAULT NULL COMMENT '最后修改时间',
  PRIMARY KEY (`id`),
  KEY `pk_trr_tenant_role_id` (`tenant_role_id`),
  KEY `pk_trr_resource_id` (`tenant_resource_id`),
  CONSTRAINT `pk_trr_resource_id` FOREIGN KEY (`tenant_resource_id`) REFERENCES `resource` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `pk_trr_tenant_role_id` FOREIGN KEY (`tenant_role_id`) REFERENCES `tenant_role` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `tenant_user` */

DROP TABLE IF EXISTS `tenant_user`;

CREATE TABLE `tenant_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '租户下用用户ID',
  `tenant_id` int(11) DEFAULT NULL COMMENT '租户',
  `user_phone` varchar(20) DEFAULT NULL COMMENT '租户下用用户手机号，登录',
  `user_authentication` varchar(50) DEFAULT NULL COMMENT '租户下用用户密码',
  `user_authentication _salt` varchar(32) DEFAULT NULL COMMENT '租户下用用户密码盐',
  `user_name` varchar(20) DEFAULT NULL COMMENT '租户下用用户名字',
  `avatar` varchar(100) DEFAULT NULL COMMENT '租户下用用户头像',
  `is_system_user` tinyint(1) DEFAULT '0' COMMENT '是否系统级账号，1:是;2:普通',
  `status` tinyint(1) DEFAULT '1' COMMENT '租户下用用户有效状态，1:有效;0:禁用',
  `last_login_time` datetime DEFAULT NULL COMMENT '最后登录时间',
  `create_user_id` int(11) DEFAULT NULL COMMENT '创建账号ID',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `change_last_user_id` datetime DEFAULT NULL COMMENT '最后修改账号ID',
  `change_last_time` datetime DEFAULT NULL COMMENT '最后修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_admin_user_phone` (`user_phone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='租户下的账号';

/*Table structure for table `tenant_user_role` */

DROP TABLE IF EXISTS `tenant_user_role`;

CREATE TABLE `tenant_user_role` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `tenant_id` int(11) DEFAULT NULL COMMENT '租户ID',
  `tenant_user_id` int(11) DEFAULT NULL COMMENT '租户下用户ID',
  `tenant_role_id` int(11) DEFAULT NULL COMMENT '租户下角色表ID',
  `create_user_id` int(11) DEFAULT NULL COMMENT '创建账号ID',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `change_last_user_id` datetime DEFAULT NULL COMMENT '最后修改账号ID',
  `change_last_time` datetime DEFAULT NULL COMMENT '最后修改时间',
  PRIMARY KEY (`id`),
  KEY `pk_tur_tenant_role_id` (`tenant_role_id`),
  KEY `pk_tur_tenant_user_id` (`tenant_user_id`),
  CONSTRAINT `pk_tur_tenant_role_id` FOREIGN KEY (`tenant_role_id`) REFERENCES `tenant_role` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `pk_tur_tenant_user_id` FOREIGN KEY (`tenant_user_id`) REFERENCES `tenant_user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='租户用户和角色表关系';

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
