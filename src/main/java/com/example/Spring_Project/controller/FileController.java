package com.example.Spring_Project.controller;

import com.example.Spring_Project.dto.FileDTO;
import com.example.Spring_Project.service.FileService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.*;

@Controller
@RequestMapping("/file")
public class FileController {

    @Autowired
    private FileService fileService;

    @ResponseBody
    @PostMapping("/insert")
    public Object insert(@RequestParam("b_seq") Integer b_seq, @RequestParam("file") List<MultipartFile> file) throws Exception {
        List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();

        if (!file.isEmpty()) {  //파일 있을 때

            String path = "D:/storage/";
            File dir = new File(path);
            if (!dir.isDirectory()) {
                dir.mkdirs();
            }

            for (MultipartFile f : file) {
                Map<String, Object> map = new HashMap<>();

                String oriname = f.getOriginalFilename();

                UUID uuid = UUID.randomUUID();
                String sysname = uuid + "_" + oriname;

                String savePath = path + sysname;

                f.transferTo(new File(savePath));
                map.put("b_seq", b_seq);
                map.put("oriname", oriname);
                map.put("sysname", sysname);
                list.add(map);
            }
        }

        Integer size = list.size();
        for (int i = 0; i < size; i++) {
            fileService.insertMap(list.get(i));
        }
        return list;
    }


    @ResponseBody
    @PostMapping("/download")   //파일 다운로드
    public void download(@RequestParam Integer f_seq, HttpServletResponse response, HttpServletRequest request) throws Exception {
        try {
            FileDTO fileDTO = fileService.getFileInfo(f_seq);
            String fileName = fileDTO.getOriname();
            String oriname = fileDTO.getOriname();
            String path = "D:\\storage\\" + fileDTO.getSysname();
            File file = new File(path);
            if (!file.isDirectory()) {
                file.mkdirs();
            }


            fileName = new String(fileName.getBytes("UTF-8"), "ISO-8859-1"); //한글
            response.setContentType("application/octet-stream;");
            response.setContentLength((int) file.length());
            response.setHeader("Content-Disposition", "attachment;filename=" + fileName + ";");
            response.setHeader("Content-Transfer-Encoding", "binary;");
            response.setHeader("Pragma", "no-cache;");
            response.setHeader("Expires", "-1;");

            byte readByte[] = new byte[4096];

            try {
                InputStream bufferedinputstream = new FileInputStream(file);
                int i;
                while ((i = bufferedinputstream.read(readByte, 0, 4096)) != -1) {
                    response.getOutputStream().write(readByte, 0, i);
                }
                bufferedinputstream.close();
            } catch (Exception _ex) {
                _ex.printStackTrace();
            } finally {
                response.getOutputStream().flush();
                response.getOutputStream().close();
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception("download error");
        }
    }

    @ResponseBody
    @RequestMapping("/addFile")
    public Object addFile(@RequestParam("file") List<MultipartFile> file) throws Exception {
        List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();

        if (!file.isEmpty()) {  //파일 있을 때

            String path = "D:/storage/";
            File dir = new File(path);
            if (!dir.isDirectory()) {
                dir.mkdirs();
            }

            for (MultipartFile f : file) {
                Map<String, Object> map = new HashMap<>();

                String oriname = f.getOriginalFilename();

                UUID uuid = UUID.randomUUID();
                String sysname = uuid + "_" + oriname;

                String savePath = path + sysname;

                f.transferTo(new File(savePath));
                map.put("oriname", oriname);
                map.put("sysname", sysname);
                list.add(map);
            }
        }

        Integer size = list.size();
        for (int i = 0; i < size; i++) {
            fileService.insertMap(list.get(i));
        }
        return list;
    }

}
