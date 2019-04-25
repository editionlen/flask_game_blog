drop procedure rank_score;
DELIMITER //
#生成游戏的评分,一周运行一次
create procedure rank_score(in this_week int, in last_week int, in full_marks int)
begin
	#以下变量名为小写，而数据库字段名为大写
	#排名权值1 安装量
	declare install_num_weight int default 0;
	#排名权值2 按键映射方案总数
	declare key_adapter_total_weight int default 0;
	#排名权值3 总时长
	declare time_total_weight int default 0;
	#排名权值4 平均时长
	declare time_avg_weight int default 0;
	#建议分数最低值,默认为1分
	declare min_marks int default 1;
	
	#1.生成应用的基础分数
	#删除之前统计的当天游戏指标数据
	delete from GAME_INDICATORS where WEEK_NUM=this_week;
	#插入当天的所有游戏
	insert into GAME_INDICATORS(WEEK_NUM, APP_NAME) select this_week, APP_NAME from STAT_GAME2CLASS where APP_CLASS_ID>100 group by APP_NAME;
	select "#1.生成应用的基础分数" as t1;
	#更新安装量
	update GAME_INDICATORS, (select APP_NAME, count(DEVICE_SN) as INSTALL_NUM from GCS_PLAY_INSTALL_LOG group by APP_NAME) as tmp_game_install_num  set GAME_INDICATORS.INSTALL_NUM = tmp_game_install_num.INSTALL_NUM where WEEK_NUM=this_week and GAME_INDICATORS.APP_NAME = tmp_game_install_num.APP_NAME;
	#更新总时长
	update GAME_INDICATORS as game_ind, (select APP_NAME, sum(USETIME) as TIME_TOTAL from GCS_PLAY_USETIME_LOG group by APP_NAME) as tmp_game_time_total  set game_ind.TIME_TOTAL = tmp_game_time_total.TIME_TOTAL where game_ind.WEEK_NUM=this_week and game_ind.APP_NAME = tmp_game_time_total.APP_NAME;
	#更新平均时长
	update GAME_INDICATORS set TIME_AVG=TIME_TOTAL/INSTALL_NUM where WEEK_NUM=this_week;
	#更新按键方案总数
	update server_games.GAME_INDICATORS as game_ind, (select APP_NAME, count(ID) as ADAPTER_COUNT from appstore.APP_KEYSCREEN group by APP_NAME) as tmp_game_adapter_count  set game_ind.KEY_ADAPTER_TOTAL = tmp_game_adapter_count.ADAPTER_COUNT where WEEK_NUM=this_week and game_ind.APP_NAME = tmp_game_adapter_count.APP_NAME;
	#删除之前统计的当天游戏游戏评分数据
	#将游戏原始指标表游戏插入游戏评分表
	select "#将游戏原始指标表游戏插入游戏评分表" as t1_1;
	delete from GAME_SCORE where WEEK_NUM=this_week;
	insert into GAME_SCORE(WEEK_NUM, APP_NAME) select this_week, APP_NAME from GAME_INDICATORS where WEEK_NUM=this_week;
	#转化安装量为分数
	update GAME_SCORE as game_scr, GAME_INDICATORS as game_ind  set game_scr.INSTALL_NUM_SCORE=game_ind.INSTALL_NUM*full_marks/(select max(INSTALL_NUM) from GAME_INDICATORS) where game_scr.WEEK_NUM=this_week and game_scr.APP_NAME = game_ind.APP_NAME;
	#转化总时长为分数
	update GAME_SCORE as game_scr, GAME_INDICATORS as game_ind  set game_scr.TIME_TOTAL_SCORE=game_ind.TIME_TOTAL*full_marks/(select max(TIME_TOTAL) from GAME_INDICATORS) where game_scr.WEEK_NUM=this_week and game_scr.APP_NAME = game_ind.APP_NAME;
	#转化平均时长为分数
	update GAME_SCORE as game_scr, GAME_INDICATORS as game_ind  set game_scr.TIME_AVG_SCORE=game_ind.TIME_AVG*full_marks/(select max(TIME_AVG) from GAME_INDICATORS) where game_scr.WEEK_NUM=this_week and game_scr.APP_NAME = game_ind.APP_NAME;
	#转化按键方案总数为分数
	update GAME_SCORE as game_scr, GAME_INDICATORS as game_ind  set game_scr.KEY_ADAPTER_TOTAL_SCORE=game_ind.KEY_ADAPTER_TOTAL*full_marks/(select max(KEY_ADAPTER_TOTAL) from GAME_INDICATORS) where game_scr.WEEK_NUM=this_week and game_scr.APP_NAME = game_ind.APP_NAME;
	
	
	#2.生成推荐应用的分数
	#推荐安装量最高优先公式
	#GAME_SCORE
	#WEEK_NUM APP_NAME INSTALL_NUM_SCORE TIME_TOTAL_SCORE TIME_AVG_SCORE KEY_ADAPTER_TOTAL_SCORE
	set install_num_weight = 0.6;
	set key_adapter_total_weight = 0.2;
	set time_total_weight = 0.1;
	set time_avg_weight = 0.1;
	select "#推荐安装量最高优先公式" as t2;
	delete from SCORE_ADVISE1 where WEEK_NUM=this_week;
	insert into SCORE_ADVISE1(WEEK_NUM, APP_NAME, SCORE) select WEEK_NUM, APP_NAME,CAL_SCORE from (select this_week as WEEK_NUM, APP_NAME as APP_NAME, (INSTALL_NUM_SCORE*install_num_weight + KEY_ADAPTER_TOTAL_SCORE*key_adapter_total_weight + TIME_TOTAL_SCORE*time_total_weight + TIME_AVG_SCORE*time_avg_weight) as CAL_SCORE from GAME_SCORE) tmp_g_score where tmp_g_score.WEEK_NUM=this_week and CAL_SCORE >= min_marks order by CAL_SCORE desc limit 500;
	#推荐总时长最高优先公式
	select "#推荐总时长最高优先公式" as t3;
	set install_num_weight = 0.1;
	set key_adapter_total_weight = 0.2;
	set time_total_weight = 0.6;
	set time_avg_weight = 0.1;
	delete from SCORE_ADVISE2 where WEEK_NUM=this_week;
	insert into SCORE_ADVISE2(WEEK_NUM, APP_NAME, SCORE) select WEEK_NUM, APP_NAME,CAL_SCORE from (select this_week as WEEK_NUM, APP_NAME as APP_NAME, (INSTALL_NUM_SCORE*install_num_weight + KEY_ADAPTER_TOTAL_SCORE*key_adapter_total_weight + TIME_TOTAL_SCORE*time_total_weight + TIME_AVG_SCORE*time_avg_weight) as CAL_SCORE from GAME_SCORE) tmp_g_score where tmp_g_score.WEEK_NUM=this_week and CAL_SCORE >= min_marks order by CAL_SCORE desc limit 500;
	
	
	#3.生成排行榜应用的分数
	#排行榜2：冷门榜：使用的用户少，但使用时长高
	set install_num_weight = 0.1;
	set key_adapter_total_weight = 0.2;
	set time_total_weight = 0.6;
	set time_avg_weight = 0.1;
	delete from SCORE_RANK2 where WEEK_NUM=this_week;
	select "#排行榜2：冷门榜：使用的用户少，但使用时长高" as t4;
	insert into SCORE_RANK2(WEEK_NUM, APP_NAME, SCORE, SORT_SCORE) select WEEK_NUM, APP_NAME,CAL_SCORE,CAL_SCORE from (select this_week as WEEK_NUM, APP_NAME as APP_NAME, (INSTALL_NUM_SCORE*install_num_weight + KEY_ADAPTER_TOTAL_SCORE*key_adapter_total_weight + TIME_TOTAL_SCORE*time_total_weight + TIME_AVG_SCORE*time_avg_weight) as CAL_SCORE from GAME_SCORE) tmp_g_score where tmp_g_score.WEEK_NUM=this_week and CAL_SCORE >= min_marks order by CAL_SCORE desc limit 500;	
	#防止top20重复登榜，分数*0.5
	update SCORE_RANK2 set SORT_SCORE=SORT_SCORE*0.5 where APP_NAME in (select tmp.APP_NAME from (select APP_NAME from SCORE_RANK2 where WEEK_NUM=last_week order by SORT_SCORE desc limit 20) tmp);

	#排行榜3：爆肝榜：平均使用时长高
	set install_num_weight = 0.1;
	set key_adapter_total_weight = 0.2;
	set time_total_weight = 0.1;
	set time_avg_weight = 0.6;
	delete from SCORE_RANK3 where WEEK_NUM=this_week;
	select "#排行榜3：爆肝榜：平均使用时长高" as t5;
	insert into SCORE_RANK3(WEEK_NUM, APP_NAME, SCORE, SORT_SCORE) select WEEK_NUM, APP_NAME,CAL_SCORE,CAL_SCORE from (select this_week as WEEK_NUM, APP_NAME as APP_NAME, (INSTALL_NUM_SCORE*install_num_weight + KEY_ADAPTER_TOTAL_SCORE*key_adapter_total_weight + TIME_TOTAL_SCORE*time_total_weight + TIME_AVG_SCORE*time_avg_weight) as CAL_SCORE from GAME_SCORE) tmp_g_score where tmp_g_score.WEEK_NUM=this_week and CAL_SCORE >= min_marks order by CAL_SCORE desc limit 500;
	#防止top20重复登榜，分数*0.5
	update SCORE_RANK3 set SORT_SCORE=SORT_SCORE*0.5 where APP_NAME in (select tmp.APP_NAME from (select APP_NAME from SCORE_RANK3 where WEEK_NUM=last_week order by SORT_SCORE desc limit 20) tmp);	
	
end;
//
DELIMITER ;