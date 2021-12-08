package com.zy.crm.settings.dao;

import com.zy.crm.settings.domain.DicType;

import java.util.List;
import java.util.Map;

public interface DicTypeDao {
    List<DicType> selectAllType();

    int addDicType(DicType dicType);

    DicType getDicType(String code);

    int delete(String[] codes);

    int update(Map<String, Object> map);

}
