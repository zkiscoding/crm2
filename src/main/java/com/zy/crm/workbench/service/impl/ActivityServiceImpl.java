package com.zy.crm.workbench.service.impl;

import com.zy.crm.utils.DateTimeUtil;
import com.zy.crm.utils.UUIDUtil;
import com.zy.crm.vo.PaginationVo;
import com.zy.crm.workbench.dao.ActivityDao;
import com.zy.crm.workbench.dao.ActivityRemarkDao;
import com.zy.crm.workbench.domain.Activity;
import com.zy.crm.workbench.service.ActivityService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ActivityServiceImpl implements ActivityService {
    @Resource
    ActivityDao activityDao;
    @Resource
    ActivityRemarkDao activityRemarkDao;

    @Override
    public boolean save(Activity activity) {
        // 创建UUID
        String uuid = UUIDUtil.getUUID();
        activity.setId(uuid);
        // 添加创建时间
        String createTime = DateTimeUtil.getSysTime();
        activity.setCreateTime(createTime);
        boolean flag = true;
        int count = activityDao.save(activity);
        if(count !=1 ){
            flag = false;
        }
        return flag;
    }

    @Override
    public PaginationVo<Activity> getPageList(String pageNo, String pageSize, Activity activity) {
        int pageNum = Integer.parseInt(pageNo);
        int pageSizes = Integer.parseInt(pageSize);
        // 根据页码查询 利用pageHelper进行分页查询
        // 第一个参数是页号 第二个参数是每页的记录条数
        int skipCount = (pageNum-1)*pageSizes;
        //PageHelper.startPage(pageNum,pageSizes);
        Map<String,Object> map = new HashMap<>();
        map.put("name",activity.getName());
        map.put("owner",activity.getOwner());
        map.put("startDate",activity.getStartDate());
        map.put("endDate",activity.getEndDate());

        map.put("skipCount",skipCount);
        map.put("pageSizes",pageSizes);

        List<Activity> activityList = activityDao.selectPageList(map);
        // 查询市场活动总条数å
        int totalSize = activityDao.selectTotalSize(activity);
        PaginationVo<Activity> paginationVo = new PaginationVo<>();
        // 利用vo封装总的记录条数和查询结果集
        paginationVo.setDataList(activityList);
        paginationVo.setTotalSize(totalSize);
        return paginationVo;
    }

    @Override
    public Activity getDetailById(String id) {
        Activity activity = activityDao.getDetailById(id);
        return activity;
    }

    @Override
    public List<Activity> showActivityByClueId(String id) {
        List<Activity> activityList = activityDao.selectAcByClueId(id);
        return activityList;
    }

    @Override
    public List<Activity> getAcByNameAndNotBund(String name, String clueId) {
        Map<String,String> map = new HashMap<>();
        map.put("name",name);
        map.put("clueId",clueId);
        List<Activity> activityList = activityDao.getAcByNameAndNotBund(map);
        return activityList;
    }

    @Override
    public List<Activity> getAcByName(String name) {
        List<Activity> activityList = activityDao.getAcByName(name);
        return activityList;
    }

    @Override
    public boolean update(Activity activity) {

        // 添加创建时间
        String editTime = DateTimeUtil.getSysTime();
        activity.setEditTime(editTime);
        boolean flag = true;
        int count = activityDao.update(activity);
        if(count !=1 ){
            flag = false;
        }
        return flag;
    }

    // 删除市场活动 可能有多个活动同时删除 所以传入数组 其次每个活动有对应的活动备注 所以要对两个表进行操作
    @Override
    @Transactional
    public boolean delete(String[] ids) {
        boolean flag = true;
        //关联的备注数量
        int count1 = activityRemarkDao.getCountByids(ids);
        //删除相应备注数量
        int count2 = activityRemarkDao.deleteByids(ids);
        if(count1!=count2){
            flag=false;
        }
        //删除市场活动
        int count3 = activityDao.delete(ids);
        if(count3!=ids.length){
            flag=false;
        }
        return flag;
    }

    @Override
    public Activity getAcById(String id) {
        Activity activity = activityDao.getAcById(id);
        return activity;
    }
}
