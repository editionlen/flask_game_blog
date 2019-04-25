use server_games;

drop procedure change_game_circle_account;

#更换账号数据的存储过程
delimiter //                        #将delimiter设置为//
create procedure change_game_circle_account(in ori_sn varchar(50), in des_sn varchar(50))            #创建存储过程change_game_circle_account(change_game_circle_account才是你的过程名字)
begin                                  #表明存储过程开始语句

DECLARE EXCEPTION INT DEFAULT 0;
DECLARE EXIT HANDLER FOR SQLEXCEPTION SET EXCEPTION = 1;
START TRANSACTION;

set @tmp_sn=concat('@',des_sn);

#0　替换用户账号基本信息
update server_accounts.USERS set DEVICE_SN = @tmp_sn where DEVICE_SN = des_sn;
update server_accounts.USERS set DEVICE_SN = des_sn where DEVICE_SN = ori_sn;
update server_accounts.USERS set DEVICE_SN = ori_sn where DEVICE_SN = @tmp_sn;

#1 互换帖子信息
#互换帖信息
update server_games.MESSAGELIST set  DEVICE_SN = @tmp_sn where DEVICE_SN = des_sn;
update server_games.MESSAGELIST set  DEVICE_SN = des_sn where DEVICE_SN = ori_sn; 
update server_games.MESSAGELIST set  DEVICE_SN = ori_sn where DEVICE_SN = @tmp_sn;
#互换回复人信息
update server_games.MESSAGELIST set  REPLY_SN = @tmp_sn where DEVICE_SN = des_sn;
update server_games.MESSAGELIST set  REPLY_SN = des_sn where DEVICE_SN = ori_sn; 
update server_games.MESSAGELIST set  REPLY_SN = ori_sn where DEVICE_SN = @tmp_sn;
#私信功能发起人互换
update server_games.MESSAGELIST set  PRI_ORI_SN = @tmp_s where  PRI_ORI_SN = des_sn;
update server_games.MESSAGELIST set  PRI_ORI_SN = des_sn  where  PRI_ORI_SN = ori_sn; 
update server_games.MESSAGELIST set  PRI_ORI_SN = ori_sn  where  PRI_ORI_SN = @tmp_sn;
#私信功能接收人互换
update server_games.MESSAGELIST set  PRI_DES_SN = @tmp_sn where  PRI_DES_SN = des_sn;
update server_games.MESSAGELIST set  PRI_DES_SN = des_sn where  PRI_DES_SN = ori_sn; 
update server_games.MESSAGELIST set  PRI_DES_SN = ori_sn where  PRI_DES_SN = @tmp_sn;
#帖子附带按键映射互换
update server_games.USER_SAVEKEYADAPTER set  DEVICE_SN = @tmp_sn where DEVICE_SN = des_sn;
update server_games.USER_SAVEKEYADAPTER set  DEVICE_SN = des_sn where DEVICE_SN = ori_sn; 
update server_games.USER_SAVEKEYADAPTER set  DEVICE_SN = ori_sn where DEVICE_SN = @tmp_sn;

#2 荣誉互换
#勋章互换
update server_games.USER_MEDAL set  DEVICE_SN = @tmp_sn where DEVICE_SN = des_sn;
update server_games.USER_MEDAL set  DEVICE_SN = des_sn where DEVICE_SN = ori_sn; 
update server_games.USER_MEDAL set  DEVICE_SN = ori_sn where DEVICE_SN = @tmp_sn;
#积分互换
update server_games.USER_SCORE_LOG set  DEVICE_SN = @tmp_sn where DEVICE_SN = des_sn;
update server_games.USER_SCORE_LOG set  DEVICE_SN = des_sn where DEVICE_SN = ori_sn; 
update server_games.USER_SCORE_LOG set  DEVICE_SN = ori_sn where DEVICE_SN = @tmp_sn;

#3 点赞、关注、收藏及投诉互换
#点赞记录互换
update server_games.USER_ADMIRE set  DEVICE_SN = @tmp_sn where DEVICE_SN = des_sn;
update server_games.USER_ADMIRE set  DEVICE_SN = des_sn where DEVICE_SN = ori_sn; 
update server_games.USER_ADMIRE set  DEVICE_SN = ori_sn where DEVICE_SN = @tmp_sn;
#关注记录互换
update server_games.USER_UPLIST set  DEVICE_SN = @tmp_sn where DEVICE_SN = des_sn;
update server_games.USER_UPLIST set  DEVICE_SN = des_sn where DEVICE_SN = ori_sn; 
update server_games.USER_UPLIST set  DEVICE_SN = ori_sn where DEVICE_SN = @tmp_sn;
#被关注记录互换
update server_games.USER_UPLIST set  UP_SN = @tmp_sn where  UP_SN = des_sn;
update server_games.USER_UPLIST set  UP_SN = des_sn  where  UP_SN = ori_sn; 
update server_games.USER_UPLIST set  UP_SN = ori_sn  where  UP_SN = @tmp_sn;
#收藏记录互换
update server_games.USER_ATTENTION set  DEVICE_SN = @tmp_sn where DEVICE_SN = des_sn;
update server_games.USER_ATTENTION set  DEVICE_SN = des_sn where DEVICE_SN = ori_sn; 
update server_games.USER_ATTENTION set  DEVICE_SN = ori_sn where DEVICE_SN = @tmp_sn;
#投诉记录互换
update server_games.USER_COMPLAINT set  DEVICE_SN = @tmp_sn where DEVICE_SN = des_sn;
update server_games.USER_COMPLAINT set  DEVICE_SN = des_sn where DEVICE_SN = ori_sn; 
update server_games.USER_COMPLAINT set  DEVICE_SN = ori_sn where DEVICE_SN = @tmp_sn;

#4　消息通知互换
#被回复消息互换
update server_games.USER_MSG_BEREPLY set  DEVICE_SN = @tmp_sn where DEVICE_SN = des_sn;
update server_games.USER_MSG_BEREPLY set  DEVICE_SN = des_sn where DEVICE_SN = ori_sn; 
update server_games.USER_MSG_BEREPLY set  DEVICE_SN = ori_sn where DEVICE_SN = @tmp_sn;
#被点赞消息互换
update server_games.USER_MSG_BEADMIRE set  DEVICE_SN = @tmp_sn where DEVICE_SN = des_sn;
update server_games.USER_MSG_BEADMIRE set  DEVICE_SN = des_sn where DEVICE_SN = ori_sn; 
update server_games.USER_MSG_BEADMIRE set  DEVICE_SN = ori_sn where DEVICE_SN = @tmp_sn;
#警告互换
update server_games.USER_NOTIF set  DEVICE_SN = @tmp_sn where DEVICE_SN = des_sn;
update server_games.USER_NOTIF set  DEVICE_SN = des_sn where DEVICE_SN = ori_sn; 
update server_games.USER_NOTIF set  DEVICE_SN = ori_sn where DEVICE_SN = @tmp_sn;

#5 游戏推荐表及游戏排行榜互换
#下载量排行推荐游戏列表互换
update server_games.STAT_ADVISE_GAME_NUM set DEVICE_SN = @tmp_sn where DEVICE_SN = des_sn;
update server_games.STAT_ADVISE_GAME_NUM set DEVICE_SN = des_sn where DEVICE_SN = ori_sn; 
update server_games.STAT_ADVISE_GAME_NUM set DEVICE_SN = ori_sn where DEVICE_SN = @tmp_sn;
#使用时长排行推荐游戏列表互换
update server_games.STAT_ADVISE_GAME_TIME set  DEVICE_SN = @tmp_sn where DEVICE_SN = des_sn;
update server_games.STAT_ADVISE_GAME_TIME set  DEVICE_SN = des_sn where DEVICE_SN = ori_sn; 
update server_games.STAT_ADVISE_GAME_TIME set  DEVICE_SN = ori_sn where DEVICE_SN = @tmp_sn;
#冷门榜互换
update server_games.STAT_RANK_LST2 set  DEVICE_SN = @tmp_sn where DEVICE_SN = des_sn;
update server_games.STAT_RANK_LST2 set  DEVICE_SN = des_sn where DEVICE_SN = ori_sn; 
update server_games.STAT_RANK_LST2 set  DEVICE_SN = ori_sn where DEVICE_SN = @tmp_sn;
#爆肝榜互换
update server_games.STAT_RANK_LST3 set  DEVICE_SN = @tmp_sn where DEVICE_SN = des_sn;
update server_games.STAT_RANK_LST3 set  DEVICE_SN = des_sn where DEVICE_SN = ori_sn; 
update server_games.STAT_RANK_LST3 set  DEVICE_SN = ori_sn where DEVICE_SN = @tmp_sn;
#点赞周排行互换
update server_games.STAT_USER_ADMIRE set  DEVICE_SN = @tmp_sn where DEVICE_SN = des_sn;
update server_games.STAT_USER_ADMIRE set  DEVICE_SN = des_sn where DEVICE_SN = ori_sn; 
update server_games.STAT_USER_ADMIRE set  DEVICE_SN = ori_sn where DEVICE_SN = @tmp_sn;
#话题周排行互换
update server_games.STAT_USER_TOPIC set  DEVICE_SN = @tmp_sn where DEVICE_SN = des_sn;
update server_games.STAT_USER_TOPIC set  DEVICE_SN = des_sn where DEVICE_SN = ori_sn; 
update server_games.STAT_USER_TOPIC set  DEVICE_SN = ori_sn where DEVICE_SN = @tmp_sn;
#按键映射方案下载周排行互换
update server_games.STAT_GETKEYADAPTER set  DEVICE_SN = @tmp_sn where DEVICE_SN = des_sn;
update server_games.STAT_GETKEYADAPTER set  DEVICE_SN = des_sn where DEVICE_SN = ori_sn; 
update server_games.STAT_GETKEYADAPTER set  DEVICE_SN = ori_sn where DEVICE_SN = @tmp_sn;


IF EXCEPTION = 1 THEN
ROLLBACK;
ELSE
COMMIT;
END IF;

end                                     #表明存储过程结束语句
//                                          #MySQL开始执行语句

delimiter ;

#call change_game_circle_account('1','3');


#select * from USERS where DEVICE_SN = '1'\G
#select * from USERS where DEVICE_SN = '3'\G