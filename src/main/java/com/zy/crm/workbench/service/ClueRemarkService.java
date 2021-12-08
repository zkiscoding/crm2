package com.zy.crm.workbench.service;

import com.zy.crm.vo.Message;
import com.zy.crm.workbench.domain.ClueRemark;

import java.util.List;
import java.util.Map;

public interface ClueRemarkService {


    List<ClueRemark> getRemarkList(String clueId);


    Message addRemark(ClueRemark clueRemark);

    ClueRemark selectRemarkById(String msg);

    Map<String, Object> updateRemark(ClueRemark clueRemark);

    boolean deleteRemark(String id);
}
