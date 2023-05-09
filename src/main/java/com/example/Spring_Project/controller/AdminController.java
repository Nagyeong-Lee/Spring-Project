package com.example.Spring_Project.controller;

import com.example.Spring_Project.dto.*;
import com.example.Spring_Project.service.*;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.fileupload.disk.DiskFileItem;
import org.apache.commons.io.IOUtils;
import org.apache.poi.ss.usermodel.Row;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.multipart.commons.CommonsMultipartFile;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.nio.file.Files;
import java.util.*;

@Slf4j
@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private AdminService adminService;

    @Autowired
    private BCryptPasswordEncoder BCryptPasswordEncoder;

    @Autowired
    private HttpSession session;

    @Autowired
    private PathService pathService;

    @Autowired
    private LogService logService;

    @Autowired
    private BoardService boardService;

    @Autowired
    private ProductService productService;

    @RequestMapping("/main")  //회원 리스트 출력
    public String toAdminMain(Model model) throws Exception {
        List<MemberDTO> list = adminService.selectMemberList();
        String logoutPath = pathService.getLogoutPath();
        model.addAttribute("logoutPath", logoutPath);
        return "/admin/main";

    }

    @RequestMapping("/chart") //분기별 회원가입 수
    public String toChart(Model model) throws Exception {
        Integer count1 = adminService.select1();
        Integer count2 = adminService.select2();
        Integer count3 = adminService.select3();
        Integer count4 = adminService.select4();
        ArrayList<Integer> list = new ArrayList<>();
        list.add(count1);
        list.add(count2);
        list.add(count3);
        list.add(count4);
        model.addAttribute("list", list);
        return "/admin/memberChart";
    }

    @RequestMapping("/download") // 회원 리스트 다운
    public void download(HttpServletResponse response) throws Exception {
        adminService.downloadList(response);
    }

    @ResponseBody  //엑셀 업로드
    @PostMapping("/upload")
    public String excelUploadAjax(@RequestParam MultipartFile fileExcel, MultipartHttpServletRequest request) throws Exception {

        MultipartFile excelFile = request.getFile("fileExcel");

        if (excelFile == null || excelFile.isEmpty()) {

            throw new RuntimeException("엑셀파일을 선택해 주세요.");
        }

        String path = "D:\\excelUpload\\";
        File dir = new File(path);
        if (!dir.isDirectory()) {
            dir.mkdirs();
        }


        File destFile = new File(path + excelFile.getOriginalFilename());

        try {
            excelFile.transferTo(destFile);

        } catch (Exception e) {
            throw new RuntimeException(e.getMessage(), e);
        }

        DiskFileItem fileItem = new DiskFileItem("file", Files.probeContentType(destFile.toPath()), false, destFile.getName(), (int) destFile.length(), destFile.getParentFile());

        InputStream input = new FileInputStream(destFile);
        OutputStream os = fileItem.getOutputStream();
        IOUtils.copy(input, os);

        MultipartFile multipartFile = new CommonsMultipartFile(fileItem);

        boolean result = adminService.excelUpload(multipartFile);

//        ModelAndView view = new ModelAndView();
//
//        view.setViewName("/admin/main");
//
//        return view;

        if (result == true) {
            return "success";
        } else {
            return "fail";
        }
    }

    @RequestMapping("/mngMember")
    public String mngMember(Model model) throws Exception {
        List<MemberDTO> list = adminService.selectMemberList();
        Integer size = list.size();
        for (Integer i = 0; i < size - 1; i++) {
            Integer length = 0;
            //아이디
            String id = list.get(i).getId();
            length = id.length() - 2;
            id = id.substring(0, length) + "***";  // 뒷 2자리 ***
            list.get(i).setId(id);
            //이름
            String name = list.get(i).getName();
            String name2 = list.get(i).getName();
            String str = "";
            if (name.length() == 2) {
                length = name.length() - 1;
                name = name.substring(0, length) + "*";  // 뒷 1자리 *
            } else if (name.length() == 3) {
                name = name.substring(0, 1) + "*" + name.substring(2, 3);  // 가운데 *
            } else {
                length = name.length() - 2;
                name = name.substring(0, length);
                for (int k = length; k < name2.length(); k++) {
                    str += "*";
                }
            }
            list.get(i).setName(name);
            //이메일
            String email = list.get(i).getEmail();
            length = email.length();
            Integer index = email.indexOf("@");
            String newEmail = "";
            for (int j = 0; j < index; j++) {
                newEmail += "*";
            }
            email = newEmail + list.get(i).getEmail().substring(index, length);
            list.get(i).setEmail(email);
            //전화번호
            String phone = list.get(i).getPhone().substring(0, 3) + "****" + list.get(i).getPhone().substring(7, 11);
            list.get(i).setPhone(phone);

        }
        model.addAttribute("list", list);
        return "/admin/memberMng";
    }


    @RequestMapping("/list") // 게시글 리스트
    public String logList(Model model,
                          @RequestParam Integer currentPage,
                          @RequestParam Integer count,
                          @RequestParam(required = false) Integer postNum,
                          @RequestParam(required = false) String searchType,
                          @RequestParam(required = false) String keyword) throws Exception {

        if (currentPage == null) {
            currentPage = 1;
        }

        //게시글 개수 기본 10
        if (count == null) {
            count = 10;
        }

//        Integer totalLog = logService.countLog(searchType, keyword);  //전체 로그 개수
        Integer start = currentPage * count - (count - 1); //시작 글 번호
        Integer end = currentPage * count; // 끝 글 번호

        List<LogDTO> list = logService.selectLog(start, end, searchType, keyword);
        String paging = logService.getLogPageNavi(currentPage, count, searchType, keyword, postNum);

        Integer currPage = currentPage;
        model.addAttribute("list", list);
        model.addAttribute("paging", paging);
        model.addAttribute("searchType", searchType);
        model.addAttribute("keyword", keyword);
        model.addAttribute("currPage", currPage);
        model.addAttribute("count", count);
        model.addAttribute("postNum", postNum);
        return "/admin/logCheck";
    }

    @RequestMapping("/registerPd")
    public String registerPd() throws Exception {
        return "/admin/registerPd";
    }

    //등록한 상품 조회
    @RequestMapping("/registeredPd")
    public String registeredPd(Model model) throws Exception {
        List<ProductDTO> list = productService.getProducts(); //상품정보
        List<OptionDTO> optionDTOList = null;
        List<Map<String, Object>> registeredPd = new ArrayList<>();
        Map<String, Object> tmp = null;
        for (ProductDTO productDTO : list) {
            tmp = new HashMap<>();
            Integer isOptExist = productService.isOptExist(productDTO.getPd_seq()); //상품의 옵션이 있는지 확인
            if (isOptExist != 0) { //상품의 옵션이 있을 경우
                optionDTOList = productService.getOptByGroup(productDTO.getPd_seq());
                tmp.put("optionDTOList", optionDTOList);
            }
            System.out.println("isOptExist = " + isOptExist);
            tmp.put("productDTO", productDTO);
            registeredPd.add(tmp);
        }
        model.addAttribute("registeredPd", registeredPd);
        return "/admin/registeredPd";

    }

    @RequestMapping("/updProduct")
    public String updProduct(Model model, Integer pd_seq) throws Exception {
        Map<String, Object> map = new HashMap<>();
        ProductDTO productDTO = productService.getPdInfo(pd_seq); //상품정보
        map.put("productDTO", productDTO);

        CategoryDTO pdSubCategory = productService.getPdCategory(productDTO.getCategory());//상품 상위 카테고리 (상의/하의)
        CategoryDTO pdMainCategory = productService.getPdSubCategory(pdSubCategory.getParent_category_seq());//상품 하위 카테고리 (남성/여성)
        map.put("pdSubCategory", pdSubCategory.getName());
        map.put("pdMainCategory", pdMainCategory.getName());

        Integer isOptExist = productService.isOptExist(pd_seq); //상품의 옵션이 있는지 확인
        if (isOptExist != 0) { //상품의 옵션이 있을 경우
            List<OptionDTO> optionDTOList = productService.getOptByGroup(pd_seq);
            map.put("optionDTOList", optionDTOList);
        }
        model.addAttribute("map", map);
        return "/admin/updProduct";
    }

    @RequestMapping("/salesList") //판매 정보 조회
    public String salesList(Model model) throws Exception {
        JsonParser jsonParser = new JsonParser();
        JsonObject jsonObject = new JsonObject();
        JsonArray jsonArray = new JsonArray();

        List<SalesDTO> salesDTOS = productService.getSalesList();//판매 테이블에서 가져오기
        System.out.println("salesDTOS = " + salesDTOS);
        List<Map<String, Object>> paramList = new ArrayList<>();
        List<Map<String, Object>> optionMapList = null;
        for (SalesDTO salesDTO : salesDTOS) {
            Map<String, Object> param = new HashMap<>();
            if (salesDTO.getPdOption() != null) { //옵션 있을때 size : s
                param.put("option", salesDTO.getPdOption());
                    Object object = jsonParser.parse(salesDTO.getPdOption());
                    jsonObject = (JsonObject) object;
                    jsonArray = (JsonArray) jsonObject.get("name");
                    optionMapList = new ArrayList<>();
                    Map<String, Object> optionMap = null;

                    for (int i = 0; i < jsonArray.size(); i++) {
                        optionMap = new HashMap<>();
                        //size = s
                        String optName = jsonArray.get(i).toString().replace("\"", "");
                        String optCategory = productService.getOptCategory(salesDTO.getPd_seq(), optName); //옵션 카테고리 이름 가져오기 (size)
                        System.out.println("optName = " + optName);
                        System.out.println("optCategory = " + optCategory);
                        optionMap.put(optCategory, optName);
                        optionMapList.add(optionMap);
                    }

                }
            param.put("id", salesDTO.getId());
            param.put("stock", salesDTO.getStock());
            param.put("price", salesDTO.getPrice());
            param.put("salesDate", salesDTO.getSalesDate());
            param.put("deliYN", salesDTO.getDeliYN());
            ProductDTO productDTO = productService.getPdInfo(salesDTO.getPd_seq());//상품 관련 정보
            param.put("productDTO", productDTO);
            Integer pdStock = productService.getPdStock(salesDTO.getPd_seq());//판매하고 남은 상품 개수
            param.put("pdStock",pdStock);
            param.put("optionMapList",optionMapList);
            paramList.add(param);
            }
        model.addAttribute("paramList", paramList);
        return "/admin/salesList";
    }

    @RequestMapping("/chgDeliStatus")
    public String chgDeliStatus() throws Exception{
        return "/admin/deliPopup";
    }
}


