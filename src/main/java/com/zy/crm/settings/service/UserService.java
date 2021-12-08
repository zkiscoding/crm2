package com.zy.crm.settings.service;

import com.zy.crm.settings.domain.DicType;
import com.zy.crm.settings.domain.DicValue;
import com.zy.crm.settings.domain.User;

import java.util.List;
import java.util.Map;

public interface UserService {
    User login(String loginAct, String loginPwd, String ip);

    List<User> getUserList();

    boolean updatePwd(Map<String, String> map);


}
