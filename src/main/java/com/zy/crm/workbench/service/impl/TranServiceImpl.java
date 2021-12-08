package com.zy.crm.workbench.service.impl;

import com.zy.crm.exception.TranSaveException;
import com.zy.crm.utils.DateTimeUtil;
import com.zy.crm.utils.UUIDUtil;
import com.zy.crm.vo.PaginationVo;
import com.zy.crm.workbench.dao.CustomerDao;
import com.zy.crm.workbench.dao.TranDao;
import com.zy.crm.workbench.dao.TranHistoryDao;
import com.zy.crm.workbench.domain.Customer;
import com.zy.crm.workbench.domain.Tran;
import com.zy.crm.workbench.domain.TranHistory;
import com.zy.crm.workbench.service.TranService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

/**
 * @author zy
 */
@Service
public class TranServiceImpl implements TranService {

    @Resource
    private TranDao tranDao;

    @Resource
    private TranHistoryDao tranHistoryDao;

    @Resource
    private CustomerDao customerDao;


    @Override
    public List<Tran> getTranList() {
        List<Tran> tranList = tranDao.getTranList();
        return tranList;
    }

    @Override
    public int saveTran(Tran tran, String customerName) {
        // 获取客户信息通过客户名称
        Customer customer = customerDao.selectCusByName(customerName);
        int result = 0;
        // 该客户不存在则创建客户
        if (customer == null){
            customer = new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setName(customerName);
            customer.setCreateBy(tran.getCreateBy());
            customer.setCreateTime(DateTimeUtil.getSysTime());
            customer.setOwner(tran.getOwner());
            customer.setNextContactTime(tran.getNextContactTime());
            customer.setContactSummary(tran.getContactSummary());
            result = customerDao.insertCustomer(customer);
            if(result != 1){
                throw  new TranSaveException("客户创建失败，交易保存失败");
            }
        }
        // 设置客户id
        tran.setCustomerId(customer.getId());
        tran.setId(UUIDUtil.getUUID());
        tran.setCreateTime(DateTimeUtil.getSysTime());
        result =  tranDao.insertTran(tran);
        if(result != 1){
            throw  new TranSaveException("交易保存失败");
        }
        // 添加交易历史
        TranHistory tranHistory = new TranHistory();
        tranHistory.setId(UUIDUtil.getUUID());
        tranHistory.setTranId(tran.getId());
        tranHistory.setStage(tran.getStage());
        tranHistory.setMoney(tran.getMoney());
        tranHistory.setExpectedDate(tran.getExpectedDate());
        tranHistory.setCreateTime(DateTimeUtil.getSysTime());
        tranHistory.setCreateBy(tran.getCreateBy());

        result = tranHistoryDao.insertTranHistory(tranHistory);
        if(result != 1){
            throw  new TranSaveException("交易历史创建失败");
        }


        return result;
    }

    @Override
    public Tran detail(String id) {
        Tran tran = tranDao.selectDetail(id);
        return tran;
    }

    @Override
    public List<TranHistory> getHistoryListByTranId(String id) {
        List<TranHistory> tranHistoryList = tranHistoryDao.selectHistoryByTranId(id);

        return tranHistoryList;
    }

    @Override
    public PaginationVo<Map<String, Integer>> getCharts() {
        PaginationVo<Map<String, Integer>> paginationVo = new PaginationVo<>();

        // 获取前端所需要的数据   json数组形式的 name（stage） , value(对应stage的数量) 两个键值对
        List<Map<String , Integer>> list = tranDao.selectStageSize();


        int totalSize = tranDao.getTotalSize();

        paginationVo.setTotalSize(totalSize);
        paginationVo.setDataList(list);

        return paginationVo;
    }
}
