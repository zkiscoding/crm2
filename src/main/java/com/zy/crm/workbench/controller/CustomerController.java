package com.zy.crm.workbench.controller;

import com.zy.crm.workbench.domain.Customer;
import com.zy.crm.workbench.service.CustomerService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.List;

@Controller
public class CustomerController {
    @Resource
    private CustomerService customerService;

    @RequestMapping("/workbench/contacts/getcCustomersList.do")
    @ResponseBody
    public List<Customer> getcCustomersList(){
        List<Customer> customerList= customerService.getcCustomersList();
        return customerList;
    }

}
