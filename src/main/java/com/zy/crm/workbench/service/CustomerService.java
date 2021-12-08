package com.zy.crm.workbench.service;

import com.zy.crm.workbench.domain.Customer;

import java.util.List;

public interface CustomerService {


    List<Customer> getcCustomersList();

    List<String> getCustomerName(String name);

}