package com.zy.crm.workbench.controller;

import com.zy.crm.settings.domain.User;
import com.zy.crm.settings.service.UserService;
import com.zy.crm.vo.PaginationVo;
import com.zy.crm.workbench.domain.Tran;
import com.zy.crm.workbench.domain.TranHistory;
import com.zy.crm.workbench.service.CustomerService;
import com.zy.crm.workbench.service.TranService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

/**
 * @author zy
 */

@Controller
@RequestMapping("/workbench/transaction")
public class TranController {

    @Resource
    private TranService tranService;

    @Resource
    private UserService userService;

    @Resource
    private CustomerService customerService;

    /*
        跳转到添加页面之前先走后台取userList数据
     */
    @RequestMapping("/add.do")
    public ModelAndView addJsp(){

        ModelAndView mv = new ModelAndView();

        List<User> userList = userService.getUserList();

        mv.addObject("userList",userList);

        mv.setViewName("/workbench/transaction/save.jsp");
        return mv;
    }

    @RequestMapping("/getCustomerName.do")
    @ResponseBody
    public List<String> getCustomerName(String name){
        List<String> nameList = customerService.getCustomerName(name);
        return nameList;
    }
    @RequestMapping("/getTranList.do")
    @ResponseBody
    public List<Tran> getTranList(){
        List<Tran> tranList = tranService.getTranList();
        return tranList;
    }
    @RequestMapping("/saveTran.do")
    public ModelAndView saveTran(Tran tran, String customerName){
        ModelAndView mv = new ModelAndView();
        int result = 0;

        result = tranService.saveTran(tran , customerName);

        mv.setViewName("redirect:/workbench/transaction/index.jsp");

        return mv;
    }
    @RequestMapping("/detail.do")
    public ModelAndView detail(String id , HttpServletRequest request){
        ModelAndView mv = new ModelAndView();

        Tran tran = tranService.detail(id);

        Map<String , String> map = (Map<String, String>) request.getServletContext().getAttribute("pMap");

        tran.setPossibility(map.get(tran.getStage()));

        mv.addObject("tran",tran);

        mv.setViewName("/workbench/transaction/detail.jsp");
        return mv;
    }
    @RequestMapping(value = "/getHistoryListByTranId.do" , method = RequestMethod.GET)
    @ResponseBody
    public List<TranHistory> getHistoryListByTranId(String id, HttpServletRequest request){

        List<TranHistory> tranHistoryList = tranService.getHistoryListByTranId(id);

        Map<String , String> map = (Map<String, String>) request.getServletContext().getAttribute("pMap");

        tranHistoryList.forEach(tranHistory -> {
            tranHistory.setPossibility(map.get(tranHistory.getStage()));
        });

        return tranHistoryList;
    }
    /*
    获取交易阶段漏斗图
 */
    @RequestMapping("/getCharts.do")
    @ResponseBody
    public PaginationVo<Map<String , Integer>> getCharts(){

        PaginationVo<Map<String , Integer>> paginationVo = tranService.getCharts();

        return paginationVo;
    }
}
