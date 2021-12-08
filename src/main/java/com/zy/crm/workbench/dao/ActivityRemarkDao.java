package com.zy.crm.workbench.dao;

import com.zy.crm.workbench.domain.ActivityRemark;

import java.util.List;

/**
 * @author zy
 */
public interface ActivityRemarkDao {

    int deleteByids(String[] ids);

    int getCountByids(String[] ids);

    List<ActivityRemark> selectRemarkByAcId(String activityId);

    int deleteRemark(String id);

    int addRemark(ActivityRemark activityRemark);

    ActivityRemark selectRemarkById(String id);

    int updateRemark(ActivityRemark activityRemark);
}
