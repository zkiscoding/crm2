package com.zy.crm.workbench.dao;

import com.zy.crm.workbench.domain.Customer;

import java.util.List;

public interface CustomerDao {

    Customer selectCusByName(String company);

    int insertCustomer(Customer customer);

    List<Customer> getcCustomersList();

    List<String> selectCustomerName(String name);
}
