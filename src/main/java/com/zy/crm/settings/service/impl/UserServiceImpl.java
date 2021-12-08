package com.zy.crm.settings.service.impl;

import com.zy.crm.exception.LoginFailException;
import com.zy.crm.settings.dao.UserDao;
import com.zy.crm.settings.domain.User;
import com.zy.crm.settings.service.UserService;
import com.zy.crm.utils.DateTimeUtil;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Service
public class UserServiceImpl implements UserService {
    // UserDao层对象 通过Resource byName赋值
    @Resource
    private UserDao userDao;


    @Override
    public User login(String loginAct, String loginPwd, String ip) {
        User user = new User();
        user.setLoginAct(loginAct);
        user.setLoginPwd(loginPwd);
        user=userDao.login(user);
        //shiro 　swagger
        //System.out.println(user);
        if (user==null){
            throw new LoginFailException("账号密码错误");

        }else if(DateTimeUtil.getSysTime().compareTo(user.getExpireTime())>0){
            throw new LoginFailException("账号已失效");
        }else if("0".equals(user.getLockState())) {
            throw new LoginFailException("账号已锁定");
        }
//        }else if(!user.getAllowIps().contains(ip)){
//            throw new LoginFailException("访问主机无权限，以阻止访问");
//        }
        return user;

    }

    @Override
    public List<User> getUserList() {
        List<User> users = userDao.getUserList();
        return users;
    }

    @Override
    public boolean updatePwd(Map<String, String> map) {
        boolean flag = true;
        int count = userDao.updatePwd(map);
        if(count!=1){
            flag = false;
        }
        return flag;
    }




}
