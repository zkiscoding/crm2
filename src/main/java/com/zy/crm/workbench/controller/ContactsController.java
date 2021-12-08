package com.zy.crm.workbench.controller;

import com.zy.crm.workbench.domain.Contacts;
import com.zy.crm.workbench.service.ContactsService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.List;

@Controller
public class ContactsController {
    @Resource
    private ContactsService contactsService;

    @RequestMapping("/workbench/contacts/getcContactsList.do")
    @ResponseBody
    public List<Contacts> getcContactsList(){
        List<Contacts> contactsList= contactsService.getcContactsList();
        return contactsList;
    }

}
