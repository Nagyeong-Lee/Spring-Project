package com.example.Spring_Project.service;

import com.example.Spring_Project.dto.BoardDTO;
import com.example.Spring_Project.dto.LogDTO;
import com.example.Spring_Project.mapper.LogMapper;
import lombok.extern.java.Log;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;
import java.util.Map;

@Service
public class LogService {

    @Autowired
    private LogMapper logMapper;

    public void insertLog(LogDTO logDTO) throws Exception {
//        try {
////             throw로 강제 예외 발생
//            throw new Throwable("강제 예외 발생!!!");
//        } catch (Exception e) {
//            System.out.println("err_msg : " + e.getMessage());
//        } catch (Throwable e) {
//            throw new RuntimeException(e);
//        }

        logMapper.insertLog(logDTO);
    }

    public Integer isIdExist(@RequestParam String id) throws Exception {
        return logMapper.isIdExist(id);
    }

    public Integer loginCheck(@RequestParam String id, @RequestParam String pw) throws Exception {
        return logMapper.loginCheck(id, pw); //log
    }

    public List<LogDTO> selectLog(@RequestParam Integer start, @RequestParam Integer end,
                                  @RequestParam String searchType, @RequestParam String keyword) throws Exception {
        return logMapper.selectLog(start, end, searchType, keyword);
    }

    public Integer countLog(@RequestParam String searchType, @RequestParam String keyword) throws Exception {
        return logMapper.countLog(searchType, keyword); //log
    }

    //페이징 처리
    public String getLogPageNavi(int currentPage, Integer count, String searchType, String keyword, Integer postNum) throws Exception {
        Integer totalLogCount = this.countLog(searchType, keyword);  //전체 로그 개수
        int recordCountPerPage = count; // 페이지 당 게시글 개수
        int naviCountPerPage = 10; // 내비 개수


        int pageTotalCount = 0; // 전체 내비 수
        if (totalLogCount % recordCountPerPage > 0) {
            pageTotalCount = totalLogCount / recordCountPerPage + 1;
        } else {
            pageTotalCount = totalLogCount / recordCountPerPage;
        }

        if (currentPage < 1) {
            currentPage = 1;
        } else if (currentPage > pageTotalCount) {
            currentPage = pageTotalCount;
        }

        int startNavi = (currentPage - 1) / naviCountPerPage * naviCountPerPage + 1; // 페이지 시작 내비 값
        int endNavi = startNavi + naviCountPerPage - 1; // 페이지 마지막 내비 값

        if (endNavi > pageTotalCount) {
            endNavi = pageTotalCount;
        }
        boolean needPrev = true;
        boolean needNext = true;

        if (startNavi == 1) {
            needPrev = false;
        }
        if (endNavi == pageTotalCount) {
            needNext = false;
        }

        StringBuilder sb = new StringBuilder();

        if (needPrev) {
            if (postNum == null) {
                sb.append("<a href='/admin/list?currentPage=" + (startNavi - 1) + "&count=" + count + "&searchType=" + searchType + "&keyword=" + keyword + "'><</a> ");
            } else if (searchType == null && keyword == null) {
                sb.append("<a href='/admin/list?currentPage=" + (startNavi - 1) + "&count=" + count + "&postNum=" + postNum + "&searchType=&keyword=" + "'><</a> ");
            } else {
                sb.append("<a href='/admin/list?currentPage=" + (startNavi - 1) + "&count=" + count + "&postNum=" + postNum + "&searchType=" + searchType + "&keyword=" + keyword + "'><</a> ");
            }
        }

        for (int i = startNavi; i <= endNavi; i++) {
            if (currentPage == i) {
                if (postNum == null) {
                    if (searchType == null && keyword == null) {
                        sb.append("<a href='/admin/list?currentPage=" + i + "&count=" + count + "&searchType=" + "&keyword=" + "'><b>" + i + "</b></a> ");
                    } else {
                        sb.append("<a href='/admin/list?currentPage=" + i + "&count=" + count + "&searchType=" + searchType + "&keyword=" + keyword + "'><b>" + i + "</b></a> ");
                    }
                } else {
                    if (searchType == null && keyword == null) {
                        sb.append("<a href='/admin/list?currentPage=" + i + "&count=" + count + "&postNum=" + postNum + "&searchType=" + "&keyword=" + "'><b>" + i + "</b></a> ");
                    } else {
                        sb.append("<a href='/admin/list?currentPage=" + i + "&count=" + count + "&postNum=" + postNum + "&searchType=" + searchType + "&keyword=" + keyword + "'><b>" + i + "</b></a> ");
                    }
                }
            } else {
                if (postNum == null) {
                    if (searchType == null && keyword == null) {
                        sb.append("<a href='/admin/list?currentPage=" + i + "&count=" + count + "&searchType=" + "&keyword=" + "'><b>" + i + "</b></a> ");
                    } else {
                        sb.append("<a href='/admin/list?currentPage=" + i + "&count=" + count + "&searchType=" + searchType + "&keyword=" + keyword + "'><b>" + i + "</b></a> ");
                    }
                } else {
                    if (searchType == null && keyword == null) {
                        sb.append("<a href='/admin/list?currentPage=" + i + "&count=" + count + "&postNum=" + postNum + "&searchType=" + "&keyword=" + "'>" + i + "</a> ");
                    } else {
                        sb.append("<a href='/admin/list?currentPage=" + i + "&count=" + count + "&postNum=" + postNum + "&searchType=" + searchType + "&keyword=" + keyword + "'>" + i + "</a> ");
                    }
                }
            }
        }
        if (needNext) {
            if (postNum == null) {
                if (searchType == null && keyword == null) {
                    sb.append("<a href='/admin/list?currentPage=" + (endNavi + 1) + "&count=" + count + "&searchType=" + "&keyword=" + "'>></a> ");
                } else {
                    sb.append("<a href='/admin/list?currentPage=" + (endNavi + 1) + "&count=" + count + "&searchType=" + searchType + "&keyword=" + keyword + "'>></a> ");
                }
            } else {
                if (searchType == null && keyword == null) {
                    sb.append("<a href='/admin/list?currentPage=" + (endNavi + 1) + "&count=" + count + "&postNum=" + postNum + "&searchType=" + "&keyword=" + "'>></a> ");
                } else {
                    sb.append("<a href='/admin/list?currentPage=" + (endNavi + 1) + "&count=" + count + "&postNum=" + postNum + "&searchType=" + searchType + "&keyword=" + keyword + "'>></a> ");
                }
            }
        }
        return sb.toString();
    }
}
