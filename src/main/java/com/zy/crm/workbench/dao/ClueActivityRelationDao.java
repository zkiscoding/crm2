package com.zy.crm.workbench.dao;

import com.zy.crm.workbench.domain.ClueActivityRelation;

import java.util.List;

public interface ClueActivityRelationDao {


    int delete(String id);

    int add(ClueActivityRelation clueActivityRelation);

    List<ClueActivityRelation> selectRelationByClueId(String clueId);

    int deleteACRelation(String id);
}
