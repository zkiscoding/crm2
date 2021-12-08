package com.zy.crm.workbench.service.impl;

import com.zy.crm.utils.DateTimeUtil;
import com.zy.crm.utils.UUIDUtil;
import com.zy.crm.vo.Message;
import com.zy.crm.workbench.dao.ClueRemarkDao;
import com.zy.crm.workbench.domain.ClueRemark;
import com.zy.crm.workbench.service.ClueRemarkService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author zy
 */
@Service
public class ClueRemarkServiceImpl implements ClueRemarkService {

    @Resource
    private ClueRemarkDao clueRemarkDao;

    @Override
    public List<ClueRemark> getRemarkList(String clueId) {
        List<ClueRemark> clueRemarkList = clueRemarkDao.getRemarkList(clueId);
        return clueRemarkList;
    }

    @Override
    public ClueRemark selectRemarkById(String msg) {
       ClueRemark clueRemark = clueRemarkDao.selectRemarkById(msg);
       return clueRemark;
    }

    @Override
    public Map<String, Object> updateRemark(ClueRemark clueRemark) {
        Map<String,Object> map = new HashMap<>();
        boolean flag = false;
        clueRemark.setEditFlag("1");
        clueRemark.setEditTime(DateTimeUtil.getSysTime());
        int count = clueRemarkDao.updateRemark(clueRemark);
        if(count==1){
            flag = true;
            map.put("cr",clueRemark);
        }
        map.put("success",flag);
        return map;
    }

    @Override
    public boolean deleteRemark(String id) {
        boolean flag = false;
        int count = clueRemarkDao.deleteRemark(id);
        if(count==1){
            flag = true;
        }
        return flag;
    }

    @Override
    public Message addRemark(ClueRemark clueRemark) {
        Message message = new Message();
        boolean success = false;
        clueRemark.setCreateTime(DateTimeUtil.getSysTime());
        clueRemark.setEditFlag("0");
        String uuid = UUIDUtil.getUUID();
        clueRemark.setId(uuid);

        int result = clueRemarkDao.addRemark(clueRemark);
        if (result == 1){
            success = true;
        }
        message.setSuccess(success);
        message.setMsg(uuid);

        return message;
    }


}

