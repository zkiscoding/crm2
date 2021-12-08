package com.zy.crm.listener;

import com.zy.crm.settings.domain.DicValue;
import com.zy.crm.settings.service.DicService;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.util.*;

public class SysInitListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent event){
        // 获取全局作用域对象
        ServletContext application = event.getServletContext();
        // 通过util获取spring容器
        WebApplicationContext applicationContext = WebApplicationContextUtils.getRequiredWebApplicationContext(application);
        // 通过spring获取数据字典的业务类
        DicService dicService = (DicService) applicationContext.getBean("dicServiceImpl");
        Map<String , List<DicValue>> map = dicService.getDicValue();
        Set<String> set = map.keySet();
        for(String key :set){
            application.setAttribute(key,map.get(key));
        }

        // 将阶段和可能性的映射资源文件放入上下文作用域
        ResourceBundle resourceBundle =  ResourceBundle.getBundle("Stage2Possibility");
        Set<String> keySet = resourceBundle.keySet();
        Map<String ,String> map1 = new HashMap<>();
        keySet.forEach(key -> {
            String value = resourceBundle.getString(key);
            map1.put(key,value);
        });
        application.setAttribute("pMap",map1);
    }

    @Override
    public void contextDestroyed(ServletContextEvent event) {

    }
}
