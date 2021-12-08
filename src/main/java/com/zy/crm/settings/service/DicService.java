package com.zy.crm.settings.service;

import com.zy.crm.settings.domain.DicType;
import com.zy.crm.settings.domain.DicValue;
import com.zy.crm.vo.PaginationVo;

import java.util.List;
import java.util.Map;

public interface DicService {
    Map<String, List<DicValue>> getDicValue();

    List<DicType> getDicTypeList();

    DicType getDicType(String code);

    boolean delete(String[] codes);

    boolean update(Map<String, Object> map);

    boolean saveDicValue(DicValue dicValue);

    PaginationVo<DicValue> getDicValueList(String pageNo, String pageSize);

    boolean saveDicType(DicType dicType);

    DicValue getDicValueByid(String id);

    boolean updatedicValue(DicValue dicValue);

    boolean deleteValue(String[] ids);
}
