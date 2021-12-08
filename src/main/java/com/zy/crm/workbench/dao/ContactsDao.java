package com.zy.crm.workbench.dao;

import com.zy.crm.workbench.domain.Contacts;

import java.util.List;

public interface ContactsDao {

    int insertContacts(Contacts contacts);

    List<Contacts> getcContactsList();
}
