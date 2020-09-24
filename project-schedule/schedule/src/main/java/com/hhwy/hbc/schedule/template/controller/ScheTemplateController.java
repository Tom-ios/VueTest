package com.hhwy.hbc.schedule.template.controller;


import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.hhwy.hbc.schedule.template.model.ScheWbsTemp;
import com.hhwy.hbc.schedule.template.service.ScheWbsTempService;


/**
 * <p>
 *  前端控制器
 * </p>
 *
 * @author admin
 * @since 2020-03-13
 */
@RestController
@RequestMapping("/scheTemplate")
public class ScheTemplateController {
	
	@Autowired 
	private ScheWbsTempService wbsTempService;
	
	
//	@Autowired 
//	private ScheResourceTempService resourceTempService;
	
	//********************WBS模板处理方法*************************
	/**
	 * @Title: getWbsTempData
	 * @Description:(WBS模板处理方法)
	 * @param params
	 * @return 
	 * List<ScheTask>
	 * <b>创 建 人：</b>jsq<br/>
	 * <b>创建时间:</b>2020年3月13日 下午4:28:20
	 * <b>修 改 人：</b>jsq<br/>
	 * <b>修改时间:</b>2020年3月13日 下午4:28:20
	 * @since  1.0.0
	 */
	@GetMapping
	public List<ScheWbsTemp> getWbsTempData(@RequestParam Map<String, Object> params){
		return null;
	}
	
	
	
	//********************资源处理方法*************************
	/**
	 * @Title: getData
	 * @Description:(资源处理方法)
	 * @param params
	 * @return 
	 * List<ScheTask>
	 * <b>创 建 人：</b>jsq<br/>
	 * <b>创建时间:</b>2020年3月13日 下午4:28:20
	 * <b>修 改 人：</b>jsq<br/>
	 * <b>修改时间:</b>2020年3月13日 下午4:28:20
	 * @since  1.0.0
	 */
//	@GetMapping
//	public List<ScheResourceTemp> getResTempData(@RequestParam Map<String, Object> params){
//		return null;
//	}
}

