package com.zy.crm.settings.controller;

import com.zy.crm.settings.domain.DicType;
import com.zy.crm.settings.domain.DicValue;
import com.zy.crm.settings.domain.User;
import com.zy.crm.settings.service.DicService;
import com.zy.crm.settings.service.UserService;
import com.zy.crm.utils.MD5Util;
import com.zy.crm.utils.UUIDUtil;
import com.zy.crm.vo.PaginationVo;
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
public class UserController {
    @Resource
    private UserService userService;
    @Resource
    private DicService dicService;

    @RequestMapping("/settings/user/login.do")
    @ResponseBody
    public Object login(String loginAct, String loginPwd, HttpServletRequest request){
        Map<String,Object> map=new HashMap<>();
        String ip=request.getRemoteAddr();
        loginPwd= MD5Util.getMD5(loginPwd);
        try {
            User user=userService.login(loginAct,loginPwd,ip);
            request.getSession().setAttribute("user",user);
            map.put("success",true);
            return map;
        }catch (Exception e){
            e.printStackTrace();
            String msg=e.getMessage();
            map.put("success",false);
            map.put("msg",msg);
            return map;
        }

    }
    @RequestMapping("/settings/user/updatePwd.do")
    @ResponseBody
    public boolean updatePwd(HttpServletRequest request){
        String oldPwd = request.getParameter("oldPwd");
        String newPwd = request.getParameter("newPwd");
        String id = request.getParameter("id");
        oldPwd = MD5Util.getMD5(oldPwd);
        newPwd = MD5Util.getMD5(newPwd);
        Map<String,String> map = new HashMap<>();
        map.put("oldPwd",oldPwd);
        map.put("newPwd",newPwd);
        map.put("id",id);
        boolean flag = userService.updatePwd(map);
        return flag;

    }
    @RequestMapping("/settings/user/getDicTypeList.do")
    @ResponseBody
    public List<DicType> getDicTypeList(){
       List<DicType> dicTypeList = dicService.getDicTypeList();
       return dicTypeList;

    }
    @RequestMapping("/settings/user/getDicValueList.do")
    @ResponseBody
    public PaginationVo<DicValue> getDicValueList(String pageNo, String pageSize){
        PaginationVo<DicValue> paginationVo = dicService.getDicValueList(pageNo,pageSize);
        return paginationVo;

    }
    @RequestMapping("/settings/user/saveDicType.do")
    @ResponseBody
    public Object saveDicType(DicType dicType){
        Map<String,Object> map = new HashMap<>();
        try {
            boolean flag = dicService.saveDicType(dicType);
            map.put("success",flag);
            return map;
        }catch (Exception e){
            map.put("success",false);
            map.put("msg",e.getMessage());
            return map;
        }


    }
    @RequestMapping("/settings/dictionary/type/edit.do")
    @ResponseBody
    public ModelAndView getDicType(HttpServletRequest request){
        String code = request.getParameter("code");
        //System.out.println("========================="+code);
        DicType dicType = dicService.getDicType(code);
        ModelAndView mv = new ModelAndView();
        mv.addObject(dicType);
        mv.setViewName("/settings/dictionary/type/edit.jsp");
        return mv;
    }
    @RequestMapping("/settings/dictionary/type/delete.do")
    @ResponseBody
    public boolean delete(HttpServletRequest request){
        String codes[] = request.getParameterValues("code");
        boolean flag = dicService.delete(codes);
        return flag;

    }
    @RequestMapping("/settings/dictionary/type/update.do")
    @ResponseBody
    public boolean update(DicType dicType,HttpServletRequest request){
        String id = request.getParameter("id");
        String code = dicType.getCode();
        String name = dicType.getName();
        String description = dicType.getDescription();
        Map<String,Object> map = new HashMap<>();
        map.put("id",id);
        map.put("code",code);
        map.put("name",name);
        map.put("description",description);
        boolean flag = dicService.update(map);
        return flag;

    }
    @RequestMapping("/settings/dictionary/value/getDicCode.do")
    @ResponseBody
    public List<DicType> getDicCode(){
      List<DicType> dicTypeList = dicService.getDicTypeList();
      return dicTypeList;

    }
    @RequestMapping("/settings/dictionary/value/saveDicValue.do")
    @ResponseBody
    public boolean saveDicValue(DicValue dicValue){
        String id = UUIDUtil.getUUID();
        dicValue.setId(id);
        boolean flag = dicService.saveDicValue(dicValue);
        return flag;
    }
    @RequestMapping("/settings/dictionary/value/edit.do")
    @ResponseBody
    public ModelAndView getDicValue(HttpServletRequest request){
        String id = request.getParameter("id");
        //System.out.println("========================="+code);
        DicValue dicValue = dicService.getDicValueByid(id);
        ModelAndView mv = new ModelAndView();
        mv.addObject(dicValue);
        mv.setViewName("/settings/dictionary/value/edit.jsp");
        return mv;
    }
    @RequestMapping("/settings/dictionary/value/update.do")
    @ResponseBody
    public boolean update(DicValue dicValue){
        boolean flag = dicService.updatedicValue(dicValue);
        return flag;

    }
    @RequestMapping("/settings/dictionary/value/delete.do")
    @ResponseBody
    public boolean deleteValue(HttpServletRequest request){
        String ids[] = request.getParameterValues("id");
        boolean flag = dicService.deleteValue(ids);
        return flag;

    }
}
