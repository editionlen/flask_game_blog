CREATE database server_games;

use server_games;

CREATE TABLE `GCS_PLAY_LOG_NEW` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `MUCH_PLATFORM` varchar(32) NOT NULL DEFAULT 'much',
  `ACCOUNT_NO` int(11) NOT NULL,
  `NICKNAME` varchar(32) DEFAULT NULL,
  `PHOTO_SN` varchar(256) DEFAULT NULL,
  `BEGINTIME` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `ENDTIME` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `APP_PACKAGE` varchar(100) NOT NULL,
  `DESCRIPTION` varchar(200) DEFAULT NULL,
  `REC_TIME` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `APP_NAME` varchar(100) DEFAULT NULL,
  `DEVICE_SN` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `idx_app_package` (`APP_PACKAGE`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `GCS_PLAY_LOG_TVCMS` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `MUCH_PLATFORM` varchar(32) NOT NULL DEFAULT 'much',
  `ACCOUNT_NO` int(11) NOT NULL,
  `NICKNAME` varchar(32) DEFAULT NULL,
  `PHOTO_SN` varchar(256) DEFAULT NULL,
  `BEGINTIME` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `ENDTIME` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `APP_PACKAGE` varchar(100) NOT NULL,
  `DESCRIPTION` varchar(200) DEFAULT NULL,
  `REC_TIME` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `APP_NAME` varchar(100) DEFAULT NULL,
  `DEVICE_SN` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `idx_app_package` (`APP_PACKAGE`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

CREATE TABLE `GCS_PLAY_INSTALL_LOG` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `ACCOUNT_NO` int(11) NOT NULL,
  `NICKNAME` varchar(32) DEFAULT NULL,
  `DEVICE_SN` varchar(128) DEFAULT NULL,
  `DEVICE_TYPE` varchar(128) DEFAULT NULL,
  `DEVICE_VER` varchar(128) DEFAULT NULL,
  `APP_NAME` varchar(100) DEFAULT NULL,
  `APP_PACKAGE` varchar(100) NOT NULL,
  `VERSION_CODE` varchar(32) DEFAULT NULL,
  `ICON_URL` varchar(100) DEFAULT NULL,
  `REC_TIME` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`ID`),
  KEY `idx_play_install` (`DEVICE_SN`,`APP_PACKAGE`) USING BTREE,
  KEY `idx_ins_sn` (`DEVICE_SN`) USING HASH,
  KEY `idx_ins_name` (`APP_NAME`) USING HASH
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
#alter table `GCS_PLAY_INSTALL_LOG` drop index `idx_ins_sn`;
#alter table `GCS_PLAY_INSTALL_LOG` ADD INDEX `idx_ins_sn` (`DEVICE_SN`) USING HASH;
#alter table `GCS_PLAY_INSTALL_LOG` drop index `idx_ins_name`;
#alter table `GCS_PLAY_INSTALL_LOG` ADD INDEX `idx_ins_name` (`APP_NAME`) USING HASH;
alter table `GCS_PLAY_INSTALL_LOG` add KEY `idx_pkg_install` (`APP_PACKAGE`) USING BTREE;

CREATE TABLE `GCS_PLAY_USETIME_LOG` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `ACCOUNT_NO` int(11) NOT NULL,
  `NICKNAME` varchar(32) DEFAULT NULL,
  `DEVICE_SN` varchar(128) DEFAULT NULL,
  `DEVICE_TYPE` varchar(128) DEFAULT NULL,
  `DEVICE_VER` varchar(128) DEFAULT NULL,
  `APP_NAME` varchar(100) DEFAULT NULL,
  `APP_PACKAGE` varchar(100) NOT NULL,
  `VERSION_CODE` varchar(32) DEFAULT NULL,
  `USETIME` bigint(11) DEFAULT '0',
  `REC_TIME` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`ID`),
  KEY `idx_play_usetime` (`DEVICE_SN`,`APP_PACKAGE`) USING BTREE,
  KEY `idx_play_sn` (`DEVICE_SN`) USING HASH,
  KEY `idx_play_name` (`APP_NAME`) USING HASH,
  KEY `idx_play_rectime` (`REC_TIME`) USING HASH
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
#alter table `GCS_PLAY_USETIME_LOG` drop KEY `idx_play_sn`;
#alter table `GCS_PLAY_USETIME_LOG` ADD KEY `idx_play_sn` (`DEVICE_SN`) USING HASH;
#alter table `GCS_PLAY_USETIME_LOG` drop KEY `idx_play_name`;
#alter table `GCS_PLAY_USETIME_LOG` ADD KEY `idx_play_name` (`APP_NAME`) USING HASH;
#alter table `GCS_PLAY_USETIME_LOG` modify column `USETIME` bigint(11) DEFAULT 0;
alter table `GCS_PLAY_USETIME_LOG` ADD KEY `idx_play_rectime` (`REC_TIME`) USING HASH;

#系统表 begin
#排行榜标签显示内容
DROP TABLE IF EXISTS `STAT_RANK_TABS`;
CREATE TABLE `STAT_RANK_TABS` (
  `NO` int(7) NOT NULL COMMENT '标签的ID',
  `TAB_NAME` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '标签的名字',
  PRIMARY KEY (`NO`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
#ALTER TABLE `STAT_RANK_TABS` ENGINE = MyISAM;

#需要过滤掉的安装应用
DROP TABLE IF EXISTS `STAT_PLAY_IGNORE`;
CREATE TABLE `STAT_PLAY_IGNORE` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `APP_NAME` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '统计过程中需要被忽略的游戏名称' ,
  PRIMARY KEY (`ID`),
  UNIQUE  KEY `idx_ignore_name` (`APP_NAME`) USING HASH
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
#ALTER TABLE `STAT_PLAY_IGNORE` ENGINE = MyISAM;

#游戏名称对应的类别ID
DROP TABLE IF EXISTS `STAT_GAME2CLASS`;
CREATE TABLE `STAT_GAME2CLASS` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `APP_NAME` varchar(200) DEFAULT NULL,
  `GAME_URL` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL  COMMENT '游戏下载地址',
  `ICON_URL` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL  COMMENT '游戏图标地址',
  `APP_CLASS_ID` int(11) DEFAULT 0 COMMENT '游戏归属类别',
  PRIMARY KEY (`ID`),
  KEY `idx_class_name` (`APP_NAME`) USING HASH,
  KEY `idx_class_class` (`APP_CLASS_ID`) USING BTREE,
  UNIQUE KEY `idx_name_classid` (`APP_NAME`,`APP_CLASS_ID`) USING HASH,
  FULLTEXT KEY `idx_class_name_full` (`APP_NAME`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
alter table STAT_GAME2CLASS add column `PUBLISH_TIME` datetime DEFAULT NULL;


#ALTER TABLE `STAT_GAME2CLASS` ENGINE = MyISAM;
#ALTER TABLE STAT_GAME2CLASS ADD FULLTEXT INDEX `idx_class_name_full` (`APP_NAME`);

#全文模糊搜索游戏
select * from STAT_GAME2CLASS where MATCH (APP_NAME) AGAINST('*天*' IN BOOLEAN MODE)\G
#alter table `STAT_GAME2CLASS` drop index `idx_class_name`;
#alter table `STAT_GAME2CLASS` drop index `idx_class_class`;
#alter table `STAT_GAME2CLASS` ADD INDEX `idx_class_name` (`APP_NAME`) USING HASH;
#alter table `STAT_GAME2CLASS` ADD INDEX `idx_class_class` (`APP_CLASS_ID`) USING HASH;
#alter table `STAT_GAME2CLASS` drop index `APP_NAME`;
#新增
#alter table  STAT_GAME2CLASS drop KEY `idx_name_classid`;
#alter table  STAT_GAME2CLASS add KEY `idx_name_classid` (`APP_NAME`,`APP_CLASS_ID`) USING HASH;
#alter table STAT_GAME2CLASS change APP_NAME APP_NAME varchar(100)  CHARACTER SET utf8  COLLATE utf8_unicode_ci COMMENT '游戏名称';
#alter table STAT_GAME2CLASS change APP_NAME APP_NAME varchar(100) NOT NULL COMMENT '游戏名称'


#游戏类别ID对应的类别名称
DROP TABLE IF EXISTS `STAT_CLASS_ID`;
CREATE TABLE `STAT_CLASS_ID` (
  `APP_CLASS_ID` int(11) NOT NULL COMMENT '游戏类别ID',
  `CLASS_NAME` varchar(20) NOT NULL COMMENT '类别名称',
  `TYPE_URL` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL  COMMENT '游戏分类图标',
  PRIMARY KEY (`APP_CLASS_ID`),
  UNIQUE  KEY `idx_classid_name` (`CLASS_NAME`) USING HASH
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
ALTER TABLE `STAT_CLASS_ID` ENGINE = MyISAM;
#alter table `STAT_CLASS_ID` add column `TYPE_URL` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL  COMMENT '游戏分类图标';

#游戏大类表
DROP TABLE IF EXISTS `STAT_REGION`;
CREATE TABLE `STAT_REGION` (
  `REGION_ID` int(11) NOT NULL COMMENT '大类别ID',
  `REGION_NAME` varchar(20) NOT NULL COMMENT '大类别名称',
  `REGION_URL` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL  COMMENT '大类别图标',
  PRIMARY KEY (`REGION_ID`),
  UNIQUE  KEY `idx_regionid_name` (`REGION_NAME`) USING HASH
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
ALTER TABLE `STAT_REGION` ENGINE = MyISAM;

#游戏大类和小类的对应关系
DROP TABLE IF EXISTS `STAT_REGION2CLASS`;
CREATE TABLE `STAT_REGION2CLASS` (
  `REGION_ID` int(11) NOT NULL COMMENT '大类别ID',
  `APP_CLASS_ID` int(11) NOT NULL COMMENT '游戏小类别ID',
  KEY `idx_regionid` (`REGION_ID`) USING HASH,
  KEY `idx_regionid_classid` (`APP_CLASS_ID`) USING HASH
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
ALTER TABLE `STAT_REGION2CLASS` ENGINE = MyISAM;

#系统表 end


#推荐1给用户-按下载次数
DROP TABLE IF EXISTS `STAT_ADVISE_GAME_NUM`;
CREATE TABLE `STAT_ADVISE_GAME_NUM` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `STATDAY` varchar(20) NOT NULL COMMENT '统计日期YYYYMMDD格式',
  `DEVICE_SN` varchar(128) NOT NULL COMMENT '被统计的用户',
  `APP_NAME` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '被推荐游戏名称',
  `APP_INS_NUM` int(11) NOT NULL COMMENT '被推荐游戏被下载次数',
  PRIMARY KEY (`ID`),
  KEY `idx_adv_num_day` (`STATDAY`) USING HASH,
  KEY `idx_adv_num_sn` (`DEVICE_SN`,`STATDAY`) USING HASH
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
alter table  STAT_ADVISE_GAME_NUM drop column ID;
alter table  STAT_ADVISE_GAME_NUM add PRIMARY KEY (`STATDAY`, `DEVICE_SN`, `APP_NAME`);

#推荐2给用户-按平均使用时长
DROP TABLE IF EXISTS `STAT_ADVISE_GAME_TIME`;
CREATE TABLE `STAT_ADVISE_GAME_TIME` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `STATDAY` varchar(20) NOT NULL NOT NULL COMMENT '统计日期YYYYMMDD格式',
  `DEVICE_SN` varchar(128) DEFAULT NULL COMMENT '被统计的用户',
  `APP_NAME` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '被推荐游戏名称',
   `APP_USE_SUMTIME` bigint(11) DEFAULT '0' COMMENT '被推荐游戏平均使用时长',
  PRIMARY KEY (`ID`),
  KEY `idx_adv_time_day` (`STATDAY`) USING HASH,
  KEY `idx_adv_time_sn` (`DEVICE_SN`,`STATDAY`) USING HASH
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
alter table  STAT_ADVISE_GAME_TIME drop column ID;
alter table  STAT_ADVISE_GAME_TIME add PRIMARY KEY (`STATDAY`, `DEVICE_SN`, `APP_NAME`);

#排行榜1：黑马榜：相比上周使用人数新进入到TOP50
DROP TABLE STAT_RANK_LST1;
CREATE TABLE `STAT_RANK_LST1` (
  `WEEKNUM` int(7) NOT NULL COMMENT '记录属于第几周 格式 YYYYWW',
  `APP_NAME` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '被推荐游戏名称',
  `USETOTAL` int(11) DEFAULT '0' COMMENT '玩耍此游戏的人数',
  KEY `idx_horse_week` (`WEEKNUM`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


#排行榜2：冷门榜：使用的用户少，但使用时长高
DROP TABLE IF EXISTS `STAT_RANK_LST2`;
CREATE TABLE `STAT_RANK_LST2` (
  `WEEKNUM` int(7) NOT NULL COMMENT '记录属于第几周 格式 YYYYWW',
  `APP_NAME` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '被推荐游戏名称',
  `TIMETOTAL` bigint(11) DEFAULT '0' COMMENT '此游戏被玩耍总时长',
  `USERTOTAL` int(11) DEFAULT '0' COMMENT '玩耍此游戏的总人数',
  `DEVICE_SN` varchar(128) NOT NULL COMMENT '设备SN号',
  KEY `idx_list2_week` (`WEEKNUM`) USING HASH,
  KEY `idx_list2_week_sn` (`DEVICE_SN`, `WEEKNUM`) USING HASH
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#排行榜3：爆肝榜：使用的用户少，但平均使用时长高
DROP TABLE IF EXISTS `STAT_RANK_LST3`;
CREATE TABLE `STAT_RANK_LST3` (
  `WEEKNUM` int(7) NOT NULL COMMENT '记录属于第几周 格式 YYYYWW',
  `APP_NAME` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '被推荐游戏名称',
  `AVRTIME` int(11) DEFAULT '0' COMMENT '用户平均玩耍时长',
  `DEVICE_SN` varchar(128) NOT NULL COMMENT '设备SN号',
  KEY `idx_list3_week` (`WEEKNUM`) USING HASH,
  KEY `idx_list3_week_sn` (`DEVICE_SN`, `WEEKNUM`) USING HASH
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


#热词搜索次数 
DROP TABLE IF EXISTS `HOT_WORDS`;
CREATE TABLE `HOT_WORDS` (
  `HOT_WORD` varchar(200) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '热词',
  `SEARCH_COUNT` bigint(11) DEFAULT '1' COMMENT '热词搜索次数',
  PRIMARY KEY (`HOT_WORD`),
  KEY `idx_search_count` (`SEARCH_COUNT`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
#第一次上线手动插入的热词
insert into HOT_WORDS(HOT_WORD) values('王者荣耀'),('血族'),('龙之谷'),('荒野行动'),('光荣使命'),('崩坏3'),('王牌机战'),('穿越火线：枪战王者'),('超级玛丽'),('九阴');

#当天热词表
DROP TABLE IF EXISTS `STAT_HOT_WORDS`;
CREATE TABLE `STAT_HOT_WORDS` (
  `STATDAY` varchar(20) NOT NULL COMMENT '统计日期YYYYMMDD格式',
  `HOT_WORD` varchar(100) NOT NULL DEFAULT '',
  `SEARCH_COUNT` bigint(11) DEFAULT '1' COMMENT '热词搜索次数',  
  PRIMARY KEY (`STATDAY`,`HOT_WORD`),
  KEY `idx_hot_words_statday` (`STATDAY`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
#第一次上线手动插入的热词
insert into STAT_HOT_WORDS(STATDAY,HOT_WORD,SEARCH_COUNT) select '20171221',HOT_WORD,SEARCH_COUNT from HOT_WORDS order by SEARCH_COUNT desc limit 30;

#桌面广告栏显示的游戏
DROP TABLE IF EXISTS `BANNER_GAME_INFO`;
CREATE TABLE `BANNER_GAME_INFO` (
  `APP_NAME` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '桌面广告栏显示的游戏名称',
  `GAME_URL` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '游戏下载地址',
  `ICON_URL` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '游戏图标地址',
  `CPIC_URL` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '游戏LOGO图片地址',
  PRIMARY KEY (`APP_NAME`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
#插入固定的显示游戏信息
insert into BANNER_GAME_INFO(APP_NAME,GAME_URL,ICON_URL,CPIC_URL) select APP_NAME,GAME_URL,ICON_URL,'http://58.211.140.43:8000/com.netease.my.uc.logo.jpg' from STAT_GAME2CLASS where APP_NAME='梦幻西游' limit 1;
insert into BANNER_GAME_INFO(APP_NAME,GAME_URL,ICON_URL,CPIC_URL) select APP_NAME,GAME_URL,ICON_URL,'http://58.211.140.43:8000/com.sdg.woool.xuezu.dangle.logo.jpg' from STAT_GAME2CLASS where APP_NAME='血族' limit 1;
insert into BANNER_GAME_INFO(APP_NAME,GAME_URL,ICON_URL,CPIC_URL) select APP_NAME,GAME_URL,ICON_URL,'http://58.211.140.43:8000/com.tencent.tmgp.hyxddjly.logo.jpg' from STAT_GAME2CLASS where APP_NAME='荒野行动' limit 1;

#桌面显示的类别LOGO表
DROP TABLE IF EXISTS `CATEGORY_BANNER`;
CREATE TABLE `CATEGORY_BANNER` (
  `REGION_ID` int(11) NOT NULL COMMENT '大类别ID',
  `REGION_NAME` varchar(20) NOT NULL COMMENT '大类别名称',
  `CPIC_URL` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL  COMMENT '大类别LOGO',
  `CPOSITION` int(11) NOT NULL COMMENT '在桌面的位置',
  PRIMARY KEY (`REGION_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
#插入固定类别
insert into CATEGORY_BANNER(REGION_ID,REGION_NAME,CPIC_URL,CPOSITION) select REGION_ID,REGION_NAME,'http://58.211.140.43:8000/region.keymapping.logo.jpg',1 as position from STAT_REGION where REGION_ID=1;
insert into CATEGORY_BANNER(REGION_ID,REGION_NAME,CPIC_URL,CPOSITION) select REGION_ID,REGION_NAME,'http://58.211.140.43:8000/region.leisure.logo.jpg',2 as position from STAT_REGION where REGION_ID=5;


#查询方式 
#DROP View IF EXISTS `V_MESSAGELIST`;
#CREATE OR REPLACE ALGORITHM=UNDEFINED  VIEW `V_MESSAGELIST` 
# AS select `MESSAGELIST`.`MSGKEY` AS `MSGKEY` from `MESSAGELIST` order by `MESSAGELIST`.`MSGKEY` ASC;

DROP TABLE IF EXISTS `MSGKEYVAL`;
CREATE TABLE `MSGKEYVAL` (
  `MSGKEY` bigint(20) unsigned NOT NULL COMMENT '上层消息ID',
  `MSGVALUE` bigint(20) unsigned DEFAULT '0' COMMENT '本层消息的最后一个ID',
  PRIMARY KEY (`MSGKEY`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
#帖子记录表 改
DROP TABLE IF EXISTS `MESSAGELIST`;
CREATE TABLE `MESSAGELIST` (
  `MSGKEY` bigint(20) unsigned NOT NULL COMMENT '消息的唯一记录,帖子的ID号',
  `LEVEL1ID` int(11) unsigned DEFAULT '0' COMMENT '消息一级ID',
  `LEVEL2ID` int(11) unsigned DEFAULT '0' COMMENT '消息二级ID',
  `LEVEL3ID` int(11) unsigned DEFAULT '0' COMMENT '消息三级ID',
  `TITLE` varchar(512) COLLATE utf8mb4_bin NOT NULL COMMENT '话题标题',
  `MASSAGE` mediumtext COLLATE utf8mb4_bin COMMENT '话题文本正文',
  `DEVICE_SN` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '设备SN',
  `REPLY_NAME` varchar(128) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '对方的昵称',
  `ADMIRECOUNT` int(11) DEFAULT '0' COMMENT '点赞数',
  `VISCOUNT` int(11) DEFAULT '0' COMMENT '浏览数',
  `COMPLAINNUM` int(11) DEFAULT '0' COMMENT '投诉数',
  `PICNUM` int(11) DEFAULT '0' COMMENT '图片数',
  `HASADAPTER` tinyint(1) DEFAULT '0' COMMENT '是否有映射方案',
  `ADAPTER_HASHCODE` int(11) DEFAULT '0',
  `HASGAME` tinyint(1) DEFAULT '0' COMMENT '是否有关联游戏',
  `APP_NAME` varchar(200) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '游戏名称',
  `CREATED_DATE` datetime DEFAULT NULL COMMENT '创建时间',
  `MODIFIED_DATE` datetime DEFAULT NULL COMMENT '修改时间',
  `REPLYNUM` int(11) DEFAULT '0' COMMENT '回帖数',
  `REPLYKEY` bigint(20) unsigned DEFAULT NULL COMMENT '回复了哪个帖子ID',
  `TOP_DATE` datetime DEFAULT NULL COMMENT '置顶时间',
  `REPLY_SN` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '回复人的设备SN',
  `PRI_ORI_SN` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT '' COMMENT '私信原始发起人的SN',
  `PRI_DES_SN` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT '' COMMENT '私信原始接收人的SN',
  `ISREAD` tinyint(1) DEFAULT '0' COMMENT '是否已读,0 未读，1已读',
  PRIMARY KEY (`MSGKEY`) USING BTREE,
  KEY `idx_messagelist_sn` (`DEVICE_SN`) USING BTREE,
  KEY `idx_levelx` (`LEVEL1ID`,`LEVEL2ID`,`LEVEL3ID`) USING BTREE,
  KEY `idx_createdate` (`CREATED_DATE`) USING BTREE,
  KEY `idx_admirecount` (`ADMIRECOUNT`) USING BTREE,
  KEY `idx_viscount` (`VISCOUNT`) USING BTREE,
  KEY `idx_replykey` (`REPLYKEY`) USING BTREE,
  KEY `idx_topdate` (`TOP_DATE`) USING BTREE,
  KEY `idx_messagelist_replysn` (`REPLY_SN`) USING BTREE,
  KEY `idx_messagelist_pri` (`PRI_ORI_SN`,`PRI_DES_SN`) USING BTREE,
  KEY `idx_messagelist_priorisn` (`PRI_ORI_SN`) USING BTREE,
  KEY `idx_messagelist_pridessn` (`PRI_DES_SN`) USING BTREE,
  KEY `idx_messagelist_read` (`ISREAD`) USING BTREE,
  KEY `idx_appname` (`APP_NAME`) USING BTREE,
  FULLTEXT KEY `idx_massage_full` (`MASSAGE`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
#alter table MESSAGELIST add column `CATEGORY_ID` int(11) DEFAULT '0';

DROP TABLE IF EXISTS `MESSAGEPIC`;#消息图片表
CREATE TABLE `MESSAGEPIC` (
  `MSGKEY` bigint(20) unsigned NOT NULL COMMENT '消息ID',
  `PIC1` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `PIC2` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `PIC3` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `PIC4` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `PIC5` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `PIC6` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `PIC7` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `PIC8` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `PIC9` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `PIC10` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `PIC11` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `PIC12` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `PIC13` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `PIC14` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `PIC15` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `PIC16` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `PIC17` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `PIC18` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `PIC19` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `PIC20` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `PIC21` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `PIC22` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `PIC23` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `PIC24` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `PIC25` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `PIC26` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `PIC27` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `PIC28` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `PIC29` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `PIC30` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `PIC31` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `PIC32` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `PIC33` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `PIC34` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `PIC35` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `PIC36` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `PIC37` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `PIC38` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `PIC39` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `PIC40` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `PIC41` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `PIC42` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `PIC43` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `PIC44` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `PIC45` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `PIC46` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `PIC47` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `PIC48` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `PIC49` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `PIC50` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`MSGKEY`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 comment='消息图片表';

#用户点赞记录表
DROP TABLE IF EXISTS `USER_ADMIRE`;
CREATE TABLE `USER_ADMIRE` (  
  `DEVICE_SN` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '设备SN', 
  `MSGKEY` bigint(20) unsigned NOT NULL COMMENT '被点赞的ID',
  `CREATED_DATE` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`DEVICE_SN`,`MSGKEY`) USING BTREE,
  KEY `idx_msgadmire_sn` (`DEVICE_SN`) USING BTREE,
  KEY `idx_msgadmire_msgkey` (`MSGKEY`) USING BTREE,
  KEY `idx_admire_createdate` (`CREATED_DATE`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 comment='用户点赞记录表';
#alter table `USER_ADMIRE` add KEY `idx_admire_createdate` (`CREATED_DATE`) USING BTREE

#用户关注UP列表
DROP TABLE IF EXISTS `USER_UPLIST`;
CREATE TABLE `USER_UPLIST` (
  `DEVICE_SN` varchar(50) COLLATE utf8_unicode_ci NOT NULL COMMENT '主动关注方SN', 
  `UP_SN` varchar(50) COLLATE utf8_unicode_ci NOT NULL COMMENT '被关注方SN',
  `CREATED_DATE` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`DEVICE_SN`, `UP_SN`) USING BTREE,
  KEY `idx_up_devsn` (`DEVICE_SN`) USING HASH,
  KEY `idx_up_upsn` (`UP_SN`) USING HASH
) ENGINE=InnoDB DEFAULT CHARSET=utf8 comment='用户关注UP列表';

#用户收藏列表
DROP TABLE IF EXISTS `USER_ATTENTION`;
CREATE TABLE `USER_ATTENTION` (
  `DEVICE_SN` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '设备SN', 
  `MSGKEY` bigint(20) unsigned NOT NULL COMMENT '被收藏的ID',
  `CREATED_DATE` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`DEVICE_SN`, `MSGKEY`) USING BTREE,
  KEY `idx_att_sn` (`DEVICE_SN`) USING HASH,
  KEY `idx_att_msgkey` (`MSGKEY`) USING HASH
) ENGINE=InnoDB DEFAULT CHARSET=utf8 comment='用户收藏列表';

#用户投诉列表
DROP TABLE IF EXISTS `USER_COMPLAINT`;
CREATE TABLE `USER_COMPLAINT` (
  `DEVICE_SN` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '设备SN', 
  `MSGKEY` bigint(20) unsigned NOT NULL COMMENT '被投诉的ID',
  `COMPLAINT_WEIGHT` int(11) DEFAULT '0' COMMENT '投诉权重分数',
  `CREATED_DATE` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`DEVICE_SN`, `MSGKEY`) USING BTREE,
  KEY `idx_complaint_sn` (`DEVICE_SN`) USING HASH,
  KEY `idx_complaint_msgkey` (`MSGKEY`) USING HASH
) ENGINE=InnoDB DEFAULT CHARSET=utf8 comment='用户投诉列表';

#按键映射方案下载次数表
DROP TABLE IF EXISTS `KEYADAPTER_COUNT`;
CREATE TABLE `KEYADAPTER_COUNT` (
  `ADAPTER_HASHCODE` int(11) DEFAULT '0' COMMENT '按键映射方案唯一标识哈希值',
  `ADAPTER_COUNT` int(11) DEFAULT '0' COMMENT '被下载次数',
  `CREATED_DATE` datetime DEFAULT NULL COMMENT '创建时间',
  `MODIFIED_DATE` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`ADAPTER_HASHCODE`) USING BTREE,
  KEY `idx_adapter_hash` (`ADAPTER_HASHCODE`) USING HASH,
  KEY `idx_adapter_count` (`ADAPTER_COUNT`) USING HASH
) ENGINE=InnoDB DEFAULT CHARSET=utf8 comment='按键映射方案下载次数表';


#删除摩奇第四期数据列表
#1
#帖子ID取值表
delete from MSGKEYVAL;
#2
#帖子记录表
delete from MESSAGELIST;
#3
#消息图片表
delete from MESSAGEPIC;
#4
#用户点赞记录表
delete from USER_ADMIRE;
#5
#用户关注UP列表
delete from USER_UPLIST;
#6
#用户收藏列表
delete from USER_ATTENTION;
#7
#用户投诉列表
delete from USER_COMPLAINT;



#第四期摩奇游戏圈协议&&遗留模块协议
#勋章列表
DROP TABLE IF EXISTS `MEDALLIST`;
CREATE TABLE `MEDALLIST` (
  `MEDALID` int(11) DEFAULT '0' COMMENT '勋章ID',
  `MEDALNAME` varchar(128) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT '勋章名称',
  `HAVE_MEDALICON` varchar(256) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '拥有勋章的图片',
  `NO_MEDALICON` varchar(256) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '没有勋章的图片',
  `DEADLINE` int(11) DEFAULT '30' COMMENT '使用期限',
  `DESCR` varchar(256) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '勋章获取渠道',
  PRIMARY KEY (`MEDALID`) USING BTREE,
  KEY `idx_medallst_name` (`MEDALNAME`) USING HASH
) ENGINE=MyISAM DEFAULT CHARSET=utf8 comment='勋章列表';

#用户获取勋章记录表 
DROP TABLE IF EXISTS `USER_MEDAL`;
CREATE TABLE `USER_MEDAL` (
  `DEVICE_SN` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '设备SN',
  `MEDALID` int(11) DEFAULT '0' COMMENT '勋章ID',
  `GET_DATE` datetime DEFAULT NULL COMMENT '获取勋章的时间',
  `OVER_DATE` datetime DEFAULT NULL COMMENT '勋章过期时间',
  `DISPLAY` tinyint(11) DEFAULT '0' COMMENT '是否在用户信息上显示,默认不显示 0',
  PRIMARY KEY (`DEVICE_SN`,`MEDALID`) USING BTREE,
  KEY `idx_usermedal_overdate` (`OVER_DATE`) USING HASH,
  KEY `idx_usermedal_display` (`DISPLAY`) USING HASH
) ENGINE=MyISAM DEFAULT CHARSET=utf8 comment='用户获取勋章记录';

#用户得分行为表
DROP TABLE IF EXISTS `USER_SCORE_LOG`;
CREATE TABLE `USER_SCORE_LOG` (
  `DEVICE_SN` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '设备SN',
  `SCORE` int(11) DEFAULT '0' COMMENT '用户得分',
  `TYPE` int(11) DEFAULT '0' COMMENT '得分类型',
  `GET_DATE` datetime DEFAULT NULL COMMENT '得分时间',
  `MSGKEY` bigint(20) unsigned NOT NULL COMMENT '在哪个帖子ID上得分',
  `ADAPTER_HASHCODE` int(11) DEFAULT '0' COMMENT '按键映射方案唯一标识哈希值',
  `LEVEL1ID` int(11) unsigned DEFAULT '0' COMMENT '消息一级ID',
  `LEVEL2ID` int(11) unsigned DEFAULT '0' COMMENT '消息二级ID',
  `LEVEL3ID` int(11) unsigned DEFAULT '0' COMMENT '消息三级ID',
  #`REPLYKEY` bigint(20) unsigned NOT NULL COMMENT '回复生成的帖子ID',
  `REPLY_SN` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '回复你帖子或点赞你帖子的设备SN',
  KEY `idx_scorelog_sn` (`DEVICE_SN`) USING BTREE,
  KEY `idx_scorelog_snkey` (`DEVICE_SN`,`MSGKEY`) USING BTREE,
  KEY `idx_scorelog_snkeytype` (`DEVICE_SN`,`MSGKEY`,`TYPE`) USING BTREE,
  KEY `idx_scorelog_levelx` (`LEVEL1ID`,`LEVEL2ID`,`LEVEL3ID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 comment='用户得分行为表';

#用户保存按键映射方案表
DROP TABLE IF EXISTS `USER_SAVEKEYADAPTER`;
CREATE TABLE `USER_SAVEKEYADAPTER` (
  `DEVICE_SN` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '设备SN',
  `MSGKEY` bigint(20) unsigned NOT NULL COMMENT '分享按键映射方案的帖子ID',
  `ADAPTER_HASHCODE` int(11) DEFAULT '0',
  `SAVE_DATE` datetime DEFAULT NULL COMMENT '保存时间',
  PRIMARY KEY (`DEVICE_SN`,`MSGKEY`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 comment='用户保存按键映射方案表';

#以下的周排行表通过脚本实现,每周一凌晨0点1分运行一次
#点赞周排行表
DROP TABLE IF EXISTS `STAT_USER_ADMIRE`;
CREATE TABLE `STAT_USER_ADMIRE` (
  `WEEKNUM` int(7) NOT NULL COMMENT '记录属于第几周 格式 YYYYWW',
  `DEVICE_SN` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '设备SN', 
  `ADMIRECOUNT` int(11) DEFAULT '0' COMMENT '本周得到的点赞数',
  KEY `idx_admire_week` (`WEEKNUM`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 comment='点赞周排行表';
#话题榜周排行表
DROP TABLE IF EXISTS `STAT_USER_TOPIC`;
CREATE TABLE `STAT_USER_TOPIC` (
  `WEEKNUM` int(7) NOT NULL COMMENT '记录属于第几周 格式 YYYYWW',
  `DEVICE_SN` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '设备SN', 
  `REPLYNUM` int(11) DEFAULT '0' COMMENT '本周得到的回帖数',
  KEY `idx_topic_week` (`WEEKNUM`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 comment='话题榜周排行表';
#按键映射被保存榜表
DROP TABLE IF EXISTS `STAT_GETKEYADAPTER`;
CREATE TABLE `STAT_GETKEYADAPTER` (
  `WEEKNUM` int(7) NOT NULL COMMENT '记录属于第几周 格式 YYYYWW',
  `DEVICE_SN` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '设备SN', 
  `ADAPTER_COUNT` int(11) DEFAULT '0' COMMENT '被下载次数',
  KEY `idx_getadapter_week` (`WEEKNUM`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 comment='按键映射被保存榜表';


#第四期遗留模块
#被回复消息列表
DROP TABLE IF EXISTS `USER_MSG_BEREPLY`;
CREATE TABLE `USER_MSG_BEREPLY` (
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `DEVICE_SN` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '设备SN',
  `MSGKEY` bigint(20) unsigned NOT NULL COMMENT '你的帖子ID',
  `REPLYKEY` bigint(20) unsigned NOT NULL COMMENT '回复你的帖子ID',
  `STATUS` int(11) DEFAULT '0' COMMENT '读取状态，0为未读，1为已读取',
  `CREATED_DATE` datetime DEFAULT NULL COMMENT '被回复的时间',
  PRIMARY KEY (`ID`) USING BTREE,
  UNIQUE KEY idx_bereply_uni(`DEVICE_SN`,`MSGKEY`,`REPLYKEY`) USING BTREE,
  KEY `idx_bereply_sn_status` (`DEVICE_SN`,`STATUS`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 comment='用户帖子被回复消息读取表';
#被点赞消息列表
DROP TABLE IF EXISTS `USER_MSG_BEADMIRE`;
CREATE TABLE `USER_MSG_BEADMIRE` (
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `DEVICE_SN` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '设备SN',
  `MSGKEY` bigint(20) unsigned NOT NULL COMMENT '你的帖子ID',
  `ADMIRE_SN` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '点赞你帖子的设备SN',
  `STATUS` int(11) DEFAULT '0' COMMENT '读取状态，0为未读，1为已读取',
  `CREATED_DATE` datetime DEFAULT NULL COMMENT '被点赞时间',
  PRIMARY KEY (`ID`) USING BTREE,
  UNIQUE KEY idx_beadmire_uni(`DEVICE_SN`,`MSGKEY`,`ADMIRE_SN`) USING BTREE,
  KEY `idx_beadmire_sn_status` (`DEVICE_SN`,`STATUS`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 comment='用户帖子被点赞消息读取表';

#用户的帖子通知表
DROP TABLE IF EXISTS `USER_NOTIF`;
CREATE TABLE `USER_NOTIF` (
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `DEVICE_SN` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '设备SN',
  `MSGKEY` bigint(20) unsigned DEFAULT NULL COMMENT '通知的帖子ID',
  `TYPE` int(11) DEFAULT '0' COMMENT '通知的类型, 0 多人投诉导致封帖',
  `STATUS` int(11) DEFAULT '0' COMMENT '通知的状态',
  `NOTIF_DATE` datetime DEFAULT NULL COMMENT '通知时间',
  `TITLE` varchar(512) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT '通知的标题',
  `CONTENT` varchar(1024) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT '通知的内容',
  PRIMARY KEY (`ID`) USING BTREE,
  KEY `idx_notif_sn_status` (`DEVICE_SN`,`STATUS`),
  KEY idx_usernotif_uni(`DEVICE_SN`,`MSGKEY`,`TYPE`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 comment='用户的帖子通知表';
#alter table USER_NOTIF drop key `idx_usernotif_uni`;
#alter table USER_NOTIF add KEY idx_usernotif_uni(`DEVICE_SN`,`MSGKEY`,`TYPE`) USING BTREE;

#游戏分类id以json存储的表
DROP TABLE IF EXISTS `JSON_GAME2CLASS`;
CREATE TABLE `JSON_GAME2CLASS` (
  `APP_NAME` varchar(100) NOT NULL COMMENT '游戏名称',
  `GAME_URL` varchar(300) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '游戏下载地址',
  `ICON_URL` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '游戏图标地址',
  `CATEGORYID` varchar(100) NOT NULL COMMENT '游戏分类集合',
  PRIMARY KEY (`APP_NAME`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

#清除勋章授予记录
delete from USER_NOTIF;
delete from STAT_USER_ADMIRE;
delete from STAT_USER_TOPIC;
delete from STAT_GETKEYADAPTER;

#安装信息备份数据
CREATE TABLE `GCS_PLAY_INSTALL_LOG_BAK` (
  `ID` int(11),
  `ACCOUNT_NO` int(11) NOT NULL,
  `NICKNAME` varchar(32) DEFAULT NULL,
  `DEVICE_SN` varchar(128) DEFAULT NULL,
  `DEVICE_TYPE` varchar(128) DEFAULT NULL,
  `DEVICE_VER` varchar(128) DEFAULT NULL,
  `APP_NAME` varchar(100) DEFAULT NULL,
  `APP_PACKAGE` varchar(100) NOT NULL,
  `VERSION_CODE` varchar(32) DEFAULT NULL,
  `ICON_URL` varchar(100) DEFAULT NULL,
  `REC_TIME` datetime NOT NULL DEFAULT '0000-00-00 00:00:00'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#APP使用信息备份数据
CREATE TABLE `GCS_PLAY_USETIME_LOG_BAK` (
  `ID` int(11),
  `ACCOUNT_NO` int(11) NOT NULL,
  `NICKNAME` varchar(32) DEFAULT NULL,
  `DEVICE_SN` varchar(128) DEFAULT NULL,
  `DEVICE_TYPE` varchar(128) DEFAULT NULL,
  `DEVICE_VER` varchar(128) DEFAULT NULL,
  `APP_NAME` varchar(100) DEFAULT NULL,
  `APP_PACKAGE` varchar(100) NOT NULL,
  `VERSION_CODE` varchar(32) DEFAULT NULL,
  `USETIME` bigint(11) DEFAULT '0',
  `REC_TIME` datetime NOT NULL DEFAULT '0000-00-00 00:00:00'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#冷门榜临时表
CREATE TABLE `TMP_GAME_LIST1` (
  `WEEKNUM` int(7) NOT NULL COMMENT '记录属于第几周 格式 YYYYWW',
  `APP_NAME` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '被推荐游戏名称',
  `TIMETOTAL` bigint(11) DEFAULT '0' COMMENT '本周此游戏被玩耍的总时长',
  `USERTOTAL` int(11) DEFAULT '0' COMMENT '本周玩耍此游戏的人数',
  KEY `idx_tmplist1_appname` (`APP_NAME`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#爆肝榜临时表
CREATE TABLE `TMP_GAME_LIST2` (
  `WEEKNUM` int(7) NOT NULL COMMENT '记录属于第几周 格式 YYYYWW',
  `APP_NAME` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '被推荐游戏名称',
  `AVRTIME` int(11) DEFAULT '0' COMMENT '本周此游戏被玩耍平均时长',
  KEY `idx_tmplist2_appname` (`APP_NAME`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;




#摩奇圈游戏排行榜优化 add by 20181223
#游戏指标
drop table if exists GAME_INDICATORS;
CREATE TABLE `GAME_INDICATORS` (
  `WEEK_NUM` int(11) NOT NULL COMMENT '统计周YYYYWW格式',
  `APP_NAME` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '游戏名称',
  `INSTALL_NUM` int(11) DEFAULT '0' COMMENT '安装量',
  `TIME_TOTAL` int(11) DEFAULT '0' COMMENT '使用总时长',
  `TIME_AVG` int(11) DEFAULT '0' COMMENT '平均时长(使用总时长/安装量)',
  `KEY_ADAPTER_TOTAL` int(11) DEFAULT '0' COMMENT '按键方案总数',
  PRIMARY KEY (`WEEK_NUM`,`APP_NAME`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
#游戏评分
drop table if exists GAME_SCORE;
CREATE TABLE `GAME_SCORE` (
  `WEEK_NUM` int(11) NOT NULL COMMENT '统计周YYYYWW格式',
  `APP_NAME` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '游戏名称',
  `INSTALL_NUM_SCORE` bigint(11) DEFAULT '0' COMMENT '安装量得分',
  `TIME_TOTAL_SCORE` bigint(11) DEFAULT '0' COMMENT '使用总时长得分',
  `TIME_AVG_SCORE` bigint(11) DEFAULT '0' COMMENT '平均时长得分',
  `KEY_ADAPTER_TOTAL_SCORE` bigint(11) DEFAULT '0' COMMENT '按键方案总数得分',
  PRIMARY KEY (`WEEK_NUM`,`APP_NAME`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
#推荐1安装量
drop table if exists SCORE_ADVISE1;
CREATE TABLE `SCORE_ADVISE1` (
  `WEEK_NUM` int(11) NOT NULL COMMENT '统计周YYYYWW格式',
  `APP_NAME` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '游戏名称',
  `SCORE` int(11) DEFAULT '0' COMMENT '分数',
  PRIMARY KEY (`WEEK_NUM`,`APP_NAME`),
  KEY `idx_adv_num_week_num` (`WEEK_NUM`),
  KEY `idx_adv_num_app_name` (`APP_NAME`),
  KEY `idx_adv_num_score` (`SCORE`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
#推荐2总时长最高优先公式
drop table if exists SCORE_ADVISE2;
CREATE TABLE `SCORE_ADVISE2` (
  `WEEK_NUM` int(11) NOT NULL COMMENT '统计周YYYYWW格式',
  `APP_NAME` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '游戏名称',
  `SCORE` int(11) DEFAULT '0' COMMENT '分数',
  PRIMARY KEY (`WEEK_NUM`,`APP_NAME`),
  KEY `idx_adv_num_week_num` (`WEEK_NUM`),
  KEY `idx_adv_num_app_name` (`APP_NAME`),
  KEY `idx_adv_num_score` (`SCORE`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
#排行榜2：冷门榜：使用的用户少，但使用时长高
drop table if exists SCORE_RANK2;
CREATE TABLE `SCORE_RANK2` (
  `WEEK_NUM` int(11) NOT NULL COMMENT '统计周YYYYWW格式',
  `APP_NAME` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '游戏名称',
  `SCORE` int(11) DEFAULT '0' COMMENT '真实分数',
  `SORT_SCORE` int(11) DEFAULT '0' COMMENT '排序分数'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
#排行榜3：爆肝榜：平均使用时长高
drop table if exists SCORE_RANK3;
CREATE TABLE `SCORE_RANK3` (
  `WEEK_NUM` int(11) NOT NULL COMMENT '统计周YYYYWW格式',
  `APP_NAME` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '游戏名称',
  `SCORE` int(11) DEFAULT '0' COMMENT '真实分数',
  `SORT_SCORE` int(11) DEFAULT '0' COMMENT '排序分数'
) ENGINE=MyISAM DEFAULT CHARSET=utf8; 


#排行榜2：冷门榜：使用的用户少，但使用时长高
drop table if exists STAT_SCORE_RANK_LST2;
CREATE TABLE `STAT_SCORE_RANK_LST2` (
  `DEVICE_SN` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '设备SN',
  `WEEK_NUM` int(11) NOT NULL COMMENT '统计周YYYYWW格式',
  `APP_NAME` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '游戏名称',
  `SCORE` int(11) DEFAULT '0' COMMENT '真实分数',
  PRIMARY KEY (`DEVICE_SN`, `WEEK_NUM`, `APP_NAME`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
#排行榜3：爆肝榜：平均使用时长高
drop table if exists STAT_SCORE_RANK_LST3;
CREATE TABLE `STAT_SCORE_RANK_LST3` (
  `DEVICE_SN` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '设备SN',
  `WEEK_NUM` int(11) NOT NULL COMMENT '统计周YYYYWW格式',
  `APP_NAME` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '游戏名称',
  `SCORE` int(11) DEFAULT '0' COMMENT '真实分数',
  PRIMARY KEY (`DEVICE_SN`, `WEEK_NUM`, `APP_NAME`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8; 



#用户上传的应用
DROP TABLE IF EXISTS `USER_APK`;
CREATE TABLE `USER_APK` (
  `MD5` varchar(256) NOT NULL COMMENT '上传文件的MD5校验值',
  `APP_NAME` varchar(500) NOT NULL COMMENT '应用名称',
  `FILE_URL` varchar(500) NOT NULL COMMENT '应用下载地址',
  `ICON_URL` varchar(500) NOT NULL COMMENT '应用图标地址',
  PRIMARY KEY (`MD5`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

#应用的不同下载渠道
DROP TABLE IF EXISTS `APP_URL`;
CREATE TABLE `APP_URL` (
  `APP_NAME` varchar(300) NOT NULL COMMENT '应用名称',
  `NET_NAME` varchar(20) NOT NULL COMMENT '应用渠道',
  `URL` varchar(500) NOT NULL COMMENT '应用下载地址',
  PRIMARY KEY (`APP_NAME`, `NET_NAME`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

#修改记录
mysql> update MESSAGELIST set ACCOUNT_NO=10000 where APP_NAME='最强NBA' and ACCOUNT_NO=0 and SCHEME_TYPE=4;
mysql> update appstore.APP_KEYSCREEN set ACCOUNT_NO=10000 where APP_NAME='最强NBA' and ACCOUNT_NO=0 and SCHEME_TYPE=4;
Query OK, 0 rows affected (0.01 sec)
Rows matched: 0  Changed: 0  Warnings: 0
mysql> update appstore.APP_KEYSCREEN set ACCOUNT_NO=0 where APP_NAME='最强NBA' and SCHEME_TYPE=4 and HASH_CODE=-1141064938;
Query OK, 1 row affected (0.00 sec)
Rows matched: 1  Changed: 1  Warnings: 0


#摩奇游戏圈话题标签
drop table if exists MSG_LABEL;
create table `MSG_LABEL` (
  `ID` int(11) NOT NULL AUTO_INCREMENT comment '话题标签ID',
  `NAME` varchar(128) collate utf8_unicode_ci not null unique comment '话题标签名称',
  primary key (`ID`)
) engine=MyISAM default charset=utf8; 

insert into MSG_LABEL values(1,"产品建议|问题反馈"),
(2,"攻略|优质游戏分享"),
(3,"杂谈|扯淡"),
(4,"公告|使用说明"),
(5,"硬文|黑科技分享"),
(6,"测试|性能评测"),
(0,"其他");


#摩奇游戏圈话题分类
drop table if exists STAT_MSG2LABEL;
create table `STAT_MSG2LABEL` (
	`MSGKEY` bigint(20) unsigned NOT NULL COMMENT '消息的唯一记录,帖子的ID号',
  `LABELID` int(11) NOT NULL comment '话题标签ID',
  primary key (`MSGKEY`),
  KEY `idx_label` (`LABELID`)
) engine=MyISAM default charset=utf8; 
#alter STAT_MSG2LABEL add KEY `idx_label` (`LABELID`);



#新增非游戏应用的推荐 add ldh 20190305
#应用排行名单 安装数量
drop table if exists STAT_ADVISE_APP_NUM;
CREATE TABLE `STAT_ADVISE_APP_NUM` (
  `DEVICE_SN` varchar(128) NOT NULL COMMENT '被统计的用户',
  `STATDAY` varchar(20) NOT NULL COMMENT '统计日期YYYYMMDD格式',
  `APP_NAME` varchar(100) NOT NULL COMMENT '被推荐应用名称',
  `APP_INS_NUM` int(11) NOT NULL COMMENT '被推荐应用被下载次数',
  PRIMARY KEY (`DEVICE_SN`,`STATDAY`, `APP_NAME`),
  KEY `idx_adv_sn_day` (`DEVICE_SN`,`STATDAY`),
  KEY `idx_adv_num_day` (`STATDAY`),
  KEY `idx_adv_num_app_ins_num` (`APP_INS_NUM`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;


#应用排行名单 平均时长
DROP TABLE IF EXISTS `STAT_ADVISE_APP_TIME`;
CREATE TABLE `STAT_ADVISE_APP_TIME` (
  `DEVICE_SN` varchar(128) NOT NULL COMMENT '被统计的用户',
  `STATDAY` varchar(20) NOT NULL NOT NULL COMMENT '统计日期YYYYMMDD格式',
  `APP_NAME` varchar(100) NOT NULL COMMENT '被推荐游戏名称',
  `APP_USE_SUMTIME` bigint(11) DEFAULT '0' COMMENT '被推荐游戏平均使用时长',
  PRIMARY KEY (`DEVICE_SN`,`STATDAY`, `APP_NAME`),
  KEY `idx_adv_time_day` (`STATDAY`) USING HASH,
  KEY `idx_adv_time_sn` (`DEVICE_SN`,`STATDAY`) USING HASH
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

#排行榜4：日常应用榜：根据安装人数
DROP TABLE IF EXISTS `STAT_RANK_LST4`;
CREATE TABLE `STAT_RANK_LST4` (
  `WEEKNUM` int(7) NOT NULL COMMENT '记录属于第几周 格式 YYYYWW',
  `APP_NAME` varchar(100) NOT NULL COMMENT '被推荐游戏名称',
  `USETOTAL` int(11) DEFAULT '0' COMMENT '安装总数',
  PRIMARY KEY (`WEEKNUM`, `APP_NAME`) USING HASH,
  KEY `idx_list4_week` (`WEEKNUM`) USING HASH,
  KEY `idx_list4_total` (`USETOTAL`) USING HASH
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

insert into STAT_RANK_TABS(NO,TAB_NAME) values(4,'应用榜');

drop table if exists TMPAPP;
CREATE TABLE TMPAPP select t1.APP_NAME, t2.APP_CLASS_ID, count(DEVICE_SN) as total, sum(USETIME) as usetime from GCS_PLAY_USETIME_LOG t1 inner join TMPAPPLIST t2 on t1.APP_NAME=t2.APP_NAME group by t1.APP_NAME;

delete from STAT_ADVISE_APP_TIME;
insert into STAT_ADVISE_APP_TIME(DEVICE_SN, STATDAY, APP_NAME, APP_USE_SUMTIME) select '304011734149816', 20190306, APP_NAME, usetime from TMPAPP where APP_NAME not in (select distinct APP_NAME from GCS_PLAY_USETIME_LOG where DEVICE_SN ='304011734149816') order by usetime desc limit 200;

delete from STAT_ADVISE_APP_NUM;
insert into STAT_ADVISE_APP_NUM(DEVICE_SN, STATDAY, APP_NAME, APP_INS_NUM) select '304011734149816', 20190306, APP_NAME, total from TMPAPP where APP_NAME not in (select distinct APP_NAME from GCS_PLAY_INSTALL_LOG where DEVICE_SN ='304011734149816') order by total desc  limit 200;

delete from STAT_RANK_LST4;
insert into STAT_RANK_LST4(WEEKNUM, APP_NAME, USETOTAL) select 201909, APP_NAME, total from TMPAPP  order by total desc  limit 200;