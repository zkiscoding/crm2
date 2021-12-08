package com.zy.crm.settings.service.impl;

import com.zy.crm.exception.BindException;
import com.zy.crm.settings.dao.DicTypeDao;
import com.zy.crm.settings.dao.DicValueDao;
import com.zy.crm.settings.domain.DicType;
import com.zy.crm.settings.domain.DicValue;
import com.zy.crm.settings.service.DicService;
import com.zy.crm.vo.PaginationVo;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class DicServiceImpl implements DicService {
    @Resource
    private DicTypeDao dicTypeDao;
    @Resource
    private DicValueDao dicValueDao;

    @Override
    public Map<String, List<DicValue>> getDicValue() {
        Map<String, List<DicValue>> map = new HashMap<>();
        List<DicType> types = dicTypeDao.selectAllType();

        for(DicType type :types){
            String code = type.getCode();
            List<DicValue> values = dicValueDao.getValuesByCode(code);
            map.put(code,values);
        }
        return map;
    }

    @Override
    public List<DicType> getDicTypeList() {
        List<DicType> dicTypeList = dicTypeDao.selectAllType();
        return dicTypeList;
    }


    @Override
    public boolean saveDicType(DicType dicType) {
        DicType dicType1 =dicTypeDao.getDicType(dicType.getCode());
        if(dicType1 != null){
            throw new BindException("主键冲突，请修改！");
        }
        int count = dicTypeDao.addDicType(dicType);
        boolean flag = true;
        if (count != 1){
            flag=false;
        }
        return flag;
    }

    @Override
    public DicValue getDicValueByid(String id) {
        DicValue dicValue = dicValueDao.getDicValueByid(id);
        return dicValue;
    }

    @Override
    public boolean updatedicValue(DicValue dicValue) {
        int count = dicValueDao.updatedicValue(dicValue);
        if(count!=1){
            return false;
        }
        return true;
    }

    @Override
    public boolean deleteValue(String[] ids) {
        int count = dicValueDao.deleteDicValue(ids);
        if(count != ids.length){
            return false;
        }
        return true;
    }

    @Override
    public DicType getDicType(String code) {
        DicType dicType = dicTypeDao.getDicType(code);
        return dicType;
    }

    @Override
    @Transactional//备注表先删除
    public boolean delete(String[] codes) {
        boolean flag = true;

        int count0 = dicValueDao.selectValueBycodes(codes);
        int count1 = dicValueDao.delete(codes);
        if(count0 != count1){
            flag = false;
        }
        int count2 = dicTypeDao.delete(codes);
        if(count2 != codes.length){
            flag = false;
        }
        return flag;
    }

    @Override
    public boolean update(Map<String, Object> map) {
        boolean flag = true;
        int count = dicTypeDao.update(map);
        if(count!=1){
            flag = false;
        }
        int count1 = dicValueDao.getValuesById(map);
        int count2 = dicValueDao.update(map);
        if(count1 != count2){
            flag = false;
        }
        return flag;

    }

    @Override
    public boolean saveDicValue(DicValue dicValue) {
        boolean flag = true;
        int count = dicValueDao.save(dicValue);
        if(count != 1){
            flag = false;
        }
        return flag;
    }

    @Override
    public PaginationVo<DicValue> getDicValueList(String pageNo, String pageSize) {
        int pageNum = Integer.parseInt(pageNo);
        int pageSizes = Integer.parseInt(pageSize);
        // 根据页码查询 利用pageHelper进行分页查询
        // 第一个参数是页号 第二个参数是每页的记录条数
        int skipCount = (pageNum-1)*pageSizes;
        Map<String,Object> map = new HashMap<>();
        map.put("skipCount",skipCount);
        map.put("pageSizes",pageSizes);
        int total = dicValueDao.selectAllValue();
        List<DicValue> dicValueList = dicValueDao.selectPageList(map);
        PaginationVo<DicValue> paginationVo = new PaginationVo<>();
        paginationVo.setDataList(dicValueList);
        paginationVo.setTotalSize(total);
        return paginationVo;
    }


}
