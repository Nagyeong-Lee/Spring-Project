package com.example.Spring_Project.controller;

import com.example.Spring_Project.service.FileService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.parameters.P;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.util.*;

@Controller
@RequestMapping("/file")
public class FileController {

    @Autowired
    private FileService fileService;

    @ResponseBody
    @PostMapping("/insert")
    public Object insert(@RequestParam ("b_seq") Integer b_seq, @RequestParam("file") List<MultipartFile> file) throws Exception {
        System.out.println("file.size : "+file.size());

        List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();

        if (!file.isEmpty()) {  //파일 있으면

            String path = "C:/storage/";  //파일이 저장될 경로 설정
            File dir = new File(path);
            if (!dir.isDirectory()) {
                dir.mkdirs();
            }

            for (MultipartFile f : file) {
                Map<String,Object>map=new HashMap<>();
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

        for(int i = 0 ; i < list.size() ; i++){
            fileService.insertMap(list.get(i));
        }
        return list;
    }
}
