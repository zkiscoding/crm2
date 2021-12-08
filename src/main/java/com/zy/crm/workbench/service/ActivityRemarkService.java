package com.zy.crm.workbench.service;

import com.zy.crm.vo.Message;
import com.zy.crm.workbench.domain.ActivityRemark;

import java.util.List;
import java.util.Map;

/**
 * @author zy
 */
public interface ActivityRemarkService {


    List<ActivityRemark> getRemarkByAcId(String activityId);

    boolean deleteRemark(String id);
    // 查询一条备注记录
    ActivityRemark selectRemarkById(String uuid);

    Message addRemark(ActivityRemark activityRemark);

    Map<String,Object> updateRemark(ActivityRemark activityRemark);
}
