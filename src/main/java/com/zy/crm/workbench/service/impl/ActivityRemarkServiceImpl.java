package com.zy.crm.workbench.service.impl;

import com.zy.crm.utils.DateTimeUtil;
import com.zy.crm.utils.UUIDUtil;
import com.zy.crm.vo.Message;
import com.zy.crm.workbench.dao.ActivityRemarkDao;
import com.zy.crm.workbench.domain.ActivityRemark;
import com.zy.crm.workbench.service.ActivityRemarkService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author zy
 */
@Service
public class ActivityRemarkServiceImpl implements ActivityRemarkService {

    @Resource
    private ActivityRemarkDao activityRemarkDao;
    @Override
    public List<ActivityRemark> getRemarkByAcId(String activityId) {
        List<ActivityRemark> remark = activityRemarkDao.selectRemarkByAcId(activityId);
        return remark;
    }

    @Override
    public boolean deleteRemark(String id) {
        boolean flag = false;
        int count = activityRemarkDao.deleteRemark(id);
        if(count==1){
            flag = true;
        }
        return flag;
    }

    @Override
    public ActivityRemark selectRemarkById(String uuid) {
        ActivityRemark remark = activityRemarkDao.selectRemarkById(uuid);

        return remark;
    }


    @Override
    public  Map<String,Object> updateRemark(ActivityRemark activityRemark) {
        Map<String,Object> map = new HashMap<>();
        boolean flag = false;
        activityRemark.setEditFlag("1");
        activityRemark.setEditTime(DateTimeUtil.getSysTime());
        int count = activityRemarkDao.updateRemark(activityRemark);
        if(count==1){
            flag = true;
            map.put("ar",activityRemark);
        }
        map.put("success",flag);
        return map;
    }

    @Override
    public Message addRemark(ActivityRemark activityRemark) {
        Message message = new Message();
        boolean success = false;
        activityRemark.setCreateTime(DateTimeUtil.getSysTime());
        activityRemark.setEditFlag("0");
        String uuid = UUIDUtil.getUUID();
        activityRemark.setId(uuid);

        int result = activityRemarkDao.addRemark(activityRemark);
        if (result == 1){
            success = true;
        }
        message.setSuccess(success);
        message.setMsg(uuid);

        return message;
    }
}

