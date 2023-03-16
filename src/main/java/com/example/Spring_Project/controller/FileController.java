package com.example.Spring_Project.controller;

import com.example.Spring_Project.dto.FileDTO;
import com.example.Spring_Project.service.FileService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.parameters.P;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.util.*;

@Controller
@RequestMapping("/file")
public class FileController {

    @Autowired
    private FileService fileService;

    @ResponseBody
    @PostMapping("/insert")
    public Object insert(@RequestParam("b_seq") Integer b_seq, @RequestParam("file") List<MultipartFile> file) throws Exception {
        System.out.println("file.size : " + file.size());

        List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();

        if (!file.isEmpty()) {  //파일 있으면

            String path = "D:/storage/";  //파일이 저장될 경로 설정
            File dir = new File(path);
            if (!dir.isDirectory()) {
                dir.mkdirs();
            }

            for (MultipartFile f : file) {
                Map<String, Object> map = new HashMap<>();
                //파일 이름을 String 값으로 반환한다
                System.out.println("파일 이름(uploadfile.getOriginalFilename()) : " + f.getOriginalFilename());

                String oriname = f.getOriginalFilename();

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
        }

        System.out.println(list.size());
        //fileService.insert(list);

        for (int i = 0; i < list.size(); i++) {
            fileService.insertMap(list.get(i));
        }
        return list;
    }


    @ResponseBody
    @PostMapping("/download")   //파일 다운로드
    public String download(@RequestParam Integer f_seq, HttpServletResponse response) throws Exception {
        try {
            FileDTO fileDTO = fileService.getFileInfo(f_seq);
            String oriname = fileDTO.getOriname();
            String path = "D:\\storage\\"+ fileDTO.getSysname(); // 경로에 접근할 때 역슬래시('\') 사용

            File file = new File(path);
            if (!file.isDirectory()) {
                file.mkdirs();
            }

            // file 다운로드 설정
            response.setContentType("application/download");
            response.setContentLength((int)file.length());
            response.setHeader("Content-disposition", "attachment;filename=\"" + file.getName() + "\"");
            // 파일 입력 객체 생성
            FileInputStream fileInputStream = new FileInputStream(path); // 파일 읽어오기
            OutputStream out = response.getOutputStream();
            int read = 0;
            byte[] buffer = new byte[1024];
            while ((read = fileInputStream.read(buffer)) != -1) { // 1024바이트씩 계속 읽으면서 outputStream에 저장, -1이 나오면 더이상 읽을 파일이 없음
                out.write(buffer, 0, read);
            }

            /*response.setHeader("Content-Disposition", "attachment;filename=" + file.getName()); // 다운로드 되거나 로컬에 저장되는 용도로 쓰이는지를 알려주는 헤더
            System.out.println("path : "+path);

            FileInputStream fileInputStream = new FileInputStream(path); // 파일 읽어오기
            OutputStream out = response.getOutputStream();

            int read = 0;
            byte[] buffer = new byte[1024];
            while ((read = fileInputStream.read(buffer)) != -1) { // 1024바이트씩 계속 읽으면서 outputStream에 저장, -1이 나오면 더이상 읽을 파일이 없음
                out.write(buffer, 0, read);
            }*/

        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception("download error");
        }
        return "다운로드 성공";
    }
}
