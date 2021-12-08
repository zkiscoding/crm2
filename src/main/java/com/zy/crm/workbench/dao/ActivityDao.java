package com.zy.crm.workbench.dao;

import com.zy.crm.workbench.domain.Activity;

import java.util.List;
import java.util.Map;


public interface ActivityDao {


    int save(Activity activity);

    int selectTotalSize(Activity activity);

    List<Activity> selectPageList(Map<String, Object> map);

    int delete(String[] ids);

    Activity getAcById(String id);

    int update(Activity activity);

    Activity getDetailById(String id);

    List<Activity> selectAcByClueId(String id);

    List<Activity> getAcByNameAndNotBund(Map<String, String> map);

    List<Activity> getAcByName(String name);
}
