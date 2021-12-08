package com.zy.crm.workbench.service;


import com.zy.crm.vo.PaginationVo;
import com.zy.crm.workbench.domain.Tran;
import com.zy.crm.workbench.domain.TranHistory;

import java.util.List;
import java.util.Map;

public interface TranService {


    List<Tran> getTranList();

    int saveTran(Tran tran, String customerName);

    Tran detail(String id);

    List<TranHistory> getHistoryListByTranId(String id);

    PaginationVo<Map<String, Integer>> getCharts();
}
