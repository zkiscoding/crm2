package com.zy.crm.workbench.service;

import com.zy.crm.vo.PaginationVo;
import com.zy.crm.workbench.domain.Clue;
import com.zy.crm.workbench.domain.Tran;

public interface ClueService {
    boolean save(Clue clue);

    Clue getClueById(String id);

    boolean unbund(String id);

    boolean bund(String[] ids, String clueId);

    PaginationVo<Clue> getPageList(String pageNo, String pageSize, Clue clue);

    boolean update(Clue clue);

    boolean delete(String[] ids);

    Clue getClueDetailById(String id);

    void convert(String clueId, Tran tran, String createBy);
}
