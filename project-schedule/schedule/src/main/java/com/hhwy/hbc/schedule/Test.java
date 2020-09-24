package com.hhwy.hbc.schedule;

import com.hhwy.fweb.data.mybatis.MpGenerator;

 /**
 * <b>类 名 称：</b>Test<br/>
 * <b>类 描 述：</b><br/>
 * <b>创 建 人：</b>jsq<br/>
 * <b>修 改 人：</b>jsq<br/>
 * <b>修改时间：</b>2020年3月5日 上午11:15:25<br/>
 * <b>修改备注：</b><br/>
 * @version 1.0.0<br/>
 */
public class Test {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		MpGenerator.generate("com_", "com_sche_task_actual,com_sche_wbs,com_sche_wbs_temp,com_sche_task_temp" , "com.hhwy.fweb.tests");
	}

}
