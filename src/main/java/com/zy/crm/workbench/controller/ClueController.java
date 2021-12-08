package com.zy.crm.workbench.controller;

import com.zy.crm.settings.domain.User;
import com.zy.crm.settings.service.UserService;
import com.zy.crm.vo.Message;
import com.zy.crm.vo.PaginationVo;
import com.zy.crm.workbench.domain.Activity;
import com.zy.crm.workbench.domain.Clue;
import com.zy.crm.workbench.domain.ClueRemark;
import com.zy.crm.workbench.domain.Tran;
import com.zy.crm.workbench.service.ActivityService;
import com.zy.crm.workbench.service.ClueRemarkService;
import com.zy.crm.workbench.service.ClueService;
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
public class ClueController {
    @Resource
    private ClueService clueService;
    @Resource
    private UserService userService;
    @Resource
    private ActivityService activityService;
    @Resource
    private ClueRemarkService clueRemarkService;

    @RequestMapping("/workbench/clue/getUserList.do")
    @ResponseBody
    public List<User> getUserList(){
        List<User> userList = userService.getUserList();
        return userList;
    }
    @RequestMapping("/workbench/clue/save.do")
    @ResponseBody
    public boolean save(Clue clue){
        boolean flag = clueService.save(clue);
        return flag;
    }
    @RequestMapping("/workbench/clue/detail.do")
    @ResponseBody
    public ModelAndView detail(String id){
        ModelAndView mv = new ModelAndView();

        Clue c  = clueService.getClueById(id);
        mv.addObject("clue",c);
        mv.setViewName("/workbench/clue/detail.jsp");
        return mv;
    }
    @RequestMapping("/workbench/clue/getClueDetailById.do")
    @ResponseBody
    public ModelAndView getClueDetailById(String id){
        ModelAndView mv = new ModelAndView();

        Clue c  = clueService.getClueDetailById(id);
        mv.addObject("clue",c);
        mv.setViewName("/workbench/clue/detail.jsp");
        return mv;
    }
    @RequestMapping("/workbench/clue/showActivityByClueId.do")
    @ResponseBody
    public List<Activity> showActivityByClueId(String id){
        List<Activity> activityList = activityService.showActivityByClueId(id);
        return activityList;
    }
    @RequestMapping("/workbench/clue/unbund.do")
    @ResponseBody
    public boolean unbund(String id){
       boolean flag = clueService.unbund(id);
       return flag;
    }
    @RequestMapping("/workbench/clue/getAcByNameAndNotBund.do")
    @ResponseBody
    public List<Activity> getAcByNameAndNotBund(String name, String clueId){
        List<Activity> activityList = activityService.getAcByNameAndNotBund(name,clueId);
        return activityList;
    }
    @RequestMapping("/workbench/clue/bundActivityByAcIds.do")
    @ResponseBody
    public boolean bund(HttpServletRequest request){
        String ids[] = request.getParameterValues("id");
        String clueId = request.getParameter("clueId");
        boolean flag = clueService.bund(ids,clueId);
        return flag;

    }
    @RequestMapping("/workbench/clue/getAcByName.do")
    @ResponseBody
    public List<Activity> getAcByName(String name){
        List<Activity> activities = activityService.getAcByName(name);
        return activities;
    }
    @RequestMapping("/workbench/clue/convert.do")
    @ResponseBody
    public ModelAndView convert(String clueId, String flag , Tran tran, HttpServletRequest request){
        ModelAndView mv = new ModelAndView();
        User user = (User) request.getSession(false).getAttribute("user");
        String createBy = user.getName();
        // flag为0代表不需要添加交易
        // flag为1代表需要添加交易
        if("0".equals(flag)){
            tran = null;
        }
        clueService.convert(clueId,tran,createBy);

        mv.setViewName("/workbench/clue/index.jsp");
        return mv;
    }
    @RequestMapping("/workbench/clue/pageList.do")
    @ResponseBody
    public Object pageList(String pageNo, String pageSize,Clue clue){
        PaginationVo<Clue> paginationVo = clueService.getPageList(pageNo,pageSize,clue);
        return paginationVo;
    }
    @RequestMapping("/workbench/clue/getClueById.do")
    @ResponseBody
    public Map<String,Object> getClueById(String id){
        Map<String,Object> map = new HashMap<>();
        Clue clue = clueService.getClueById(id);
        List<User> userList = userService.getUserList();
        map.put("clue",clue);
        map.put("userList",userList);
        return map;

    }

    @RequestMapping("/workbench/clue/update.do")
    @ResponseBody
    public boolean update(Clue clue){
        boolean flag = clueService.update(clue);
        return flag;
    }
    @RequestMapping("/workbench/clue/delete.do")
    @ResponseBody
    public boolean delete(HttpServletRequest request){
        String ids[] = request.getParameterValues("id");
        boolean flag = clueService.delete(ids);
        return flag;
    }
    @RequestMapping("/workbench/clue/getRemarkList.do")
    @ResponseBody
    public List<ClueRemark> getRemarkList(String clueId) {
        List<ClueRemark> remarks = clueRemarkService.getRemarkList(clueId);
        return remarks;
    }
    @RequestMapping("/workbench/clue/addRemark.do")
    @ResponseBody
    public Map<String,Object> addRemark(ClueRemark clueRemark) {
        Map<String,Object> map = new HashMap<>();
        Message message = clueRemarkService.addRemark(clueRemark);
        ClueRemark cr = clueRemarkService.selectRemarkById(message.getMsg());
        map.put("success",message.getSuccess());
        map.put("ClueRemark",cr);
        return map;
    }
    @RequestMapping("/workbench/clue/updateRemark.do")
    @ResponseBody
    public Map<String,Object> updateRemark(ClueRemark clueRemark) {
        Map<String,Object> map = clueRemarkService.updateRemark(clueRemark);
        return map;
    }
    @RequestMapping("/workbench/clue/deleteRemark.do")
    @ResponseBody
    public boolean deleteRemark(String id) {
        boolean flag = clueRemarkService.deleteRemark(id);
        return flag;
    }
    @RequestMapping("/workbench/clue/gotoconvert.do")
    @ResponseBody
    public ModelAndView gotoConvert(String id){
        ModelAndView mv = new ModelAndView();
        Clue clue  = clueService.getClueDetailById(id);
        mv.addObject("clue",clue);
        mv.setViewName("/workbench/clue/convert.jsp");
        return mv;
    }

}
