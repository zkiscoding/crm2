package com.zy.crm.workbench.service.impl;

import com.zy.crm.exception.ConvertException;
import com.zy.crm.utils.DateTimeUtil;
import com.zy.crm.utils.UUIDUtil;
import com.zy.crm.vo.PaginationVo;
import com.zy.crm.workbench.dao.*;
import com.zy.crm.workbench.domain.*;
import com.zy.crm.workbench.service.ClueService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ClueServiceImpl implements ClueService {
    @Resource
    private ClueDao clueDao;
    @Resource
    private ClueActivityRelationDao clueActivityRelationDao;
    @Resource
    private ClueRemarkDao clueRemarkDao;
    @Resource
    private CustomerDao customerDao;
    @Resource
    private CustomerRemarkDao customerRemarkDao;

    @Resource
    private ContactsDao contactsDao;
    @Resource
    private ContactsRemarkDao contactsRemarkDao;
    @Resource
    private ContactsActivityRelationDao contactsActivityRelationDao;

    @Resource
    private TranDao tranDao;
    @Resource
    private TranHistoryDao tranHistoryDao;

    @Override
    public boolean save(Clue clue) {
        clue.setCreateTime(DateTimeUtil.getSysTime());
        clue.setId(UUIDUtil.getUUID());
        int count = clueDao.save(clue);
        if(count!=1){
            return false;
        }else {
            return true;
        }
    }

    @Override
    public Clue getClueById(String id) {
        Clue clue = clueDao.getClueById(id);
        return clue;
    }

    @Override
    public boolean unbund(String id) {
        boolean flag = true;
        int count = clueActivityRelationDao.delete(id);
        if (count!=1){
            flag=false;
        }
        return flag;
    }

    @Override
    public boolean bund(String[] ids, String clueId) {
        boolean flag = true;
        for(String aid :ids){
            ClueActivityRelation clueActivityRelation = new ClueActivityRelation();
            clueActivityRelation.setId(UUIDUtil.getUUID());
            clueActivityRelation.setActivityId(aid);
            clueActivityRelation.setClueId(clueId);
            int count = clueActivityRelationDao.add(clueActivityRelation);
            if(count!=1){
                flag = false;
            }
        }
        return flag;
    }

    @Override
    public PaginationVo<Clue> getPageList(String pageNo, String pageSize, Clue clue) {
        int pageNum = Integer.parseInt(pageNo);
        int pageSizes = Integer.parseInt(pageSize);
        int skipCount = (pageNum-1)*pageSizes;
        Map<String,Object> map = new HashMap<>();

        map.put("skipCount",skipCount);
        map.put("pageSizes",pageSizes);
        map.put("fullname",clue.getFullname());
        map.put("company",clue.getCompany());
        map.put("source",clue.getSource());
        map.put("state",clue.getState());
        map.put("owner",clue.getOwner());
        List<Clue> clueList = clueDao.selectPageList(map);
        // 查询市场活动总条数
        int totalSize = clueDao.selectTotalSize(clue);
        PaginationVo<Clue> paginationVo = new PaginationVo<>();
        // 利用vo封装总的记录条数和查询结果集
        paginationVo.setDataList(clueList);
        paginationVo.setTotalSize(totalSize);
        return paginationVo;
    }

    @Override
    public boolean update(Clue clue) {
        clue.setEditTime(DateTimeUtil.getSysTime());
        int count = clueDao.update(clue);
        if(count !=1){
            return false;
        }
        return true;
    }

    @Override
    public boolean delete(String[] ids) {
        boolean flag = true;
        //关联的备注数量
        int count1 = clueRemarkDao.getCountByids(ids);
        //删除相应备注数量
        int count2 = clueRemarkDao.deleteByids(ids);
        if(count1!=count2){
            flag=false;
        }
        //删除市场活动
        int count3 = clueDao.delete(ids);
        if(count3!=ids.length){
            flag=false;
        }
        return flag;
    }

    @Override
    public Clue getClueDetailById(String id) {
        Clue clue = clueDao.getClueDetailById(id);
        return clue;
    }
    // 根据线索信息转换为客户和联系人
    @Override
    @Transactional
    public void convert(String clueId, Tran tran, String createBy) {
        String createTime = DateTimeUtil.getSysTime();
        int result = 0;
        // （1）通过线索id拿到线索完整信息
        Clue clue = clueDao.selectClueByIds(clueId);

        // （2）通过线索信息提取客户(公司)信息
        String company = clue.getCompany();
        Customer customer = customerDao.selectCusByName(company);

        // 没有公司 需要创建该客户公司
        if(customer == null){
            customer = new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setOwner(clue.getOwner());
            customer.setName(company);
            customer.setWebsite(clue.getWebsite());
            customer.setPhone(clue.getPhone());
            customer.setCreateBy(createBy);
            customer.setCreateTime(createTime);
            customer.setContactSummary(clue.getContactSummary());
            customer.setNextContactTime(clue.getNextContactTime());
            customer.setDescription(clue.getDescription());
            customer.setAddress(clue.getAddress());

            result = customerDao.insertCustomer(customer);

            // 创建失败则抛出异常回滚事务
            if(result != 1){
                throw new ConvertException("客户添加失败，转换失败");
            }
        }


        // （3）通过线索对象提取联系人信息 保存联系人
        Contacts contacts = new Contacts();
        contacts.setId(UUIDUtil.getUUID());
        contacts.setFullname(clue.getFullname());
        contacts.setAppellation(clue.getAppellation());
        contacts.setOwner(clue.getOwner());
        contacts.setSource(clue.getSource());
        contacts.setCustomerId(customer.getId());
        contacts.setEmail(clue.getEmail());
        contacts.setMphone(clue.getMphone());
        contacts.setJob(clue.getJob());
        contacts.setCreateBy(createBy);
        contacts.setCreateTime(createTime);;
        contacts.setContactSummary(clue.getContactSummary());
        contacts.setNextContactTime(clue.getNextContactTime());
        contacts.setDescription(clue.getDescription());
        contacts.setAddress(clue.getAddress());

        // 插入一条联系人信息
        result =  contactsDao.insertContacts(contacts);

        if(result != 1){
            throw new ConvertException("联系人添加失败，转换失败");
        }


        // (4)将线索备注转换为联系人备注和客户备注
        List<ClueRemark> clueRemarkList = clueRemarkDao.selectClueRemarkByClueId(clueId);

        // 每取出一个线索备注 进行一次转换
        if(clueRemarkList != null){
            for(ClueRemark clueRemark : clueRemarkList){

                String noteContent = clueRemark.getNoteContent();

                ContactsRemark contactsRemark = new ContactsRemark();
                contactsRemark.setId(UUIDUtil.getUUID());
                contactsRemark.setContactsId(contacts.getId());
                contactsRemark.setCreateBy(createBy);
                contactsRemark.setCreateTime(createTime);
                contactsRemark.setNoteContent(noteContent);
                contactsRemark.setEditFlag("0");
                // 插入一条联系人备注记录
                result = contactsRemarkDao.insertContactsRemark(contactsRemark);
                if(result != 1){
                    throw new ConvertException("联系人备注添加失败，转换失败");
                }

                CustomerRemark customerRemark = new CustomerRemark();
                customerRemark.setId(UUIDUtil.getUUID());
                customerRemark.setCustomerId(customer.getId());
                customerRemark.setCreateBy(createBy);
                customerRemark.setCreateTime(createTime);
                customerRemark.setNoteContent(noteContent);
                customerRemark.setEditFlag("0");
                // 插入一条客户备注记录
                result = customerRemarkDao.insertCustomerRemark(customerRemark);
                if(result != 1){
                    throw new ConvertException("客户备注添加失败，转换失败");
                }
            }
        }


        // （5）线索和市场活动的关联关系转换到联系人和市场活动的关联关系
        // 查询该线索的所有市场活动关联
        List<ClueActivityRelation> clueActivityRelationList = clueActivityRelationDao.selectRelationByClueId(clueId);

        // 依次插入联系人和市场活动的关联
        if(clueActivityRelationList != null){
            for(ClueActivityRelation clueActivityRelation : clueActivityRelationList){

                ContactsActivityRelation relation = new ContactsActivityRelation();
                relation.setId(UUIDUtil.getUUID());
                relation.setActivityId(clueActivityRelation.getActivityId());
                relation.setContactsId(contacts.getId());

                result = contactsActivityRelationDao.insertRelation(relation);
                if(result != 1){
                    throw new ConvertException("联系人和市场活动关联失败，转换失败");
                }
            }
        }


        // (6)当tran不为null时 需要添加交易

        if(tran != null){
            /*
                已封装好的信息：
                   money,name,expectedDate,stage,activityId
             */
            tran.setId(UUIDUtil.getUUID());
            tran.setOwner(clue.getOwner());
            tran.setCreateTime(createTime);
            tran.setCreateBy(createBy);
            tran.setSource(clue.getSource());
            tran.setContactsId(contacts.getId());
            tran.setCustomerId(customer.getId());
            tran.setNextContactTime(clue.getNextContactTime());
            tran.setDescription(clue.getDescription());
            tran.setContactSummary(clue.getContactSummary());

            // 添加交易
            result = tranDao.insertTran(tran);
            if(result != 1){
                throw new ConvertException("交易添加失败，转换失败");
            }

            // (7)添加交易之后添加交易历史
            TranHistory tranHistory = new TranHistory();
            tranHistory.setId(UUIDUtil.getUUID());
            tranHistory.setCreateBy(createBy);
            tranHistory.setCreateTime(createTime);
            tranHistory.setTranId(tran.getId());
            tranHistory.setMoney(tran.getMoney());
            tranHistory.setExpectedDate(tran.getExpectedDate());
            tranHistory.setStage(tran.getStage());


            result = tranHistoryDao.insertTranHistory(tranHistory);
            if(result != 1){
                throw new ConvertException("交易历史添加失败，转换失败");
            }
        }

        // (8)删除线索备注
        if (clueRemarkList != null) {
            for(ClueRemark clueRemark : clueRemarkList){
                result = clueRemarkDao.deleteClueRemark(clueRemark.getId());
                if(result != 1){
                    throw new ConvertException("删除线索备注失败，转换失败");
                }
            }
        }

        // （9）删除线索和市场活动的关系
        if (clueActivityRelationList != null) {
            for(ClueActivityRelation clueActivityRelation : clueActivityRelationList){

                result = clueActivityRelationDao.deleteACRelation(clueActivityRelation.getId());
                if(result != 1){
                    throw new ConvertException("删除线索和市场活动关联关系失败，转换失败");
                }
            }
        }

        // （10）删除线索
        result = clueDao.deleteClueById(clueId);
        if(result != 1){
            throw new ConvertException("删除线索失败，转换失败");
        }

    }

}
