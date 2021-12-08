package com.zy.crm.workbench.controller;

import com.zy.crm.settings.domain.User;
import com.zy.crm.settings.service.UserService;
import com.zy.crm.vo.Message;
import com.zy.crm.vo.PaginationVo;
import com.zy.crm.workbench.domain.Activity;
import com.zy.crm.workbench.domain.ActivityRemark;
import com.zy.crm.workbench.service.ActivityRemarkService;
import com.zy.crm.workbench.service.ActivityService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class ActivityController {
    @Resource
    private UserService userService;
    @Resource
    private ActivityService activityService;
    @Resource
    private ActivityRemarkService activityRemarkService;

    @RequestMapping("/workbench/activity/getUserList.do")
    @ResponseBody
    public List<User> getUserList(){
        List<User> users = userService.getUserList();
        return users;
    }
    @RequestMapping("/workbench/activity/save.do")
    @ResponseBody
    public boolean save(Activity activity){
        boolean msg = activityService.save(activity);
        return msg;
    }
    @RequestMapping("/workbench/activity/pageList.do")
    @ResponseBody
    // 拿到页码和页面记录条数
    public Object getPageList(String pageNo, String pageSize,Activity activity){
        PaginationVo<Activity> paginationVo = activityService.getPageList(pageNo,pageSize,activity);
        return paginationVo;
    }
    @RequestMapping("/workbench/activity/delete.do")
    @ResponseBody
    public boolean delete(HttpServletRequest request){
        String ids[] = request.getParameterValues("id");
        boolean flag = activityService.delete(ids);
        return flag;
    }
    @RequestMapping("/workbench/activity/getAcById.do")
    @ResponseBody
    public Map<String,Object> getAcById(String id){
        Map<String,Object> map = new HashMap<>();
        Activity activity = activityService.getAcById(id);
        List<User> userList = userService.getUserList();
        map.put("activity",activity);
        map.put("userList",userList);
        return map;

    }
    @RequestMapping("/workbench/activity/update.do")
    @ResponseBody
    public boolean update(Activity activity){
        boolean msg = activityService.update(activity);
        return msg;
    }
    // 显示市场活动detail.jsp页面
    @RequestMapping("/workbench/activity/detail.do")
    public ModelAndView showDetail(String id) {
        ModelAndView mv = new ModelAndView();
        // 根据id获取activity
        Activity activity = activityService.getDetailById(id);
        mv.addObject("activity", activity);
        mv.setViewName("/workbench/activity/detail.jsp");
        return mv;
    }
    @RequestMapping("/workbench/activity/getRemarkList.do")
    @ResponseBody
    public List<ActivityRemark> getRemarkByAcId(String activityId) {
        List<ActivityRemark> remarks = activityRemarkService.getRemarkByAcId(activityId);
        return remarks;
    }
    @RequestMapping("/workbench/activity/deleteRemark.do")
    @ResponseBody
    public boolean deleteRemark(String id) {
        boolean flag = activityRemarkService.deleteRemark(id);
        return flag;
    }
    @RequestMapping("/workbench/activity/addRemark.do")
    @ResponseBody
    public Map<String,Object> addRemark(ActivityRemark activityRemark) {
        Map<String,Object> map = new HashMap<>();
        Message message = activityRemarkService.addRemark(activityRemark);
        ActivityRemark ar = activityRemarkService.selectRemarkById(message.getMsg());
        map.put("success",message.getSuccess());
        map.put("ActivityRemark",ar);
        return map;
    }
    @RequestMapping("/workbench/activity/updateRemark.do")
    @ResponseBody
    public Map<String,Object> updateRemark(ActivityRemark activityRemark) {
        Map<String,Object> map = activityRemarkService.updateRemark(activityRemark);
        return map;
    }
}
