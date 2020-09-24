<style>
table th:first-of-type {
    width: 160px;
}
</style>
## **1. 简介**
	平台是Web服务开发运行的支撑平台，采用组件化技术，实现对程序组件化的管理与复用；基于类加载机制的组件化技术，可以轻松的实现组件在线升级；平台提供大量通用的基础组件，极大简化项目和产品的开发过程。
	1. 组件化实现，采用Java类加载技术；
	2. Ioc容器使用Spring framework ，通讯接口 REST controller;
	3. 数据库访问通过 Mybatis实现；
	4. Spring 缓存规范；
	5. slf4j日志接口规范；
	6. 通过Maven进行项目依赖管理， 实现组件打包和项目打包。
**1.1.平台总体结构图**

![总体结构](images/总体结构.png)



	平台由产品货架（组件仓库）、统一资源管理、服务中心和运行框架构成，其中运行框架是平台的核心，有内核、运行时环境和若干基础组件构成。
**1.2.应用场景**

	Fweb3.0支持典型的Web应用开发，包括信息管理系统、网站、服务端后台管理等。

**1.3. Fweb3.0技术特性**

下面的内容介绍Fweb3.0技术特性
| 特性|描述|
:-|:-
内核+组件|内核提供组件机制及组件的生命周期管理；组件来搭建业务功能； 实现灵活、可复用、任意定制的业务应用
Autoscan、AOP、IoC、事件监听|Fweb3.0基于Spring mvc5.x,支持spring的所有特性； 用于对象的生命周期管理、组件扩展等
统一配置|提供统一的配置管理，基于自动扫描，支持配置的优先级； 统一配置入口，简化管理
国际化|实现配置信息国际化的自动管理； 支持不同的语言环境下实现多语言自动切换
动态数据源|支持应用内配置多个数据源，并动态进行切换；支持动态添加、移除数据源； 用于复杂场景数据交换、集成
缓存|提供Map、Redis缓存的使用| 满足单机、集群场景
组件资源加载|加载组件声明的菜单资源，用于权限控制与页面展示； 自动加载组件资源，简化配置
热部署|平台提供组件在线管理功能，可以在运行期实现组件的加载、卸载或更新操作，不影响用户操作，组件变化可以立即生效 ； 用于在线升级维护
组件通讯|平台提供组件间交互通讯的机制，通过这个机制组件间可以实现相互的接口调用，且不会产生强依赖关系
统一日志| 通过slf4j统一接口规范提供对logback、log4j等多种日志组件的支持
||||




**1.4 常用组件**

下面是框架已经提供的组件：

| 组件名称|组件类型|功能描述|
:-|:-|:-
mybatis-dao|基础组件| 框架默认提供的数据库持久化组件，提供数据的增删改查，以及分页等，支持多种数据库类型
fweb-tools|基础组件| 各种工具，日期、集合、字符、编码、IO、反射、加密等
fweb-scheduler|基础组件| 通用的任务调度管理组件
fweb-framework-ui|基础组件| 基本UI组件，提供Bootstrap、EasyUI、jQuery等静态资源
fweb-commons-log|基础组件|日志组件，用于日志的记录、查询、分析、预警等
fweb-cache|基础组件| 缓存组件支持Map、Redis等缓存。需要业务组件依赖且打包到组件内进行使用
framework-bpm|业务组件|流程组件，流程的定义、发起、待办、流程实例管理等
fweb-commons-sort|业务组件| 字典管理，提供字段分类、树形字典数据管理
fweb-import|业务组件| 通用的Excel导入组件
fweb-security|业务组件|权限组件，用户管理、角色管理、组织结构、职位、菜单、菜单授权
||||

**1.5 发展历程**

	Fweb3.0平台是在原有Fweb2.0组件机制基础上重新设计开发的一个全新平台，平台重点在组件化机制上进行升级，实现组件的隔离与生命周期管理。


## **3. 入门篇**
    
    Fweb3.0基于Spring mvc 5.+、JDK8.+版本，开发环境推荐Eclipse 4.7+、IDEA.

### **3.1 环境准备**
	1. 平台开发运行环境基于JDK1.8, Tomcat8+;
	2. 开发工具，建议Eclipse 4.7+;    	
		建议使用Eclipse jee-oxygen2及以上版本。
		常用插件：
			1) Properties编辑器： Properties Editor;
			2) 打开资源管理器：OpenExplorer;
			3) 代码检查：Ali-CodeAnalysis(P3C , https://p3c.alibaba.com/plugin/eclipse/update)
		
	3. 配置maven

	    1)配置setting.xml
                    
            <!--配置仓库地址-->
            <repositories>
                <repository>
                <id>zj-nexus</id>
                <name>Public Repositories</name>
                <releases>
                    <enabled>true</enabled>
                    <updatePolicy>always</updatePolicy>
                    <checksumPolicy>warn</checksumPolicy>
                </releases>
                <snapshots>
                    <enabled>true</enabled>
                </snapshots>
                <url>http://nexus.365power.cn/nexus/content/groups/public/</url>
                <layout>default</layout>
            </repository>
            </repositories>
            <!--配置本地仓库目录-->
            <localRepository>H:/Lib/Amaven-3.2.2/repo/</localRepository>


	    2)在eclipse中指定setting文件：

<img src="images/setting1.png" width = "600" height = "400" alt="设置setting文件"/>

        
### **3.2. 创建项目**


1. 选择File -> New -> Maven project, 默认，点Next ;

	<img src="images/new.png" width = "600" height = "400" alt="创建maven工程"/>

2. 选择模板

	<img src="images/archetype.png" width = "600" height = "400" alt="选择工程模板"/>

3. 找不到模板时，需手工添加模板地址

	Group Id : com.hhwy.fweb

	Artifact Id : fweb-maven-archetype

	Version : 3.1.0

	Url : http://nexus.365power.cn/nexus/content/groups/public

	<img src="images/add.png" width = "600" height = "400" alt="手工添加模板地址"/>

4. 填写项目信息，创建

	<img src="images/create.png" width = "600" height = "400" alt="填写项目信息"/>

	其中Group Id是包名， Artifact Id是项目标识。

5. 完成创建
	项目创建完成以后，先执行一次maven update，之后执行maven install,
	Maven自动构建，自动组织项目结构，执行完成后即可进行设计编码工作。

### **3.3 配置**
1. 数据源配置(src/main/resources/db.properties)

		ds.driver=com.mysql.jdbc.Driver
		ds.url=jdbc:mysql://localhost/mdb?useUnicode=true&characterEncoding=UTF-8&allowMultiQueries=true
		ds.username=admin
		ds.password=fweb
		ds.validationQuery=select 6
		ds.initialSize=5
		ds.maxActive=20
		ds.removeAbandoned=true

		# 数据库类型 ORACLE , SQLSERVER ， MYSQL
		db.database=MYSQL
		
	
2. 日志配置(src/main/resources/logback.xml)
		配置日志输出的格式，各模块的日志输出级别。
	
3. maven 配置说明

	1) 项目依赖的基础组件和第三方库，通过配置pom.xml添加依赖.		
    		
	<img src="images/添加依赖.png" width = "600" height = "800" alt="添加依赖"/>

		2) 组件特有依赖配置，当组件引用了平台默认没有提供的类库时需如下配置：
		
		依赖的类库，要配置到fweb-maven-plugin插件中，类似下面：
		<plugin>
			<groupId>com.hhwy.fweb</groupId>
			......
			<includes>
				<!-- 配置组件特有依赖，GroupId:ArtifactId -->
				<include>com.hhwy.fweb:jdbc-dao</include>
			</includes>
			......
		</plugin>
		3) 打包配置
			参见第7章节。
    
### **3.4 编译与发布**

	在完成数据库配置后，就可以通过maven install对工程进行编译，编译完成后，以"项目根目录"+src/main/webapp为路径在tomcat发布应用。
	如：d:/workspace/fwebTest/src/main/webapp,作为Tomcat的一个Context进行发布。
	也可以直接发布项目根目录/target/**-version.war到Tomcat的webapps目录下。



## **4. 进阶篇（Advanced)**

### **正式开放前，请先参阅平台组件规范！**
[Fweb3.0 平台组件规范](Fweb3.0平台组件规范.md)


### **4.1 基于Fweb3.0进行开发部署的完整流程**

	基于Fweb3.0进行项目开发的环境及完整流程
	开发部署流程大致包含7个环节，具体如下：
	1. 创建工程；
	2. 配置依赖；
	3. 开发并提交代码；
	4. 本地构建自测试(或直接部署）；
	5. 发布组件Jar包；
	6. 持续集成构建；
		6.1. 持续集成下载代码；
		6.2. 持续集成加载项目依赖；
	7. 测试或生产环境部署.
	其中，2、3、4、5、6步骤在项目整个生命周期中会迭代多次。

![Fweb3.0开发部署的流程](images/开发部署环境及流程.png)


### **4.2 代码目录**

服务端代码按以下目录结构进行设计，一个典型的功能模块结构如下：

	模块目录
		//Rest接口
		-- controller
			-- XXController
		//实体定义
		-- domain
			-- XXdomain
		//业务逻辑
		-- service
			-- XXService
			-- impl
				-- XXServiceImpl
### **4.3 框架提供的主要接口**

	查看全部API，请参考单独的API文档。此处只对典型的接口使用进行说明。
	下面列举了框架提供的主要接口：

1. spring容器接口

		ContainerHelper是平台提供访问容器的工具。通过ContainerHelper可以获取容器中管理的service对象。
		
		主要接口包括：

		1) 根据类型获取bean: <T> T getBean(Class<?> clazz );

		2) 根据名称(id)获取bean: <T> T getBean(String name );

		3) 获取指定组件的bean: <T> T getBean(String name, String pluginName);

		4) 根据类型获取主容器的bean: <T> T getBeanFromMainContainer(Class<?> clazz);

		5) 根据名称(id)获取主容器的bean: <T> T getBeanFromMainContainer(String name);

		6) 根据类型获取指定组件的bean: <T> T getBean(Class<?> clazz, String pluginName);

		7) 获取组件的资源（jar包中的文件）：Resource getResource(String resourcePath, String pluginName);

		8) 获取组件的资源（jar包中的文件）:Resource getResource(String resourcePath);

		9) 按注解类型获取组件的beans: Map<String, Object> getBeansByType(String pluginName, Class<? extends Annotation> clazz);

		10) 获取组件管理的service: <T> T getPluginService();

		11) 获取组件的全部beans: String[] getAllBeans(String pluginName);

		12) 判断组件容器是否包含指定id的bean: boolean contains(String name, String pluginName);

		13) 刷新静态资源映射（用于组件加载、卸载时）：void refreshResourceMapping();
		14) 获取组件的类加载器： ClassLoader getPluginClassloader();
	
		15) 获取组件的容器： ApplicationContext getContext(String pluginName);
2. 配置信息接口

		配置信息可以通过两种方式获取，一种是通过Value注解，例如：
		@Value("#{pluginProps['crosscomponent.title']}")
		String title = null;
		另外一种是通过工具，ConfigHelper是平台提供的访问配置信息的工具。
		通过ConfigHelper可以获取平台已经加载的配置信息（即所有满足config/**/*-config.properties）。
		主要接口包括：
		1) 获取静态路径：String ui();
		2) 获取服务端地址：String path();
		3) 获取页面地址： String page();
		4) 获取配置且替换信息内容：String getConfig(String key, String... args)，其中key是配置项的key， args是需要替换的信息;
		5) 获取配置信息：<T> T getConfig(String key);
		
3. 国际化消息接口

		MessageHelper是平台提供的服务端获取国际化消息的工具。
		主要接口：
		1) String getMessage(String code, Object[] args);
		2) String getMessage(String code);
		3) String getMessage(String code, Object[] args,Locale locale);
4. 框架提供的注解

		1) 声明组件对外开放的接口：CommonService;
			参数：
				name ： 接口名称；
				desc : 接口描述。
		2) 声明跨组件接口调用：Plugin
			用法：声明一个CrossService变量， 在变量上添加Plugin注解，用name指定要调用的接口对象的bean Id。
			参数：
				name：其他组件接口对象的bean Id;
		3) 接口描述：Function
			用以生成接口信息列表，以便进行接口信息查询、权限注册等。
			用法： 用在Controller类和方法上，描述接口的编号、名称、功能描述、类型和权限标识。
			参数：
			  	code: 接口编号；
				name: 接口名称；
				desc: 接口功能描述；
				tag: 权限标识；
				type: 功能类型，如增删改查等。 

5. id生成器

		PlatformTools平台提供的32位UUID生成器，用于数据Id的生成。
		主要接口：
		1) 生成32位UUID : String getID();
		
6. REST api访问接口

		RestService是平台提供的服务端调用REST接口的工具，通过RestService可以执行get、post、put、delete类型的REST接口.

7. 请求级参数共享

		在同一个请求范围内，不同模块之间共享（传递）参数的接口：com.hhwy.fweb.framework.api.commons.ContextParameters;
		其中的set（设置）方法有两个参数：共享参数名（String）和参数值（Object);
		get（获取）方法一个参数：共享参数名（String);
		remove（移除）方法一个参数：共享参数名（String);

8. 数据访问

		1. service实现类，用@Component声明service；
		2. 声明dao成员变量，例如：
			@Autowired
			MybatisDao dao;
		3. 通过dao进行数据操作，例如：
			Object u = dao.getOne("sqlkey", paramMap);

		4. MybatisDao的方法

		MybatisDao是基于Mybatis持久化框架进行封装的访问数据库的通用接口，包括了增删改查、分页等接口。
		
		具体用法如下：
		1) 定义数据操作的sql
		在resouces/config/maps/目录下，配置*-mapper.xml的文件，并定义业务相关的sql语句。

		例如resouces/config/maps/demo-mapper.xml：
		<mapper namespace="demo.sql">
			<select id="muser" resultType="cn.demo.usersmtable.domain.MUser"
				databaseId="mysql">
				select id ,  login_name loginName, user_name userName, sex, email, mobile,
				(select count(*) from demo_user_role ur where ur.user_id=a.id)roles from demo_user a
			</select>
		</mapper>

		其中：namespace和select的id构成了引用这个sql语句的key;databaseId定义了sql是针对哪种数据库的，如果sql没有数据库类型的差异，则不需要定义databaseId。
		
		2) 在ServiceImpl中定义MybatisDao的引用
		用@Autowire注解声明MybatisDao变量，实现MybatisDao的注入。

		3) 在Service方法中调用MybatisDao接口
		具体接口如下：
		/**
		* getOne: 查询单个结果<br/>
		* @param sqlKey
		* @param params
		* @return 
		* T
		* @exception 
		* @since  1.0.0
		*/
		<T>T getOne( String sqlKey, Map<String,Object> params);

		/**
		* getOne: 查询单个结果<br/>
		* @param sqlKey
		* @param parameter
		* @return 
		* T
		* @exception 
		* @since  1.0.0
		*/
		<T>T getOne( String sqlKey, Object parameter);

		/**
		* get: 查询list结果<br/>
		* @param sqlId
		* @param params
		* @return 
		* List<E>
		* @exception 
		* @since  1.0.0
		*/
		List<E> get(String sqlKey, Map<String, Object> params);
		List<E> get(String sqlKey, Object parameter);

		/**
		* page: 进行分页查询<br/>
		* @param sqlKey
		* @param parameter
		* @return 
		* QueryResult<?>
		* @exception 
		* @since  1.0.0
		*/
		QueryResult<?> page(String sqlKey, Map<Object, Object> parameter);

		/**
		* execute： 执行新增操作<br/>
		* @param sqlKey
		* @param params
		* @return 
		* int
		* @exception 
		* @since  1.0.0
		*/
		int save(String sqlKey, Object parameter);	
		
		/**
		* update ： 更新操作<br/>
		* @param sqlKey
		* @param dat
		* st
		* @return 
		* int
		* @exception 
		* @since  1.0.0
		*/
		int update(String sqlKey , Object parameter);

		/**
		* delete：删除数据<br/>
		* @param sqlKey
		* @param parameter
		* @return 
		* int
		* @exception 
		* @since  1.0.0
		*/
		int delete(String sqlKey , Object parameter);
9.  Spring对象管理接口
		
		ManagerHelper是组件管理接口，用于管理组件的加载、卸载等。
	    /**
		*获取组件信息
		*@param  pluginId 组件编号
		* @return 
        * Map<String,String>
		*/        
        Map<String,String> getPluginInfo(String pluginId);

        /**
         * getPluginInfo: 获取组件信息<br/>
         * @param pluginId 组件编号
         * @return 
         * Map<String,Object>
         * @exception 
         * @since  1.0.0
         */
        String getPluginType(String pluginId);
        /**
         * loadPlugin: 初始化指定插件<br/>
         * @param pluginId 组件编号
         * @return
         * @throws IOException 
         * boolean
         * @exception 
         * @since  1.0.0
         */
        boolean loadPlugin(String pluginId) throws Exception;
        
        /**
         * unloadPlugins: 卸载全部插件<br/>
         * @throws IOException 
         * void
         * @exception 
         * @since  1.0.0
         */
        void unloadPlugins() throws IOException ;
        
        /**
         * unloadPlugin: 卸载插件<br/>
         * @param pluginId 组件编号
         * @throws IOException 
         * void
         * @exception 
         * @since  1.0.0
         */
        void unloadPlugin(String pluginId) throws IOException;
        
        /**
         * updatePlugin: 更新组件. 卸载已经安装的组件，并安装指定版本的组件<br/>
         * @param pluginInfo
         * @throws IOException 
         * void
         * @exception 
         * @since  1.0.0
         */
        void updatePlugin(Object newPlugin) throws Exception;
        /***
         * 判断插件是否已经加载
         * @param pluginId 组件编号
         * @return
         */
        boolean contains(String pluginId);
        
        /**
         * isBasePlugin: 判断是否基础组件<br/>
         * @param pluginId 组件编号
         * @return 
         * boolean
         * @exception 
         * @since  1.0.0
         */
        boolean isBasePlugin(String pluginId);        
		
		 /**
         * isBasePlugin:获取组件的启动时间<br/>
         * @param pluginId 组件编号
         * @return 
         * Map<String , Long>
         * @exception 
         * @since  1.0.0
         */
		Map<String , Long> getPluginStartTime();
		
		/**
		* 
		* 功能:获取指定插件启动时间
		* @param  pluginId 组件编号
		* @return
		*/
		Long getPluginStartTiemByPluginId(String pluginId);



### **4.4 典型功能**

1) 事务的使用

		在需要使用事务的service方法上加注解@Transactional.
		并声明需要回滚的异常类型。
		例如：
		@Transactional(rollbackFor=SQLException.class)
		public void update(String sql, Object[] args) 
2) 缓存的使用
	 
		使用平台的统一缓存管理器进行缓存的存取设置，缓存的更新策略由具体业务确定。

	 **一、缓存配置**

   	 	1） 配置
			在resources/config/*-mvc.xml中配置配置缓存对象。可以同时配置多个缓存.
			
		配置示例

		例如：
		<!-- 缓存配置示例 -->
		<bean id="authenticationCache" class="com.hhwy.fweb.cache.FwebCacheProxy" 
							p:database="1"
							p:liveTime="1800"/>
		其中：
			id是bean的名字，也是缓存的名字，在注入或者通过注解使用缓存时使用；
			class是缓存的代理类FwebCacheProxy， 可以根据配置自动切换;
			p:database只针对Redis，指示使用Redis中库的序号；
			p:liveTime只针对Redis，设置对象缓存存活的周期。

		2） 缓存类型配置
		在common-config.properties中配置
		#提供两种缓存，default (HashMap，用于单机应用)和 redis (用于单机或集群）
		fweb.cache.type=default


	**二、使用缓存的方式**

		在Fweb3.0中使用缓存，有两种方式：
		一、通过注解使用缓存
			1) 在类上用@CacheConfig(cacheNames="缓存名称", cacheManager="cacheManager")配置使用的缓存名称。
			2) 加入缓存时，在相应的方法上用@Cacheable(key="#缓存key")存入缓存，其中key为方法传入的参数；返回值为缓存的对象；
			3) 更新/清除缓存时，在方法上用@CacheEvict( key="#缓存key")清除缓存，其中key为方法参数；

		二、注入缓存对象
			通过@Resource("beanId") FwebCache cache;


		三、通过工具类使用缓存
			com.hhwy.fweb.cache.CacheManagerHelper
			工具类的方法包括：
			1) 获取缓存管理器：CacheManager getCacheManager()；
			2) 获取缓存FwebCache getCache(String name);
			3) 获取缓存的keys :Set<Object> getKeys(String cacheName);
			4) 获取指定前缀的keys: Set<Object> getKeys(String cacheName , String prefix);
			5) 移除缓存：void remove(String cacheName , Collection<String> keys)；
			
			存入和取出
			 1) 把对象加入到缓存中：
			 CacheManagerHelper.getCache(cacheName).put(key, value);
			 2) 获取一个对象的缓存：
			 CacheManagerHelper.getCache(cacheName).get(key)； 
			 3) 把对象从缓存中移除：
			 CacheManagerHelper.getCache(cacheName).evict(key);
			 4) 清空缓存（慎用，尽量使用remove方法移除指定的keys）：
			 CacheManagerHelper.getCache(cacheName).clear();
		注意：
		    缓存的“key”会自动添加缓存名称为前缀，key在一个项目中必须确保是唯一的，否则可能会出现缓存数据混乱。


3) 组件间接口调用
		
		组件间接口调用指业务组件之间的相互调用，
		1. 声明开放的接口
			在需要开放的接口类上使用注解@CommonService， 只有带有注解@CommonService的类才能被其他业务组件调用。

		2. 声明接口调用
			接口的调用方，必须是spirng容器管理的对象，如controller,service等；
			//业务组件间接口调用
			@Plugin(name="neo4j")
			@Autowired
			CrossService neo4jService;
			其中变量名“neo4jService”必须与接口声明的bean Id保持一致。
		3. 调用接口
			Object obj = neo4jService.apply("getTitle", args);
			其中"getTitle"是要调用方法名，args是方法的实参。
4) 异常的处理

		在Service和Controller中所有的异常都通过throw 抛出，由框架统一处理。
5) 日志的使用

		1. 声明日志对象变量：
				org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(UserServiceImpl.class);
		2. 根据需要输出日志信息， 如：
				log.info("查询用户信息，返回数据"+size);
		

6) 数据源切换

		DynamicDSHelper是平台提供的数据源切换工具，通过动态切换不同的数据源，实现一个请求中操作多个数据库的场景。
		主要接口：
		1) 切换到指定数据源：switchDatasource(String dsName)；
			其中dsName是目标数据源的名称。
		2) 获取当前数据源名称：String getCurrentDatasourceName();
		3) 获取当前数据源对象：DynamicDataSource getCurrentDatasource();
		4) 清除数据源设置，恢复默认数据源：clear() ;
		5) 动态增加一个数据源：addDataSource(String dsName , DataSource ds);
7)	插件数据源

		平台支持每个插件单独使用自己的数据源。具体配置参考如下：
		1.插件工程的pom.xml的properties里面配置：
			<datasource>ds-common-sort</datasource>
		2.主工程的main-config.xml配置数据源bean ：
			<bean id="ds1" class="com.alibaba.druid.pool.DruidDataSource"
				destroy-method="close">，参照默认数据源
		3.在主工程的main-config.xml配置中添加数据源，并且把数据源名称写到dataSourceMap里面，
			<!-- 数据源池 -->
			<bean id="dataSourceMap" class="java.util.WeakHashMap">
			<constructor-arg><map><entry key="ds-common-sort"  key-ref="ds1"/></map></constructor-arg>
			</bean>

8)  组件自定义过滤器

		实现com.hhwy.fweb.framework.api.commons.FwebFilter接口类，框架会自动扫描加入到过滤器链中，实现全局过滤器的功能。

9)  容器加载事件监听

		实现 com.hhwy.fweb.framework.api.commons.FwebContainerListener接口，框架会自动加入到容器监听列表中，在发生组件加载、卸载事件时，监听器会接收到响应的事件，通过事件可以获取加卸载的组件容器对象。
		业务可以据此实现相应的业务逻辑。

		接口的两个方法：

		/**
		* onStartEvent: 容器启动事件，在组件加载是触发<br>
		* @param event 
		* void
		* @exception 
		* @since  1.0.0
		*/
		void onStartEvent(ApplicationEvent event) ;
		/**
		* onSopEvent: 容器停止事件，在组件卸载时触发<br>
		* @param event 
		* void
		* @exception 
		* @since  1.0.0
		*/
		void onStopEvent(ApplicationEvent event) ;

		列如：
			可以通过自定义容器监听器实现通用的组件脚本初始化功能。
	


## **5 组件管理**

### **5.1 组件上传发布**
	
	在项目开发过程中，或者项目开发完成以后，项目代码可以组件的形式发布到组件仓库中。
	具体操作如下：
	1. 在maven的setting.xml文件中配置仓库管理账户；
	2. 在项目的pom.xml中指定仓库地址，参考：
	<!-- 组件打包用的插件仓库 -->
	<pluginRepositories>
		<pluginRepository>
			<id>waf-snapshot</id>
			<name>waf-snapshot</name>
			<url>http://192.168.20.11:8081/nexus/content/repositories/snapshots</url>
			<snapshots>
				<enabled>true</enabled>
			</snapshots>
		</pluginRepository>
		<pluginRepository>
			<id>waf-milestones</id>
			<name>waf Milestones</name>
			<url>http://192.168.20.11:8081/nexus/content/repositories/releases/</url>
			<snapshots>
				<enabled>false</enabled>
			</snapshots>
		</pluginRepository>
	</pluginRepositories>
	3. 在项目上点击右键， 选择Run As --> Maven Build;
	4. 执行deploy

<img src="images/组件发布.png" width = "800" height = "500" alt="组件发布"/>

    输入“deploy” ， 点击“run”按钮进行发布。

### **5.2 组件管理**
	1. 组件管理的地址：
	    /view/fweb-framework-mvc/core/index
<img src="images/组件管理.png" width = "800" height = "450" alt="组件管理"/>

	2. 组件管理功能：
	    提供了组件的在线安装（或上传），启用、停用、参数设置、组件删除等功能，可以实现运行期组件的维护，不影响系统的正常运行。在组件管理中可以对组件的组件的启动顺序、是否延迟加载进行设置。
	    2.1 在线安装
		点击“仓库下载”:

<img src="images/仓库下载.png" width = "800" height = "400" alt="仓库下载"/>

	    
	初次进入“仓库下载”，需要配置maven nexus仓库地址，配置完成后点击“加载仓库组件列表”即可拉取仓库中的组件信息。
	在“仓库下载”中可以下载新的组件，可以对系统中已有组件进行更新，也可以用旧版本组件替换系统中已经安装的新版组件。
	    2.2 组件升级
	查看“仓库下载”中的组件列表，在操作列显示为“更新”的就是可以更新的组件，点击即可完成组件的更新。
	    2.3 恢复旧版本
	当新版本组件不能满足需要，需恢复旧版本时，可以在“仓库下载”页面选择相应组建的较早版本，点击“安装旧版”按钮恢复旧版本。
	    2.4 并行开发
	在团队开发中，不同开发人员使用相同的数据库地址时，会出现部分开发人员安装了组件，部分人员没有安装的情况，这时，未安装组件的系统上可以在“仓库下载”页面中看到红色字体的“安装”按钮，点击即可完成组件在本地系统的安装。

## **6. 常见问题**
[可选] [文件] 常见问题解答
1. MANIFEST.MF文件找不到

		问题：
			应用启动时报“java.io.FileNotFoundException: C:\apache-tomcat-8.0.15\webapps\pms\WEB-INF\classes\META-INF\MANIFEST.MF (系统找不到指定的文件。)”

		解决： 
			使用平台提供的maven插件hhwy-maven-plugin进行编译打包。

2. 找不到hhwy-maven-plugin插件

		问题：
			执行mvn build或maven install时报错，提示找不到hhwy-maven-plugin插件

		解决：
			1) 先从工程的pom.xml去掉<plugin>...</plugin>标签;
			2) 执行一次maven install,执行成功；
			3) 重新添加刚去掉的<plugin>...</plugin>标签;
			4) 再次执行maven build或 maven install.

## **7. 附录**

### **7.1 名词解释**
[可选] [文件] 名词解释
### **7.2 最佳实践**
[可选] [文件] 最佳实践
### **7.3 版本日志**
[可选] [文件] 版本说明
### **7.4 反馈方式**
[可选] [文件] 反馈方式



### **7.5 性能测试记录**
#### **测试环境**

	测试环境配置为一台应用服务器，一台数据库服务器，一台缓存服务器，配置如下：

|应用服务器||
:-|:-
| 硬件  | CPU：至强E5-2680 v3 @ 2.50GHz  4核  内存：16G 硬盘：100G |
|软件|操作系统：CenOS7  Java运行环境：jdk8.U121  分配内存8GB <br>apache-tomcat-8.5.20  线程数200000<br> 应用数据库连接池最大连接数：15000 <br>操作系统最大文件数794000 |
|

|数据库服务器||
:-|:-
| 硬件  | CPU：至强E5-2680 v3 @ 2.50GHz  4核  内存：16G 硬盘：100G |
|软件|操作系统：CenOS7  数据库：mysql-community-server 5.7.11 <br>最大允许连接80000 操作系统最大文件数794000 |
|

|缓存服务器||
:-|:-
| 硬件  | CPU：至强E5-2680 v3 @ 2.50GHz  4核  内存：16G 硬盘：100G |
|软件|操作系统：CenOS7  <br> Docker <br>缓存：Redis <br>操作系统最大文件数794000  |
|


#### **压测环境**

	压测环境配置为一台Loadrunner控制台，三台负载生成器，配置如下：

|Loadrunner控制台||
:-|:-
| 硬件  | CPU：至强E5-2680 v3 @ 2.50GHz  4核  内存：16G 硬盘：100G |
|软件|操作系统：Win  7 旗舰版 64位 ；压测工具：  LoadRunner 11  |
|||

|Loadrunner负载生成器1||
:-|:-
| 硬件  | CPU：至强E5-2680 v3 @ 2.50GHz  4核  内存：16G 硬盘：100G |
|软件|操作系统：Win  7 旗舰版 64位 ；压测工具：  LoadRunner 11  |
|

|Loadrunner负载生成器2||
:-|:-
| 硬件  | CPU：至强E5-2680 v3 @ 2.50GHz  4核  内存：16G 硬盘：100G |
|软件|操作系统：Win  7 旗舰版 64位 ；压测工具：  LoadRunner 11  |
|

|Loadrunner负载生成器3||
:-|:-
| 硬件  | CPU：至强E5-2680 v3 @ 2.50GHz  4核  内存：16G 硬盘：100G |
|软件|操作系统：CenOS7 ；压测工具：  LoadRunner 11  |
|



#### **7.5.1 测试内容**
    性能测试的内容包括：
    1. 单表分页查询
        数据量16W以上；
        数据量100W以上,使用缓存；
        数据量2000W以上,使用缓存；
    2. 多表连接分页查询
	    两表连接查询，数据量16W以上；
    3. 数据单项增删改
	    单表数据修改；
    4. 跨组件接口调用
	    数据分页查询；
	    读取配置信息；
    
#### **7.5.2 测试结果**
1.评估总结

	    单台服务器时，单接口在并发10000人情况下毫无压力，接口性能良好。平台能力（所有接口）在3000虚拟用户运行30分钟时，响应时间在可接受范围内，超过此虚拟人数平台体验较差。
	    验证了平台稳定性，运行时长为1小时、2小时、24小时，并发用户10000，平台服务未出现停止、崩溃、内存溢出等现象。	
	    验证平台持续稳定性，在24小时内进行2.1万次组件加载与卸载，同时进行100线程并发访问，平台服务未出现停止、崩溃、内存溢出等现象。


|运行人数|吞吐量（TPS）| 平均响应时间（秒：s)|事务通过率|运行时长(分钟：min)|
:-|:-|:-|:-|:-
|1000|818.9|0.4|100|30|
|1500|1197|0.97|100|30|
|1600|1278|1.1|100|30|
|1800|909|1.8|100|30|
|2000|913.8|2.0|100|30|
|3000|737.2|3.6|99.8|30|
|5000|744.8|5.8|99.3|30|
|10000|997|8.4|98.8|30|
|

	另外，用Jmeter3.3进行多批次压测，每次4小时以上，结果如下：

|并发线程数|吞吐量（TPS）| 平均响应时间（秒：s)|事务通过率|运行时长(分钟：min)|
:-|:-|:-|:-|:-
|100|4500|0.1|100|240|
|

2. 支持最大在线用户数测算

		1)计算平均的并发用户数的公式： C = nL/T 
		其中C是平均的并发用户数；n是活动用户的数量；L是操作时长（秒）；T指考察的时间段长度（秒）。
		
		以每用户操作（增删改查）15分钟，并发1500用户(经测试1500~1600并发用户是响应效率最高)，考察时间8小时计算，由公式反推：

		1500 = n * 15 * 60 /8*3600 , 则n=48000，即每个应用服务器容纳的活动用户数48000时，用户体验较好。