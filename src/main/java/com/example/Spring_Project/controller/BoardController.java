package com.example.Spring_Project.controller;

import com.example.Spring_Project.dto.BoardDTO;
import com.example.Spring_Project.dto.CommentDTO;
import com.example.Spring_Project.dto.FileDTO;
import com.example.Spring_Project.service.BoardService;
import com.example.Spring_Project.service.CommentService;
import com.example.Spring_Project.service.FileService;
import com.google.gson.JsonObject;
import org.apache.commons.io.FileUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;
import javax.servlet.http.HttpSession;
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

    @Autowired
    private HttpSession session;

    @RequestMapping("/list") // 게시글 리스트
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

        service.countPost(searchType, keyword); // 전체 글 개수
        Integer start = currentPage * count - 9; //시작 글 번호
        Integer end = currentPage * count; // 끝 글 번호


        List<BoardDTO> list = service.select(start, end, searchType, keyword); //검색
        String paging = service.getBoardPageNavi(currentPage, count, searchType, keyword);

        model.addAttribute("list", list);
        model.addAttribute("paging", paging);
        model.addAttribute("id", session.getAttribute("id"));
        return "/board/main";
    }

    @RequestMapping("/toWriteForm")  //글 작성 폼으로 이동
    public String toWriteForm(Model model, @RequestParam Integer b_seq) throws Exception {
        model.addAttribute("b_seq", b_seq);
        return "/board/writeForm";
    }

    @ResponseBody
    @PostMapping("/insert")  //글 작성 (파일 업로드 같이)
    public String insert(BoardDTO boardDTO, @RequestParam(required = false) List<MultipartFile> file) throws Exception {

        Integer b_seq = service.getNetVal();   //b_seq nextval
        boardDTO.setB_seq(b_seq);

        List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
        boolean flag = true;

        if (file == null) { //파일 없을때
            service.insert(boardDTO);
        } else if (file != null) {  //파일 있을때
            service.insert(boardDTO);
            String path = "D:/storage/";
            File dir = new File(path);
            if (!dir.isDirectory()) {
                dir.mkdirs();
            }

            for (MultipartFile f : file) {
                Map<String, Object> map = new HashMap<>();

                String oriname = f.getOriginalFilename();
                if (oriname.equals("")) {
                    flag = false;
                }

                UUID uuid = UUID.randomUUID();
                String sysname = uuid + "_" + oriname;
                String savePath = path + sysname;

                f.transferTo(new File(savePath));
                map.put("b_seq", b_seq);
                map.put("oriname", oriname);
                map.put("sysname", sysname);
                list.add(map);
            }
            for (int i = 0; i < list.size(); i++) {
                fileService.insertMap(list.get(i));
            }
        }
        return "1";
    }

    @GetMapping("/detail")   //게시글 상세페이지
    public String detail(Model model, @RequestParam Integer b_seq) throws Exception {
        service.count(b_seq);   //조회수 증가

        BoardDTO boardDTO = service.getBoardDetail(b_seq);   //게시글 상세 정보 가져오기
        List<CommentDTO> commentList = commentService.getComment(b_seq);
        List<FileDTO> list = fileService.getFile(b_seq);


        model.addAttribute("boardDTO", boardDTO);
        model.addAttribute("commentList", commentList); //댓글 가져오기
        model.addAttribute("file", list);
        return "/board/detailPost";
    }

    @GetMapping("/delete")   //게시글 삭제
    public String delete(@RequestParam Integer b_seq) throws Exception {
        service.delete(b_seq);
        return "redirect:/board/list?currentPage=1&count=10";
    }

    @ResponseBody
    @PostMapping("/update")  //게시글 수정
    public String update(@RequestParam Integer b_seq,
                         @RequestParam String title,
                         @RequestParam String content,
                         @RequestParam(required = false) List<MultipartFile> file,
                         @RequestParam(required = false) List<Integer> deleteSeq) throws Exception {

        List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();    // insert
        List<Map<String, Object>> status = new ArrayList<>();   //status 변경

        service.update(b_seq, title, content); //board update
        boolean flag = true;
        if (file == null && deleteSeq != null) {

            for (int i = 0; i < deleteSeq.size(); i++) {
                HashMap<String, Object>
                        arr = new HashMap<>();
                arr.put("b_seq", b_seq);
                int f_seq = deleteSeq.get(i);
                arr.put("f_seq", f_seq);
                service.updateStatus(arr);
            }
        } else if (file != null && deleteSeq != null) {

            for (int i = 0; i < deleteSeq.size(); i++) {
                HashMap<String, Object>
                        arr = new HashMap<>();
                arr.put("b_seq", b_seq);
                int f_seq = deleteSeq.get(i);
                arr.put("f_seq", f_seq);
                service.updateStatus(arr);
            }

            String path = "D:/storage/";
            File dir = new File(path);
            if (!dir.isDirectory()) {
                dir.mkdirs();
            }

            for (MultipartFile f : file) {
                Map<String, Object> map = new HashMap<>();
                String oriname = f.getOriginalFilename();
                if (oriname.equals("")) {
                    flag = false;
                }

                UUID uuid = UUID.randomUUID();
                String sysname = uuid + "_" + oriname;
                String savePath = path + sysname;

                f.transferTo(new File(savePath));
                map.put("b_seq", b_seq);
                map.put("oriname", oriname);
                map.put("sysname", sysname);
                list.add(map);
            }
            for (int i = 0; i < list.size(); i++) {
                fileService.insertMap(list.get(i));
            }
        } else if (file != null && deleteSeq == null) {
            String path = "D:/storage/";
            File dir = new File(path);
            if (!dir.isDirectory()) {
                dir.mkdirs();
            }

            for (MultipartFile f : file) {
                Map<String, Object> map = new HashMap<>();

                String oriname = f.getOriginalFilename();
                if (oriname.equals("")) {
                    flag = false;
                }

                UUID uuid = UUID.randomUUID();
                String sysname = uuid + "_" + oriname;
                String savePath = path + sysname;

                f.transferTo(new File(savePath));
                map.put("b_seq", b_seq);
                map.put("oriname", oriname);
                map.put("sysname", sysname);
                list.add(map);
            }
            for (int i = 0; i < list.size(); i++) {
                fileService.insertMap(list.get(i));
            }
        }
        return "게시글 수정 완료";
    }

    @PostMapping("/img")
    @ResponseBody
    public String uploadSummernoteImageFile(@RequestParam("file") MultipartFile multipartFile, HttpServletRequest
            request) {
        JsonObject jsonObject = new JsonObject();

        String contextRoot = new HttpServletRequestWrapper(request).getRealPath("/");
        String fileRoot = contextRoot + "resources/img/";

        String originalFileName = multipartFile.getOriginalFilename();
        String extension = originalFileName.substring(originalFileName.lastIndexOf("."));
        String savedFileName = UUID.randomUUID() + extension;
        File targetFile = new File(fileRoot + savedFileName);
        try {
            InputStream fileStream = multipartFile.getInputStream();
            FileUtils.copyInputStreamToFile(fileStream, targetFile);
            jsonObject.addProperty("url", "/resources/img/" + savedFileName);

        } catch (IOException e) {
            e.printStackTrace();
        }
        String path = "/resources/img/" + savedFileName;
        return path;
    }
}



