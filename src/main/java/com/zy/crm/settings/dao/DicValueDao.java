package com.zy.crm.settings.dao;

import com.zy.crm.settings.domain.DicValue;

import java.util.List;
import java.util.Map;

public interface DicValueDao {
    List<DicValue> getValuesByCode(String code);

    int selectValueBycodes(String[] codes);

    int delete(String[] codes);

    int getValuesById(Map<String, Object> map);

    int update(Map<String, Object> map);

    int save(DicValue dicValue);

    int selectAllValue();

    List<DicValue> selectPageList(Map<String, Object> map);

    DicValue getDicValueByid(String id);

    int updatedicValue(DicValue dicValue);

    int deleteDicValue(String[] ids);
}
