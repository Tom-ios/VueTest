package com.hhwy.hbc.schedule.helper;

import java.util.UUID;

public class UUIDUtil {
	
	/**
	 * @Title: get32UUID
	 * @Description:(这里用一句话描述这个方法的作用)
	 * @return 
	 * String
	 * <b>创 建 人：</b>jsq<br/>
	 * <b>创建时间:</b>2020年3月5日 上午10:37:58
	 * <b>修 改 人：</b>jsq<br/>
	 * <b>修改时间:</b>2020年3月5日 上午10:37:58
	 * @since  1.0.0
	 */
	public static String get32UUID(){
	    UUID id = UUID.randomUUID();
	    String[] idd = id.toString().split("-");
	    return idd[0] + idd[1] + idd[2] + idd[3]+idd[4];
	}
	/**
	 * 
	 * 功能:不足4位补0
	 * @param number
	 * @return
	 */
	public static String fillZero(Integer number, int numLength){
		StringBuffer numberStr = new StringBuffer();
		for(int i=number.toString().length();i<numLength;i++){
			numberStr.append("0");
		}
		
		return numberStr.append(number).toString();
	}
}
