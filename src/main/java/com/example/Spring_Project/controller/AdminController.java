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
import org.dom4j.rule.Mode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
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
    private ProductService productService;
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
    private QnAService qnAService;

    @Autowired
    private PdReviewService pdReviewService;

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
    public String registeredPd(Model model, Integer cpage, String keyword) throws Exception {
        if (keyword == null) keyword = null;
        if (cpage == null) cpage = 1;
        Integer postCnt = productService.countRegisteredPd(); //상품 개수
        Map<String, Object> paging = productService.paging(cpage, postCnt);
        Integer naviPerPage = 10;
        Integer start = cpage * naviPerPage - (naviPerPage - 1); //시작 글 번호
        Integer end = cpage * naviPerPage; // 끝 글 번호
        List<ProductDTO> list = productService.getProducts(keyword, start, end); //상품정보
        List<OptionDTO> optionDTOList = null;
        List<Map<String, Object>> registeredPd = new ArrayList<>();
        Map<String, Object> tmp = null;
        for (ProductDTO productDTO : list) {
            tmp = new HashMap<>();
            Integer isOptExist = productService.isOptExist(productDTO.getPd_seq()); //상품의 옵션이 있는지 확인
            if (isOptExist != 0) { //상품의 옵션이 있을 경우F
                optionDTOList = productService.getOptByGroup(productDTO.getPd_seq());
                tmp.put("optionDTOList", optionDTOList);
            }
            tmp.put("productDTO", productDTO);
            registeredPd.add(tmp);
        }
        model.addAttribute("registeredPd", registeredPd);
        model.addAttribute("paging", paging);
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
    public String salesList(Model model, Integer cpage) throws Exception {
        if (cpage == null) cpage = 1;
        Integer postCnt = productService.countSalesPd(); //판매 상품 개수
        Map<String, Object> paging = productService.paging(cpage, postCnt);
        Integer naviPerPage = 10;
        Integer start = cpage * naviPerPage - (naviPerPage - 1); //시작 글 번호
        Integer end = cpage * naviPerPage; // 끝 글 번호

        JsonParser jsonParser = new JsonParser();
        JsonObject jsonObject = new JsonObject();
        JsonArray jsonArray = new JsonArray();

        List<SalesDTO> salesDTOS = productService.getSalesList(start, end);//판매 테이블에서 가져오기
        List<Map<String, Object>> paramList = new ArrayList<>();
        for (SalesDTO salesDTO : salesDTOS) {
            Map<String, Object> param = new HashMap<>();
            if (salesDTO.getPdOption() != null) { //옵션 있을때 size : s
                List<Map<String, Object>> optionMapList = null;
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
                    optionMap.put(optCategory, optName);
                    optionMapList.add(optionMap);
                }
                if (optionMapList.size() != 0) param.put("optionMapList", optionMapList);
            }
//            PayProductDTO payProductDTO = productService.getDeliYN(salesDTO.getSales_seq()); // deliYN, CODE 가져오기
//            PayProductDTO payProductDTO = productService.getDeliYN(salesDTO.getSales_seq()); // deliYN, CODE 가져오기
            String deliYN = productService.getDeliYN(salesDTO.getSales_seq()); // deliYN, CODE 가져오기
            param.put("id", salesDTO.getId());
            param.put("stock", salesDTO.getStock());
            param.put("price", salesDTO.getPrice());
            param.put("salesDate", salesDTO.getSalesDate());
//            param.put("deliYN", salesDTO.getDeliYN());
            param.put("sales_seq", salesDTO.getSales_seq());
            ProductDTO productDTO = productService.getPdInfo(salesDTO.getPd_seq());//상품 관련 정보
            param.put("productDTO", productDTO);
            Integer pdStock = productService.getPdStock(salesDTO.getPd_seq());//판매하고 남은 상품 개수
            param.put("pdStock", pdStock);
            param.put("deliYN", deliYN);
//            if( payProductDTO.getCode() != null){
//                param.put("code", payProductDTO.getCode());
//            }
//            param.put("optionMapList",optionMapList);
            System.out.println("param ': " + param.get("deliYN"));
            paramList.add(param);
        }
        model.addAttribute("paramList", paramList);
        model.addAttribute("paging", paging);
        return "/admin/salesList";
    }

    @RequestMapping("/chgDeliStatus")
    public String chgDeliStatus(Model model, @RequestParam Integer sales_seq) throws Exception {
        //택배사 정보 가져오기
        List<CourierDTO> courierDTOS = productService.getCourierInfo();
        model.addAttribute("courierDTOS", courierDTOS);
        model.addAttribute("sales_seq", sales_seq);
        return "/admin/deliPopup";
    }

    @GetMapping("/qNa") //관리자 -> Q&A 조회
    public String toQnAList(Model model, Integer cpage) throws Exception {
        if (cpage == null) cpage = 1;
        Integer postCnt = qnAService.countQuestion(); //질문 개수
        Map<String, Object> paging = productService.paging(cpage, postCnt);
        Integer naviPerPage = 10;
        Integer start = cpage * naviPerPage - (naviPerPage - 1); //시작 글 번호
        Integer end = cpage * naviPerPage; // 끝 글 번호

        List<QuestionDTO> questionDTOS = qnAService.qNaList(start, end);
        List<Map<String, Object>> qNaList = qnAService.getQnAList(questionDTOS);
        model.addAttribute("qNaList", qNaList);
        model.addAttribute("paging", paging);
        return "/admin/qNaList";
    }


    @ResponseBody
    @PostMapping("/qNaRepaging")
    public List<Object> rePagingSalesList(Integer cpage) throws Exception {
        Integer naviPerPage = 10;
        Map<String, Object> pagingStartEnd = productService.pagingStartEnd(cpage, naviPerPage);
        Integer start = Integer.parseInt(pagingStartEnd.get("start").toString());
        Integer end = Integer.parseInt(pagingStartEnd.get("end").toString());
        Integer postCnt = qnAService.countQuestion(); //질문 개수
        List<QuestionDTO> questionDTOS = qnAService.qNaList(start, end);
        Map<String, Object> paging = productService.paging(cpage, postCnt);
        List<Object> qNaList = qnAService.repaging(questionDTOS, paging);
        return qNaList;
    }

    @GetMapping("/reviews")   //처음 필터 선택된 리뷰 가져오기
    public String getPdReviews(Model model, Integer cpage) throws Exception {
        Map<String, Object> optionMap = new HashMap<>();

        if (cpage == null) cpage = 1;
        Integer postCnt = productService.countReview(); //판매 상품 개수
        Map<String, Object> paging = productService.paging(cpage, postCnt);
        Integer naviPerPage = 10;
        Integer start = cpage * naviPerPage - (naviPerPage - 1); //시작 글 번호
        Integer end = cpage * naviPerPage; // 끝 글 번호


        List<Object> pdReviewDTOS = new ArrayList<>();
        List<ParsedReviewDTO> reviewDTOS = pdReviewService.getReviews(start, end); //처음 리뷰 리스트
        adminService.insertRevSeq(reviewDTOS); //insert
        List<ParsedReviewDTO2> objectList = adminService.reviewByOptList(reviewDTOS);
        List<Map<String, Object>> reviewList = pdReviewService.reviewListByOptions(objectList, paging);//관리자 리뷰 조회에 뿌릴 데이터
        //부모 카테고리
        List<String> parentCategory = productService.getParentCategory();
        //자식 카테고리
        List<String> childCategory = productService.getChildCategory();

        model.addAttribute("reviewList", reviewList);
        model.addAttribute("parentCategory", parentCategory); //부모 카테고리
        model.addAttribute("childCategory", childCategory); //자식 카테고리
        model.addAttribute("optionMap", optionMap);  //처음 옵션 값
        model.addAttribute("paging", paging);  //처음 옵션 값
        return "/admin/pdReviews";
    }

    @ResponseBody
    @PostMapping("/delReview")
    public String delReview(Integer r_seq) throws Exception {
        adminService.delReview(r_seq);
        return "success";
    }

    @ResponseBody
    @PostMapping("/reviewsByOption") //관리자 리뷰 조회 필터링
    public List<Map<String, Object>> reviewsByOption(@RequestParam Map<String, Object> data) throws Exception {
        Integer naviPerPage = 10;
        Integer cpage = Integer.parseInt(data.get("cpage").toString());
        Map<String, Object> pagingStartEnd = productService.pagingStartEnd(cpage, naviPerPage);
        Integer start = Integer.parseInt(pagingStartEnd.get("start").toString());
        Integer end = Integer.parseInt(pagingStartEnd.get("end").toString());


        List<String> parentCategoryArr = new ArrayList<>(List.of(data.get("parentCategoryArr").toString().split(",")));
        List<String> childCategoryArr = new ArrayList<>(List.of(data.get("childCategoryArr").toString().split(",")));

        List<String> pcArr = adminService.parentCategoryArr(parentCategoryArr); //name 바꾼 부모 카테고리 list
        List<String> chCArr = adminService.childCategoryArr(childCategoryArr); //name 바꾼 자식 카테고리 list
        List<String> starArr = new ArrayList<>(List.of(data.get("starArr").toString().split(","))); //star list

        String selectType = data.get("selectType").toString();
        String keyword = data.get("keyword").toString();
        if (keyword.length() == 0) {
            keyword = null;   //keyword에서 에러
        }
        String time = data.get("time").toString();

        Integer postCnt = qnAService.filteredReviewCnt(pcArr, chCArr, starArr, selectType, keyword);//필터링된 리뷰 개수

        Map<String, Object> paging = productService.paging(cpage, postCnt);

        List<ParsedReviewDTO> mapList = adminService.reviewsByOptions(pcArr, chCArr, starArr, selectType, keyword, time, start, end);//필터링된 리뷰 가져오기
        adminService.insertRevSeq(mapList); //insert
        List<ParsedReviewDTO2> objectList = adminService.reviewByOptList(mapList);
        List<Map<String, Object>> reviewList = pdReviewService.reviewListByOptions(objectList, paging);//관리자 리뷰 조회에 뿌릴 데이터
        return reviewList;
    }

    @ResponseBody
    @PostMapping("repagingRefundList")
    public Map<String, Object> repagingRefundList(@RequestParam String type, @RequestParam  Integer cpage) throws Exception {
        Map<String, Object> remap = new HashMap<>();
        if (cpage == null) cpage = 1;
        Integer postCnt = productService.refundCntByType(type); //교환/환불 개수
        Map<String, Object> paging = productService.paging(cpage, postCnt);
        Integer naviPerPage = 10;
        Integer start = cpage * naviPerPage - (naviPerPage - 1); //시작 글 번호
        Integer end = cpage * naviPerPage; // 끝 글 번호
        List<RefundDTO> refundDTOList = productService.refundListByType(start,end,type);
        List<Object> refundInfoList = productService.getRefundInfo(refundDTOList);
        remap.put("paging", paging);
        remap.put("refundInfoList", refundInfoList);
        return remap;
    }

    @RequestMapping("/refund")  //교환 및 반품 조회
    public String toAdminRefundList(Model model, Integer cpage) throws Exception {
        if (cpage == null) cpage = 1;
        Integer postCnt = productService.refundCount(); //교환/환불 개수
        Map<String, Object> paging = productService.paging(cpage, postCnt);
        Integer naviPerPage = 10;
        Integer start = cpage * naviPerPage - (naviPerPage - 1); //시작 글 번호
        Integer end = cpage * naviPerPage; // 끝 글 번호

        List<RefundDTO> refundDTOList = productService.refundList(start, end);
        List<Object> refundInfoList = productService.getRefundInfo(refundDTOList);
        model.addAttribute("paging", paging);
        model.addAttribute("refundInfoList", refundInfoList);
        // SELECT * FROM PAYINFO p  WHERE PAY_SEQ  IN (SELECT pay_seq FROM PAYPRODUCT p WHERE PAYPD_SEQ = 176); 가격,개수,사용포인트 가져옴
        // 사용포인트 있으면  사용포인트/개수
        //현금도 상품원래 가격 - ( 사용포인트/개수) 반환
        return "/admin/refundList";
    }

    @PostMapping("/approveExchg") //교환 승인 팝업
    public String approveRefund(Model model, @RequestParam Integer payPd_seq, @RequestParam Integer refund_seq) throws Exception {
        List<CourierDTO> courierDTOS = productService.getCourierInfo();
        model.addAttribute("courierDTOS", courierDTOS);
        model.addAttribute("payPd_seq", payPd_seq);
        model.addAttribute("refund_seq", refund_seq);
        return "/admin/approveExchgPopup";
    }
    @ResponseBody
    @PostMapping("/approveRfd") //환불 완료하면 멤버 포인트 증가
    public String insertRefund(Model model, @RequestParam Integer payPd_seq, @RequestParam Integer refund_seq) throws Exception {
        productService.increaseMemPoint(payPd_seq,refund_seq); //멤버 포인트 증가
        adminService.insertSRefund(payPd_seq,refund_seq); // shopRefund 테이블 인서트
        //해당 payPd_seq reufund status y로 변경
        productService.chgRefundStatus(payPd_seq, refund_seq);

        //상품 재고 , 옵션 재고 증가
        //productService.increasePdStock(payPd_seq);

        return "success";
    }

    @ResponseBody
    @PostMapping("/appreExchg") //관리자가 교환 승인할때 db인서트
    public String apprRefund(@RequestParam Map<String, Object> map) throws Exception {
        String name = map.get("courier").toString();
        Integer courierCode = productService.getCourierCode(name);//택배사 코드
        map.put("code", courierCode);
        //승인처리 db에 인서트
        adminService.insertShopRefund(map);
        Integer payPd_seq = Integer.parseInt(map.get("payPd_seq").toString());
        Integer refund_seq = Integer.parseInt(map.get("refund_seq").toString());
        //해당 payPd_seq reufund status y로 변경
        productService.chgRefundStatus(payPd_seq, refund_seq);
        return "success";
    }
}


