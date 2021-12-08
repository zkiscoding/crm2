package com.zy.crm.workbench.dao;

import com.zy.crm.workbench.domain.TranHistory;

import java.util.List;

public interface TranHistoryDao {

    int insertTranHistory(TranHistory tranHistory);

    List<TranHistory> selectHistoryByTranId(String id);
}
