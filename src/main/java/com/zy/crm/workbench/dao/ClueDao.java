package com.zy.crm.workbench.dao;

import com.zy.crm.workbench.domain.Clue;

import java.util.List;
import java.util.Map;

public interface ClueDao {


    int save(Clue clue);

    Clue getClueById(String id);

    Clue getClueDetailById(String id);

    List<Clue> selectPageList(Map<String, Object> map);

    int selectTotalSize(Clue clue);

    int update(Clue clue);

    int delete(String[] ids);

    Clue selectClueByIds(String clueId);

    int deleteClueById(String clueId);
}
