package com.zy.crm.workbench.service.impl;

import com.zy.crm.workbench.dao.CustomerDao;
import com.zy.crm.workbench.domain.Customer;
import com.zy.crm.workbench.service.CustomerService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * @author zy
 */
@Service
public class CustomerServiceImpl implements CustomerService {
    @Resource
    CustomerDao customerDao;

    @Override
    public List<Customer> getcCustomersList() {
        List<Customer> customerList= customerDao.getcCustomersList();
        return customerList;
    }

    @Override
    public List<String> getCustomerName(String name) {
        List<String> nameList = customerDao.selectCustomerName(name);

        return nameList;
    }
}
