package com.zy.crm.workbench.dao;

import com.zy.crm.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkDao {

    int getCountByids(String[] ids);

    int deleteByids(String[] ids);

    List<ClueRemark> getRemarkList(String clueId);

    int addRemark(ClueRemark clueRemark);

    ClueRemark selectRemarkById(String msg);

    int updateRemark(ClueRemark clueRemark);

    int deleteRemark(String id);

    List<ClueRemark> selectClueRemarkByClueId(String clueId);

    int deleteClueRemark(String id);
}
