USE server_accounts;

DROP TABLE IF EXISTS `USR_VCARD`;
CREATE TABLE `USR_VCARD` (
  `ACCOUNT_NO` int(11) NOT NULL AUTO_INCREMENT,
  `DEVICE_ID` int(11) DEFAULT NULL,
  `PARENT_NO` bigint(11) DEFAULT NULL,
  `REG_TIME` datetime DEFAULT NULL,
  `REG_TYPE` int(2) DEFAULT '0',
  `FULLNAME` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `NICKNAME` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `SEX` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TEL` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `SINA_NO` varchar(41) COLLATE utf8_unicode_ci DEFAULT '',
  `QQ_NO` varchar(36) COLLATE utf8_unicode_ci DEFAULT '0',
  `EMAIL` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `BIRTHDAY` date DEFAULT NULL,
  `PHOTO_SN` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL,
  `REMARK` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CREATED_DATE` datetime DEFAULT NULL,
  `CREATED_BY` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `MODIFIED_DATE` datetime DEFAULT NULL,
  `MODIFIED_BY` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `PACKAGE_ID` int(11) DEFAULT NULL,
  `TVDEV_ID` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `VALID_CODE` int(6) DEFAULT '0',
  `PUB_KEY` varchar(200) COLLATE utf8_unicode_ci DEFAULT '',
  PRIMARY KEY (`ACCOUNT_NO`),
  KEY `IX_PARENT_NO` (`PARENT_NO`)
) ENGINE=MyISAM AUTO_INCREMENT=1506757 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

#用户表
DROP TABLE IF EXISTS `USERS`;
CREATE TABLE `USERS` (
  `DEVICE_SN` varchar(50) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '设备SN',
  `ACCOUNT_NO` int(11) NOT NULL DEFAULT '100000' COMMENT 'token解析出来的账号',
  `DEVICE_CLASS` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '设备类型',
  `ACCOUNTNAME` varchar(128) COLLATE utf8_unicode_ci DEFAULT '游客_' COMMENT '昵称',
  `ACCOUNTICON_URL` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '小头像的URL地址',
  `GENDER` int(11) DEFAULT '0' COMMENT '性别',
  `PHONE` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '电话号码',
  `ADDRESS` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '地址',
  `CREATED_BY` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '创建者',
  `CREATED_DATE` datetime DEFAULT NULL COMMENT '创建时间',
  `MODIFIED_BY` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '修改者',
  `MODIFIED_DATE` datetime DEFAULT NULL COMMENT '修改时间',
  `PERMISSION` int(11) DEFAULT '0' COMMENT '权限,0表示一般用户，1表示运营管理用户',
  `BIRTHDAY` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '生日',
  `COVERIMG` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '封面背景图片',
  PRIMARY KEY (`DEVICE_SN`),
  UNIQUE KEY `idx_users_accountname` (`ACCOUNTNAME`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
#alter table server_accounts.USERS modify column `ACCOUNTICON_URL` varchar(300) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '小头像的URL地址'
#alter table server_accounts.USERS add column `COVERIMG` varchar(300) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '封面背景图片'
#alter table server_accounts.USERS add column `DEVICE_CLASS` varchar(50) COLLATE utf8_unicode_ci DEFAULT 'I7' COMMENT '设备类型';
#alter table server_accounts.USERS drop column DEVICE_CLASS;