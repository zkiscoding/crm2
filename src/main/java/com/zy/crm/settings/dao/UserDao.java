package com.zy.crm.settings.dao;

import com.zy.crm.settings.domain.User;

import java.util.List;
import java.util.Map;

public interface UserDao {

    User login(User user);

    List<User> getUserList();

    int updatePwd(Map<String, String> map);
}
