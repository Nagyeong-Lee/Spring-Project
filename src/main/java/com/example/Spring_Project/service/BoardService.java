package com.example.Spring_Project.service;


import com.example.Spring_Project.dto.BoardDTO;
import com.example.Spring_Project.mapper.BoardMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import java.util.List;
import java.util.Map;
@Service
public class BoardService {

    @Autowired
    private BoardMapper mapper;

    public void insert(BoardDTO boardDTO) throws Exception {
        mapper.insert(boardDTO);
    }

    public void updateFileStatus(@RequestParam Map<String, Object> status) throws Exception {
        mapper.updateFileStatus(status);
    }

    public void updateFile(@RequestParam List<MultipartFile> file, @RequestParam List<Integer> deleteSeq) throws Exception {
        mapper.updateFile(file, deleteSeq);
    }

    public void updateStatus(Map<String, Object> arr) throws Exception {
        mapper.updateStatus(arr);
    }

    public List<BoardDTO> select(@RequestParam Integer start, @RequestParam Integer end,
                                 @RequestParam String searchType, @RequestParam String keyword) throws Exception {   //게시글 리스트 출력 (검색)
        return mapper.select(start, end, searchType, keyword);
    }

    public BoardDTO getBoardDetail(@RequestParam Integer b_seq) throws Exception {  //게시글 상세정보 출력
        return mapper.getBoardDetail(b_seq);
    }


    public void count(@RequestParam Integer b_seq) throws Exception {  //조회수 증가
        mapper.count(b_seq);
    }

    public void delete(@RequestParam Integer b_seq) throws Exception {  //게시글 삭제
        mapper.delete(b_seq);
    }

    public void update(@RequestParam Integer b_seq, @RequestParam String title, @RequestParam String content) throws Exception {  //게시글 수정
        mapper.update(b_seq, title, content);
    }

    public Integer countPost(@RequestParam String searchType, @RequestParam String keyword) throws Exception {  //게시글 총 개수
        return mapper.countPost(searchType, keyword);
    }


    //페이징 처리
    public String getBoardPageNavi(int currentPage, Integer count, String searchType, String keyword) throws Exception {
        int postTotalCount = this.countPost(searchType, keyword);

        int recordCountPerPage = count; // 페이지 당 게시글 개수
        int naviCountPerPage = 10; // 내비 개수

        int pageTotalCount = 0; // 전체 내비 수
        if (postTotalCount % recordCountPerPage > 0) {
            pageTotalCount = postTotalCount / recordCountPerPage + 1;
        } else {
            pageTotalCount = postTotalCount / recordCountPerPage;
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
            sb.append("<a href='/board/list?currentPage=" + (startNavi - 1) + "&count=" + count + "&searchType=" + "&keyword="+"'><</a> ");
        }

        for (int i = startNavi; i <= endNavi; i++) {
            if (currentPage == i) {
                sb.append("<a href='/board/list?currentPage=" + i + "&count=" + count + "&searchType=" + "&keyword="+"'><b>" + i + "</b></a> ");

            } else {
                sb.append("<a href='/board/list?currentPage=" + i + "&count=" + count + "&searchType=" + "&keyword="+"'>" + i + "</a> ");

            }
        }
        if (needNext) {
            sb.append("<a href='/board/list?currentPage=" + (endNavi + 1) + "&count=" + count + "&searchType=" + "&keyword="+"'>></a> ");
        }
        return sb.toString();
    }

    public Integer getNetVal() throws Exception {
        return mapper.getNetVal();
    }

}
