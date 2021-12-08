package com.zy.crm.workbench.dao;

import com.zy.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface TranDao {

    int insertTran(Tran tran);

    List<Tran> getTranList();

    Tran selectDetail(String id);

    List<Map<String, Integer>> selectStageSize();

    int getTotalSize();
}
