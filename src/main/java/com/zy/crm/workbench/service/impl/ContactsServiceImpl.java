package com.zy.crm.workbench.service.impl;

import com.zy.crm.workbench.dao.ContactsDao;
import com.zy.crm.workbench.domain.Contacts;
import com.zy.crm.workbench.service.ContactsService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class ContactsServiceImpl implements ContactsService {
    @Resource
    ContactsDao contactsDao;

    @Override
    public List<Contacts> getcContactsList() {
        List<Contacts> contactsList = contactsDao.getcContactsList();
        return  contactsList;
    }
}
