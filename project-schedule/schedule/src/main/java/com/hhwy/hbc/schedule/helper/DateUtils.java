package com.hhwy.hbc.schedule.helper;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.Instant;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.temporal.ChronoUnit;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * 日期工具类
 */
public class DateUtils {
	public static String SIMPLE_DATE_DAY = "yyyy-MM-dd";
    public static Date getNow(){
        return new Date();
    }
    public static String getNowYmd(){
    	return getDateStr(getNow(), "yyyy-MM-dd");
    }
    public static String getMonth(){
        return getDateStr(getNow(),"yyyy-MM");
    }
    public static String getDateStr(Date date,String format){
        SimpleDateFormat sdf = new SimpleDateFormat(format);
        String dateStr =  sdf.format(date);
        return dateStr;
    }
    public static Date parseDate(String dateStr,String format){
        SimpleDateFormat sdf = new SimpleDateFormat(format);
        try {
            return sdf.parse(dateStr);
        } catch (ParseException e) {
            return null;
        }
    }
    
    /**
     * @Title: parseDate
     * @Description:(日期格式化)
     * @param dateStr
     * @param format
     * @return 
     * Date
     * @since  1.0.0
     */
    public static Date parseDate2Date(Date dateStr,String format){
    	SimpleDateFormat sdf = new SimpleDateFormat(format);
    	try {
    		return sdf.parse(sdf.format(dateStr));
    	} catch (ParseException e) {
    		return null;
    	}
    }
    public static String getPreMonth(){
        Calendar c = Calendar.getInstance();
        c.setTime(new Date());
        c.add(Calendar.MONTH, -1);
        return getDateStr(c.getTime(),"yyyy-MM");
    }
    public static int getMonthSpace(Date date1, Date date2){
        int result = 0;
        Calendar c1 = Calendar.getInstance();
        Calendar c2 = Calendar.getInstance();
        c1.setTime(date1);
        c2.setTime(date2);
        result = c2.get(Calendar.MONTH) - c1.get(Calendar.MONTH);
        return result == 0 ? 1 : Math.abs(result);
    }
    
    public static int getDayOfMonth(Date date){
    	Calendar c = Calendar.getInstance();
    	c.setTime(date);
    	return c.get(Calendar.DAY_OF_MONTH);
    }
    
    /**
     * @Title: getDaysByYearMonth
     * @Description:(根据日期字符串(格式yyyy/mm/dd  或者yyyy-mm 或者yyyy-mm-dd) 获取月份的天数)
     * @param date
     * @return 
     * int
     * @since  1.0.0
     */
    public static int getDaysByYearMonth(String date)
         {
    	Integer year=Integer.parseInt(date.substring(0, 4));
    	Integer month=Integer.parseInt(date.substring(5, 7));
             Calendar a = Calendar.getInstance();
             a.set(Calendar.YEAR, year);
             a.set(Calendar.MONTH, month - 1);
             a.set(Calendar.DATE, 1);
             a.roll(Calendar.DATE, -1);
             int maxDate = a.getActualMaximum(Calendar.DATE);
             return maxDate;
         }
    
    /**
     * @Title: getDateToAdd
     * @Description:(指定日期加1秒并返回日期)
     * @param date
     * @return 
     * Date
     * @since  1.0.0
     */
    public static Date getDateToAdd(Date date){
    	 Calendar calendar = Calendar.getInstance ();
    	 calendar.setTime(date);
         calendar.add (Calendar.SECOND, 1);
		return calendar.getTime ();
    }
    
    public static void main(String[] args) {
		System.out.println(getPreMonth());
	}
    
    
    /**
     * date转localDate
     * @param date
     * @return
     */
    public static LocalDate UDateToLocalDate(Date date) {
    	
    	Instant instant = date.toInstant();
    	ZoneId zone = ZoneId.systemDefault();
    	LocalDateTime localDateTime = LocalDateTime.ofInstant(instant, zone);
    	LocalDate localDate = localDateTime.toLocalDate();
    	return localDate;
    }
    /*获取七天前的日期*/
    public static String getBeforeDate(int day){
    	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");                
  	  
        Calendar c = Calendar.getInstance();           
      
        c.add(Calendar.DATE, - day);           
      
        java.util.Date time = c.getTime();         
      
        String preDay = sdf.format(time);         
        return preDay;
    }
    
    
    public static Date getDatePlus(Date d,int n){
    	Calendar calendar  =   Calendar.getInstance();
        calendar.setTime(d); 
        calendar.add(calendar.DATE, n);//把日期往后增加n天.正数往后推,负数往前移动 
        return calendar.getTime();   
    }
    
    public static Date getDatePlusNotWeekend(Date startTime,int leaveDays){
		Date flag = startTime;//设置循环开始日期
		Calendar cal = Calendar.getInstance();
		//循环遍历每个日期
		for(int i=1;i<=leaveDays;i++){
			cal.setTime(flag);
			//判断是否为周六日
			int week = cal.get(Calendar.DAY_OF_WEEK) - 1;
			if(week == 0 || week == 6){//0为周日，6为周六
				//跳出循环进入下一个日期
				if(week==0){
					cal.add(Calendar.DAY_OF_MONTH, +1);
				}else{
					cal.add(Calendar.DAY_OF_MONTH, +2);
				}
				flag = cal.getTime();
				continue;
			}
			//日期往后加一天
			cal.add(Calendar.DAY_OF_MONTH, +1);
			flag = cal.getTime();
		}
	  return flag;
	
    }
    
    /************LocalDate**************/
    public static LocalDateTime getLocalDatePlus(LocalDateTime d,int n){
    	LocalDateTime localDate = d.plus(n,ChronoUnit.DAYS);
    	return localDate;
    }
    
    public static int daysBetween(Date smdate,Date bdate) throws ParseException    
    {    
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");  
        smdate=sdf.parse(sdf.format(smdate));  
        bdate=sdf.parse(sdf.format(bdate));  
        Calendar cal = Calendar.getInstance();    
        cal.setTime(smdate);    
        long time1 = cal.getTimeInMillis();                 
        cal.setTime(bdate);    
        long time2 = cal.getTimeInMillis();         
        long between_days=(time2-time1)/(1000*3600*24);  
            
        return Integer.parseInt(String.valueOf(between_days));           
    }  
}
