package com.zy.crm.workbench.service;

import com.zy.crm.vo.PaginationVo;
import com.zy.crm.workbench.domain.Activity;

import java.util.List;

public interface ActivityService {
    boolean save(Activity activity);

    PaginationVo<Activity> getPageList(String pageNo, String pageSize, Activity activity);

    boolean delete(String[] ids);

    Activity getAcById(String id);

    boolean update(Activity activity);

    Activity getDetailById(String id);

    List<Activity> showActivityByClueId(String id);

    List<Activity> getAcByNameAndNotBund(String name, String clueId);

    List<Activity> getAcByName(String name);
}
