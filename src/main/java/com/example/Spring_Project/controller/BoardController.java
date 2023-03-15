package com.example.Spring_Project.controller;


import com.example.Spring_Project.dto.BoardDTO;
import com.example.Spring_Project.dto.CommentDTO;
import com.example.Spring_Project.service.BoardService;
import com.example.Spring_Project.service.CommentService;
import com.example.Spring_Project.service.FileService;
import com.google.gson.JsonObject;
import lombok.Getter;
import oracle.ucp.proxy.annotation.Post;
import org.apache.commons.io.FileUtils;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.relational.core.sql.In;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.*;

@Controller
@RequestMapping("/board")
public class BoardController {

    @Autowired
    private BoardService service;

    @Autowired
    private CommentService commentService;

    @Autowired
    private FileService fileService;

    @RequestMapping("/list") // 메인 , 게시글 리스트
    public String toBoard(Model model,
                          @RequestParam Integer currentPage,
                          @RequestParam Integer count,
                          @RequestParam(required = false) String searchType,
                          @RequestParam(required = false) String keyword) throws Exception {
        if (currentPage == null) {
            currentPage = 1;
        }

        //게시글 개수 기본 10
        if (count == null) {
            count = 10;
        }

        System.out.println(searchType);
        System.out.println(keyword);
        System.out.println(currentPage);
        System.out.println(count);

        service.countPost(searchType, keyword); // 전체 글 개수
        Integer start = currentPage * count - 9; //시작 글 번호
        Integer end = currentPage * count; // 끝 글 번호


        List<BoardDTO> list = service.select(start, end, searchType, keyword); //검색
        String paging = service.getBoardPageNavi(currentPage, count, searchType, keyword);

        model.addAttribute("list", list);
        model.addAttribute("paging", paging);
        return "/board/main";
    }

    @RequestMapping("/toWriteForm")  //글 작성 폼으로 이동
    public String toWriteForm(Model model, @RequestParam Integer b_seq) throws Exception {
        model.addAttribute("b_seq", b_seq);
        return "/board/writeForm";
    }

    @PostMapping("/insert")  //글 작성 (파일 업로드 같이)
    public String insert(BoardDTO boardDTO, List<MultipartFile> file) throws Exception {
        Integer b_seq = service.getNetVal();   //b_seq nextval
        System.out.println("nextVal : " + b_seq);
        boardDTO.setB_seq(b_seq);
        service.insert(boardDTO);
        System.out.println("file.size : " + file.size());

        List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
        boolean flag = true;

        if (!file.isEmpty()) {  //파일 있으면

            String path = "C:/storage/";  //파일이 저장될 경로 설정
            File dir = new File(path);
            if (!dir.isDirectory()) {
                dir.mkdirs();
            }

            for (MultipartFile f : file) {
                Map<String, Object> map = new HashMap<>();
                //파일 이름을 String 값으로 반환한다
                System.out.println("파일 이름(uploadfile.getOriginalFilename()) : " + f.getOriginalFilename());

                String oriname = f.getOriginalFilename();
                if (oriname.equals("")) {
                    flag = false;
                }

                // 파일 이름 변경
                UUID uuid = UUID.randomUUID();
                String sysname = uuid + "_" + oriname; //서버상의 파일이름이 겹치는것을 방지
                String savePath = path + sysname; //저장될 파일 경로
                System.out.println("savePath : " + savePath);
                System.out.println("oriname : " + oriname);
                System.out.println("sysname: " + sysname);

                //파일 저장
                f.transferTo(new File(savePath));
                map.put("b_seq", b_seq);
                map.put("oriname", oriname);
                map.put("sysname", sysname);
                list.add(map);
            }
            if (flag==true) {
                for (int i = 0; i < list.size(); i++) {
                    fileService.insertMap(list.get(i));
                }
            }
        }
        return "redirect:/board/list?currentPage=1&count=10";
//        return"";
    }

    @GetMapping("/detail")   //게시글 상세페이지
    public String detail(Model model, @RequestParam Integer b_seq) throws Exception {
        service.count(b_seq);   //조회수 증가
        BoardDTO boardDTO = service.getBoardDetail(b_seq);   //게시글 상세 정보 가져오기
        List<CommentDTO> commentList = commentService.getComment(b_seq);

        model.addAttribute("boardDTO", boardDTO);
        model.addAttribute("commentList", commentList); //댓글 가져오기
        return "/board/detailPost";
    }

    @GetMapping("/delete")   //게시글 삭제
    public String delete(@RequestParam Integer b_seq) throws Exception {
        service.delete(b_seq);
        return "redirect:/board/list?currentPage=1&count=10";
    }

    @PostMapping("/update")  //게시글 수정
    public String update(@RequestParam String title, @RequestParam String content, @RequestParam Integer b_seq
            , List<MultipartFile> file) throws Exception {
        service.update(title, content, b_seq);
        return "redirect:/board/list?currentPage=1&count=10";
    }

    @PostMapping("/img")
    @ResponseBody
    public String uploadSummernoteImageFile(@RequestParam("file") MultipartFile multipartFile, HttpServletRequest
            request) {
        JsonObject jsonObject = new JsonObject();
        /*
         * String fileRoot = "C:\\summernote_image\\"; // 외부경로로 저장을 희망할때.
         */

        // 내부경로로 저장
        String contextRoot = new HttpServletRequestWrapper(request).getRealPath("/");
        String fileRoot = contextRoot + "resources/img/";
        System.out.println("contextRoot : " + contextRoot);
        System.out.println("fileRoot : " + fileRoot);

        String originalFileName = multipartFile.getOriginalFilename();    //오리지날 파일명
        System.out.println("originalFileName : " + originalFileName);
        String extension = originalFileName.substring(originalFileName.lastIndexOf("."));    //파일 확장자
        String savedFileName = UUID.randomUUID() + extension;    //저장될 파일 명
        System.out.println("savedFileName : " + savedFileName);
        File targetFile = new File(fileRoot + savedFileName);
        try {
            InputStream fileStream = multipartFile.getInputStream();
            FileUtils.copyInputStreamToFile(fileStream, targetFile);    //파일 저장
            jsonObject.addProperty("url", "/resources/img/" + savedFileName); // contextroot + resources + 저장할 내부 폴더명

        } catch (IOException e) {
            e.printStackTrace();
        }
        String path = "/resources/img/" + savedFileName;
        System.out.println("리턴 이미지 경로 : " + path);
        return path;
    }
}



