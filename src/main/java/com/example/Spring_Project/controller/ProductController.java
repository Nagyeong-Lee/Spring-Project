package com.example.Spring_Project.controller;

import com.example.Spring_Project.dto.*;
import com.example.Spring_Project.service.*;
import com.google.gson.*;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.security.core.parameters.P;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.DefaultTransactionDefinition;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.sql.Timestamp;
import java.util.*;

@Controller
@RequestMapping("/product")
public class ProductController {

    @Autowired
    private ProductService productService;

    @Autowired
    private HttpSession httpSession;

    @Autowired
    private MemberService memberService;

    @Autowired
    private PayService payService;

    @Autowired
    private PdReviewService pdReviewService;

    @Autowired
    private QnAService qnAService;

    @Autowired
    private SqlSession sqlSession;

    @Autowired
    private DataSourceTransactionManager transactionManager;

    @RequestMapping("/list") //전체 상품 리스트
    public String productList(Model model, Integer cpage, String keyword) throws Exception {
        if (keyword == null) keyword = null;
        if (cpage == null) cpage = 1;
        Map<String, Object> paging = productService.pagingPdList(cpage, keyword);
        Integer naviPerPage = 10;
        Map<String, Object> pagingStartEnd = productService.pagingStartEnd(cpage, naviPerPage); //시작 글번호,끝 글번호 계산
        Integer start = Integer.parseInt(pagingStartEnd.get("start").toString());
        Integer end = Integer.parseInt(pagingStartEnd.get("end").toString());

        List<ProductDTO> productDTOList = productService.getProducts(keyword, start, end);
        model.addAttribute("productDTOList", productDTOList);
        model.addAttribute("paging", paging);
        return "/product/productList";
    }

    //상품 디테일
    @RequestMapping("/detail")
    public String detail(Model model, Integer pd_seq) throws Exception {
        ProductDTO productDTO = productService.getProductDetail(pd_seq); //상품 상세 정보
        List<OptionDTO> optionDTO = productService.getOptions(pd_seq); //상품 옵션 정보
        productService.checkOptionStock(optionDTO);
        Integer stock = productService.getPdStock(pd_seq);
//        if(stock == 0){
//            //상품 status n으로
//            productService.updatePdStatus(pd_seq);
//        }
        List<String> category = productService.getCategory(pd_seq);//옵션 카테고리
        Map<String, List<OptionListDTO>> optionList = productService.pdDetail(optionDTO, category, pd_seq);

        //대시보드
        Double starAvg = pdReviewService.starAvg(pd_seq); //상품 별점평균
        Integer reviewCnt = pdReviewService.reviewCnt(pd_seq);//상품 리뷰 수
        List<String> dashBoardImgs = pdReviewService.reviewImgsByPd_seq(pd_seq); //리뷰 이미지들


        //Q&A 뿌리기
        List<QuestionDTO> questionDTOS = qnAService.getQuestions(pd_seq); // 질문들 가져오기
        List<Map<String, Object>> qNaList = qnAService.getQnAList(questionDTOS);  //{질문 , 답변}


        //상품 detail에 리뷰 뿌리기
        List<ReviewDTO> reviewDTO = pdReviewService.getReviewByPd_seq(pd_seq);  //리뷰 가져옴
        List<Map<String, Object>> reviewInfoList = pdReviewService.reviewInfoList(reviewDTO, pd_seq);
        model.addAttribute("productDTO", productDTO);
        model.addAttribute("optionDTO", optionDTO);
        model.addAttribute("category", category);
        model.addAttribute("optionList", optionList);
        model.addAttribute("starAvg", starAvg);
        model.addAttribute("reviewCnt", reviewCnt);
        model.addAttribute("reviewInfoList", reviewInfoList);
        model.addAttribute("dashBoardImgs", dashBoardImgs);
        model.addAttribute("qNaList", qNaList);
        model.addAttribute("stock", stock);
        return "/product/detail";
    }

    //여성 카테고리
    @RequestMapping("/women")
    public String wProduct(Model model, Integer cpage) throws Exception {
        if (cpage == null) cpage = 1;
        Integer postCnt = productService.wCnt(); //상품 개수
        Map<String, Object> paging = productService.paging(cpage, postCnt);
        Integer naviPerPage = 10;
        Integer start = cpage * naviPerPage - (naviPerPage - 1); //시작 글 번호
        Integer end = cpage * naviPerPage; // 끝 글 번호
        List<ProductDTO> productDTOList = productService.getWProduct();
        model.addAttribute("productDTOList", productDTOList);
        model.addAttribute("paging", paging);
        return "/product/women";
    }

    @RequestMapping("/women/outer")
    public String wOuter(Model model, Integer cpage) throws Exception {
        if (cpage == null) cpage = 1;
        Integer postCnt = productService.wOuterCnt(); //상품 개수
        Map<String, Object> paging = productService.paging(cpage, postCnt);
        Integer naviPerPage = 10;
        Integer start = cpage * naviPerPage - (naviPerPage - 1); //시작 글 번호
        Integer end = cpage * naviPerPage; // 끝 글 번호
        List<ProductDTO> productDTOList = productService.getWOuter(start, end);
        model.addAttribute("productDTOList", productDTOList);
        model.addAttribute("paging", paging);
        return "/product/women/outer";
    }

    @ResponseBody
    @PostMapping("repagingList") //상위 하위 카테고리
    public Map<String, Object> repagingList(@RequestParam String parentCategory, @RequestParam String childCategory, @RequestParam Integer cpage) throws Exception {
        Map<String, Object> remap = new HashMap<>();
        Integer parent_category_seq = productService.getParentCategorySeq(parentCategory);
        Integer child_category_seq = productService.getChildCategorySeq(parent_category_seq, childCategory);
        if (cpage == null) cpage = 1;
        Integer postCnt = productService.pdCntByCategory(child_category_seq); //교환/환불 개수
        Map<String, Object> paging = productService.paging(cpage, postCnt);
        Integer naviPerPage = 10;
        Integer start = cpage * naviPerPage - (naviPerPage - 1); //시작 글 번호
        Integer end = cpage * naviPerPage; // 끝 글 번호
        List<ProductDTO> productDTOList = productService.pdListByCategory(start, end, child_category_seq);
        remap.put("paging", paging);
        remap.put("productDTOList", productDTOList);
        return remap;
    }

    @ResponseBody
    @PostMapping("repagingPcategory") // 상위 카테고리 여성
    public Map<String, Object> repagingPcategory(@RequestParam String parentCategory, @RequestParam Integer cpage) throws Exception {
        Map<String, Object> remap = new HashMap<>();
        Integer parent_category_seq = productService.getParentCategorySeq(parentCategory);
        if (cpage == null) cpage = 1;
        Integer postCnt = productService.pdCountByParent_category();
        Map<String, Object> paging = productService.paging(cpage, postCnt);
        Integer naviPerPage = 10;
        Integer start = cpage * naviPerPage - (naviPerPage - 1); //시작 글 번호
        Integer end = cpage * naviPerPage; // 끝 글 번호
        List<ProductDTO> productDTOList = productService.pdListByParentCategory(start, end);
        remap.put("paging", paging);
        remap.put("productDTOList", productDTOList);
        return remap;
    }

    @ResponseBody
    @PostMapping("repagingMen") // 상위 카테고리 남성
    public Map<String, Object> repagingMen(@RequestParam String parentCategory, @RequestParam Integer cpage) throws Exception {
        Map<String, Object> remap = new HashMap<>();
        Integer parent_category_seq = productService.getParentCategorySeq(parentCategory);
        if (cpage == null) cpage = 1;
        Integer postCnt = productService.pdCountByMen();
        Map<String, Object> paging = productService.paging(cpage, postCnt);
        Integer naviPerPage = 10;
        Integer start = cpage * naviPerPage - (naviPerPage - 1); //시작 글 번호
        Integer end = cpage * naviPerPage; // 끝 글 번호
        List<ProductDTO> productDTOList = productService.pdListByMen(start, end);
        remap.put("paging", paging);
        remap.put("productDTOList", productDTOList);
        return remap;
    }

    @ResponseBody
    @PostMapping("repagingNew") // 상위 카테고리 신상품
    public Map<String, Object> repagingNew(@RequestParam String parentCategory, @RequestParam Integer cpage) throws Exception {
        Map<String, Object> remap = new HashMap<>();
        Integer parent_category_seq = productService.getParentCategorySeq(parentCategory);
        if (cpage == null) cpage = 1;
        Integer postCnt = productService.pdCountByNew();
        Map<String, Object> paging = productService.paging(cpage, postCnt);
        Integer naviPerPage = 10;
        Integer start = cpage * naviPerPage - (naviPerPage - 1); //시작 글 번호
        Integer end = cpage * naviPerPage; // 끝 글 번호
        List<ProductDTO> productDTOList = productService.pdListByNew(start, end);
        remap.put("paging", paging);
        remap.put("productDTOList", productDTOList);
        return remap;
    }

    @RequestMapping("/women/top")
    public String wTop(Model model, Integer cpage) throws Exception {
        if (cpage == null) cpage = 1;
        Integer postCnt = productService.wTopCnt(); //상품 개수
        Map<String, Object> paging = productService.paging(cpage, postCnt);
        Integer naviPerPage = 10;
        Integer start = cpage * naviPerPage - (naviPerPage - 1); //시작 글 번호
        Integer end = cpage * naviPerPage; // 끝 글 번호
        List<ProductDTO> productDTOList = productService.getWTop();
        model.addAttribute("productDTOList", productDTOList);
        model.addAttribute("paging", paging);
        return "/product/women/top";
    }

    @RequestMapping("/women/pants")
    public String wPants(Model model, Integer cpage) throws Exception {
        if (cpage == null) cpage = 1;
        Integer postCnt = productService.wPantsCnt(); //상품 개수
        Map<String, Object> paging = productService.paging(cpage, postCnt);
        Integer naviPerPage = 10;
        Integer start = cpage * naviPerPage - (naviPerPage - 1); //시작 글 번호
        Integer end = cpage * naviPerPage; // 끝 글 번호
        List<ProductDTO> productDTOList = productService.getWPants();
        model.addAttribute("productDTOList", productDTOList);
        model.addAttribute("paging", paging);
        return "/product/women/pants";
    }

    @RequestMapping("/women/accessories")
    public String wAccessories(Model model, Integer cpage) throws Exception {
        if (cpage == null) cpage = 1;
        Integer postCnt = productService.wAccCnt(); //상품 개수
        Map<String, Object> paging = productService.paging(cpage, postCnt);
        Integer naviPerPage = 10;
        Integer start = cpage * naviPerPage - (naviPerPage - 1); //시작 글 번호
        Integer end = cpage * naviPerPage; // 끝 글 번호
        List<ProductDTO> productDTOList = productService.getWAccessories();
        model.addAttribute("productDTOList", productDTOList);
        model.addAttribute("paging", paging);
        return "/product/women/accessories";
    }

    //남성 카테고리
    @RequestMapping("/men")
    public String mProduct(Model model, Integer cpage) throws Exception {
        if (cpage == null) cpage = 1;
        Integer postCnt = productService.mCnt(); //상품 개수
        Map<String, Object> paging = productService.paging(cpage, postCnt);
        Integer naviPerPage = 10;
        Integer start = cpage * naviPerPage - (naviPerPage - 1); //시작 글 번호
        Integer end = cpage * naviPerPage; // 끝 글 번호
        List<ProductDTO> productDTOList = productService.getMProduct();
        model.addAttribute("productDTOList", productDTOList);
        model.addAttribute("paging", paging);
        return "/product/men";
    }

    @RequestMapping("/men/outer")
    public String mOuter(Model model, Integer cpage) throws Exception {
        if (cpage == null) cpage = 1;
        Integer postCnt = productService.mOuter(); //상품 개수
        Map<String, Object> paging = productService.paging(cpage, postCnt);
        Integer naviPerPage = 10;
        Integer start = cpage * naviPerPage - (naviPerPage - 1); //시작 글 번호
        Integer end = cpage * naviPerPage; // 끝 글 번호
        List<ProductDTO> productDTOList = productService.getMOuter();
        model.addAttribute("productDTOList", productDTOList);
        model.addAttribute("paging", paging);
        return "/product/men/outer";
    }

    @RequestMapping("/men/top")
    public String mTop(Model model, Integer cpage) throws Exception {
        if (cpage == null) cpage = 1;
        Integer postCnt = productService.mTop(); //상품 개수
        Map<String, Object> paging = productService.paging(cpage, postCnt);
        Integer naviPerPage = 10;
        Integer start = cpage * naviPerPage - (naviPerPage - 1); //시작 글 번호
        Integer end = cpage * naviPerPage; // 끝 글 번호
        List<ProductDTO> productDTOList = productService.getMTop();
        model.addAttribute("productDTOList", productDTOList);
        model.addAttribute("paging", paging);
        return "/product/men/top";
    }

    @RequestMapping("/men/pants")
    public String mPants(Model model, Integer cpage) throws Exception {
        if (cpage == null) cpage = 1;
        Integer postCnt = productService.mPants(); //상품 개수
        Map<String, Object> paging = productService.paging(cpage, postCnt);
        Integer naviPerPage = 10;
        Integer start = cpage * naviPerPage - (naviPerPage - 1); //시작 글 번호
        Integer end = cpage * naviPerPage; // 끝 글 번호
        List<ProductDTO> productDTOList = productService.getMPants();
        model.addAttribute("productDTOList", productDTOList);
        model.addAttribute("paging", paging);
        return "/product/men/pants";
    }

    @RequestMapping("/men/accessories")
    public String mAccessories(Model model, Integer cpage) throws Exception {
        if (cpage == null) cpage = 1;
        Integer postCnt = productService.mAcc(); //상품 개수
        Map<String, Object> paging = productService.paging(cpage, postCnt);
        Integer naviPerPage = 10;
        Integer start = cpage * naviPerPage - (naviPerPage - 1); //시작 글 번호
        Integer end = cpage * naviPerPage; // 끝 글 번호
        List<ProductDTO> productDTOList = productService.getMAccessories();
        model.addAttribute("productDTOList", productDTOList);
        model.addAttribute("paging", paging);
        return "/product/men/accessories";
    }

    //신상품 카테고리
    @RequestMapping("/new")
    public String newProduct(Model model, Integer cpage) throws Exception {
        if (cpage == null) cpage = 1;
        Integer postCnt = productService.nCnt(); //상품 개수
        Map<String, Object> paging = productService.paging(cpage, postCnt);
        Integer naviPerPage = 10;
        Integer start = cpage * naviPerPage - (naviPerPage - 1); //시작 글 번호
        Integer end = cpage * naviPerPage; // 끝 글 번호
        List<ProductDTO> productDTOList = productService.getNewProduct();
        model.addAttribute("productDTOList", productDTOList);
        model.addAttribute("paging", paging);
        return "/product/new";
    }

    @RequestMapping("/new/outer")
    public String newOuter(Model model, Integer cpage) throws Exception {
        if (cpage == null) cpage = 1;
        Integer postCnt = productService.nOuter(); //상품 개수
        Map<String, Object> paging = productService.paging(cpage, postCnt);
        Integer naviPerPage = 10;
        Integer start = cpage * naviPerPage - (naviPerPage - 1); //시작 글 번호
        Integer end = cpage * naviPerPage; // 끝 글 번호
        List<ProductDTO> productDTOList = productService.getNewOuter();
        model.addAttribute("productDTOList", productDTOList);
        model.addAttribute("paging", paging);
        return "/product/new/outer";
    }

    @RequestMapping("/new/top")
    public String newTop(Model model, Integer cpage) throws Exception {
        if (cpage == null) cpage = 1;
        Integer postCnt = productService.nTop(); //상품 개수
        Map<String, Object> paging = productService.paging(cpage, postCnt);
        Integer naviPerPage = 10;
        Integer start = cpage * naviPerPage - (naviPerPage - 1); //시작 글 번호
        Integer end = cpage * naviPerPage; // 끝 글 번호
        List<ProductDTO> productDTOList = productService.getNewTop();
        model.addAttribute("productDTOList", productDTOList);
        model.addAttribute("paging", paging);
        return "/product/new/top";
    }

    @RequestMapping("/new/pants")
    public String newPants(Model model, Integer cpage) throws Exception {
        if (cpage == null) cpage = 1;
        Integer postCnt = productService.nPants(); //상품 개수
        Map<String, Object> paging = productService.paging(cpage, postCnt);
        Integer naviPerPage = 10;
        Integer start = cpage * naviPerPage - (naviPerPage - 1); //시작 글 번호
        Integer end = cpage * naviPerPage; // 끝 글 번호
        List<ProductDTO> productDTOList = productService.getNewPants();
        model.addAttribute("productDTOList", productDTOList);
        model.addAttribute("paging", paging);
        return "/product/new/pants";
    }

    @RequestMapping("/new/accessories")
    public String newAccessories(Model model, Integer cpage) throws Exception {
        if (cpage == null) cpage = 1;
        Integer postCnt = productService.nAcc(); //상품 개수
        Map<String, Object> paging = productService.paging(cpage, postCnt);
        Integer naviPerPage = 10;
        Integer start = cpage * naviPerPage - (naviPerPage - 1); //시작 글 번호
        Integer end = cpage * naviPerPage; // 끝 글 번호
        List<ProductDTO> productDTOList = productService.getNewAccessories();
        model.addAttribute("productDTOList", productDTOList);
        model.addAttribute("paging", paging);
        return "/product/new/accessories";
    }

    //장바구니에 상품 추가
    @ResponseBody
    @PostMapping("/addProduct")
    public String addProduct(@RequestParam Map<String, Object> map) throws Exception {
        String result = "";
        Integer count = Integer.parseInt(map.get("count").toString());
        String id = map.get("id").toString();
        Integer pd_seq = Integer.parseInt(map.get("pd_seq").toString());


        //옵션 있을때
        if (map.get("optionList") != null) {
            Map<String, List<String>> optionList = productService.getOptionList(map);
            //상품seq,옵션 정보 같은거 있으면 fail
            Integer isPdInCartWtOpt = productService.isPdInCartWtOpt(pd_seq, optionList.toString(), id);
            if (isPdInCartWtOpt != 0) {
                result = "fail";
            }
            //상품seq,옵션 정보 다르면 success / cart  insert
            else {
                productService.insertCart(id, count, pd_seq, optionList.toString());  //옵션 있을때 장바구니 insert
                result = "success";
            }
        }
        //옵션 없을때
        else if (map.get("optionList") == null) {
            // 상품seq 같은거 있으면 fail
            Integer isPdInCart = productService.isPdInCart(pd_seq, id);
            if (isPdInCart != 0) {
                result = "fail";
            } else {
                productService.insertCartWtOption(id, count, pd_seq);
                result = "success";
            }
        }
        return result;
    }

    //장바구니로 이동
    @PostMapping("/cart")
    public String toCart(Model model, @RequestParam String id) throws Exception {

        List<Map<String, Object>> optionList = new ArrayList<>();
        JsonParser jsonParser = new JsonParser();
        JsonArray jsonArray = new JsonArray();
        JsonObject jsonObject = new JsonObject();
        List<CartDTO> cartInfo = productService.getCartInfo(id);
        List<String> list = new ArrayList<>();
        List<Map<String, Object>> cart = new ArrayList<>();
        Integer totalPrice = 0;  //상품 총 합계
        Integer totalSum = 0;  //상품 총 개수


        /*중복 제거*/
        for (Integer i = 0; i < cartInfo.size(); i++) {
            list = productService.getOptionCategory(cartInfo.get(i).getCart_seq()); //옵션의 카테고리 가져옴
            Map<String, Object> item = new HashMap<>();
            item.put("id", cartInfo.get(i).getId());
            item.put("count", cartInfo.get(i).getCount());
            item.put("cart_seq", cartInfo.get(i).getCart_seq());
            item.put("status", cartInfo.get(i).getStatus());
            item.put("pd_seq", cartInfo.get(i).getPd_seq());
            item.put("name", cartInfo.get(i).getName());
            item.put("description", cartInfo.get(i).getDescription());
            item.put("price", cartInfo.get(i).getPrice());
            item.put("stock", cartInfo.get(i).getStock());
            item.put("img", cartInfo.get(i).getImg());
            item.put("category", cartInfo.get(i).getCategory());
            item.put("totalPrice", cartInfo.get(i).getPrice() * cartInfo.get(i).getCount());

            //돌면서 상품 개수, 상품 가격 가져오고 더하기
            Integer pdCount = cartInfo.get(i).getCount();
            Integer pdProduct_seq = cartInfo.get(i).getPd_seq();
            Integer pdPrice = productService.getPdPrice(pdProduct_seq);

            totalPrice += pdPrice * pdCount;
            totalSum += pdCount;

            if (cartInfo.get(i).getOptions() != null) {  //상품 옵션 있을때
                Object object = jsonParser.parse(cartInfo.get(i).getOptions());
                jsonObject = (JsonObject) object;
                jsonArray = (JsonArray) jsonObject.get("name");
                List<Map<String, Object>> optionMap = new ArrayList<>();
                for (Integer k = 0; k < list.size(); k++) {
                    Map<String, Object> map = new HashMap<>();
                    String category = list.get(k);
                    String option = String.valueOf(jsonArray.get(k)).replace("\"", "");
                    map.put(category, option);
                    optionMap.add(map);
                }
                item.put("option", optionMap);
                cart.add(item);
            } else {
                cart.add(item);
            }
        }

        //m_seq 가져오기
        Integer m_seq = productService.getMemberSeq(id);
        //쿠폰 리스트 가져오기
        List<CouponDTO> couponDTOList = productService.getCoupon(m_seq);
        model.addAttribute("cart", cart);
        model.addAttribute("totalPrice", totalPrice);
        model.addAttribute("totalSum", totalSum);
        model.addAttribute("couponDTOList", couponDTOList);

        //나의 포인트 가져오기
        Integer memPoint = productService.getMemPoint(id);
        model.addAttribute("memPoint", memPoint);
        return "/product/cart";
    }


    @ResponseBody
    @RequestMapping("/cart/delete")
    public String deleteItem(Integer cart_seq) throws Exception {
        productService.deleteItem(cart_seq);
        return "success";
    }

    @ResponseBody
    @RequestMapping("/count")
    public Integer getCount(Integer cart_seq) throws Exception {
        Map<String, Object> cartOption = productService.getCartOption(cart_seq);
        int stock = productService.count(cartOption, cart_seq);
        return stock;
    }

    @ResponseBody
    @RequestMapping("/discountedPrice")  //쿠폰 먹여서 다시 계산
    public Integer changePrice(@RequestParam Map<String, Object> map) throws Exception {
        Integer discount = Integer.parseInt(map.get("discount").toString());
        Integer originalPrice = Integer.parseInt(map.get("price").toString());
        Integer price = productService.getChangedPrice(discount, originalPrice);
        return price;
    }

    @ResponseBody
    @RequestMapping("/updCount")
    public String updCount(Integer count, Integer cart_seq) throws Exception {
        productService.updateCount(count, cart_seq);
        return "success";
    }

    @RequestMapping("/payInfo") //결제 상세 페이지 id,구매할 상품 seq[], 사용한 포인트, [{구매할 상품 수량 , 구매할 상품 seq, 옵션}]
    public String toPayInfo(Model model, String data, Integer price, String buyPdSeq, String productArr) throws Exception { //data : id
        JsonParser jsonParser = new JsonParser();
        JsonArray pdArr = (JsonArray) jsonParser.parse(productArr);
        Integer totalPayPrice = 0;
        Integer totalPayCount = 0;
        for (int i = 0; i < pdArr.size(); i++) {
            Integer pdPrice = productService.getPdPrice(pdArr.get(i).getAsJsonObject().get("seq").getAsInt());
            Integer productPrice = pdPrice * pdArr.get(i).getAsJsonObject().get("count").getAsInt();
            totalPayPrice += productPrice;
            totalPayCount += pdArr.get(i).getAsJsonObject().get("count").getAsInt();
        }

        String[] arr = buyPdSeq.split(",");
        List<Integer> buyList = new ArrayList<>();
        // 구매할 cart_seq
        for (int i = 0; i < arr.length; i++) {
            buyList.add(Integer.parseInt(arr[i]));
        }
        List<Map<String, Object>> optionList = new ArrayList<>();

        JsonArray jsonArray = new JsonArray();
        JsonObject jsonObject = new JsonObject();
        List<String> list = new ArrayList<>();
        List<CartDTO> cartInfo = productService.getCartInfo(data);
        List<Map<String, Object>> cart = new ArrayList<>();
        Integer totalPrice = 0;  //상품 총 합계
        Integer totalSum = 0;  //상품 총 개수
        double memPoint = 0; //총 적립될 포인트
        double point = 0; //상품당 적립될 포인트
        for (Integer i = 0; i < buyList.size(); i++) {
            //상품 재고 체크
            // 상품 체크 서비스

            //count,pd_seq,options
            Integer pd_seq = productService.getPdSeq(buyList.get(i));
            ProductDTO productDTO = productService.getPdInfo(pd_seq);
            list = productService.getOptionCategory(buyList.get(i));
            //돌면서 상품 개수, 상품 가격 가져오고 더하기
            Integer count = productService.getPdCount(buyList.get(i));
            Integer pd_price = productService.getPdPrice(pd_seq);

            totalPrice += count * pd_price;
            totalSum += count;

            //포인트 적립
            point = (double) Math.round(pd_price * productDTO.getPoint() * count / 100);
            memPoint += point;
            Map<String, Object> item = new HashMap<>();
            item.put("id", data);
            item.put("count", count);
            item.put("cart_seq", buyList.get(i));
            item.put("pd_seq", pd_seq);
            item.put("name", productDTO.getName());
            item.put("description", productDTO.getDescription());
            item.put("price", productDTO.getImg());
            item.put("stock", productDTO.getStock());
            item.put("img", productDTO.getImg());
            item.put("category", productDTO.getCategory());

            if (productService.getOption(buyList.get(i)) != null) {
                Object object = jsonParser.parse(productService.getOption(buyList.get(i)));
                jsonObject = (JsonObject) object;
                jsonArray = (JsonArray) jsonObject.get("name");
                List<Map<String, Object>> optionMap = new ArrayList<>();
                for (Integer k = 0; k < list.size(); k++) {
                    Map<String, Object> map = new HashMap<>();
                    String category = list.get(k);
                    String option = String.valueOf(jsonArray.get(k)).replace("\"", "");
//                    productService.minusOption(,option);
                    map.put(category, option);
                    optionMap.add(map);
                }
                item.put("option", optionMap);
                cart.add(item);
            } else {
                cart.add(item);
            }
        }


        MemberDTO memberDTO = memberService.getMemInfo(data);
        //배송지 불러오기 (별칭으로)
        List<DeliDTO> deliDTOList = productService.getDeliveryInfo(data);
        for (
                DeliDTO dto : deliDTOList) {
            String phone = dto.getPhone().substring(0, 3) + "-" + dto.getPhone().substring(3, 7) + "-" + dto.getPhone().substring(7, 11);
            dto.setPhone(phone);
        }

        List<DeliDTO> deliveryInfo = productService.deliveryInfo(data);
        for (
                DeliDTO dto : deliveryInfo) {
            String phone = dto.getPhone().substring(0, 3) + "-" + dto.getPhone().substring(3, 7) + "-" + dto.getPhone().substring(7, 11);
            dto.setPhone(phone);
        }

        model.addAttribute("cart", cart);
        model.addAttribute("deliDTOList", deliDTOList);
        model.addAttribute("deliveryInfo", deliveryInfo);
//        model.addAttribute("deliAddress", deliAddress);
        model.addAttribute("price", price);
        model.addAttribute("memberDTO", memberDTO); //회원 정보
        model.addAttribute("totalPrice", totalPrice);
        model.addAttribute("totalSum", totalSum);
        //해당 아이디 포인트 가져오기
        Integer memberPoint = productService.getMemPoint(data);
        model.addAttribute("memberPoint", memberPoint);
        model.addAttribute("point", point);
        model.addAttribute("memPoint", memPoint); // 최종 적립 포인트
//        model.addAttribute("usedPoint", usedPoint); // 사용한 포인트
        model.addAttribute("totalPayPrice", totalPayPrice);  // 최종 결제할 금액
        model.addAttribute("totalPayCount", totalPayCount); // 최종 결제할 수량

        return "/product/payInfo"; //결제 상세 페이지
    }


    //포인트 사용가능한지 검사
    @ResponseBody
    @PostMapping("/checkPoint")
    public boolean checkPoint(@RequestParam Integer inputPoint, @RequestParam String id) throws Exception {
        boolean result;
        Integer memPoint = productService.getMemPoint(id);
        if (inputPoint == 0) {
            result = false;
        } else if (memPoint >= inputPoint) {
            result = true;
        } else {
            result = false;
        }
        return result;
    }


    @ResponseBody
    @RequestMapping("/getTotal")
    public Map<String, Object> getTotal(String id) throws Exception {
        Map<String, Object> map = new HashMap<>();
        Integer price = productService.getPrice(id);
        Integer total_sum = productService.getSum(id);
        map.put("price", price);
        map.put("total_sum", total_sum);
        return map;
    }

    //선택삭제 테스트
    @ResponseBody
    @RequestMapping("/cart/delCart")
    public String deleteItem(@RequestParam(value = "deleteCartSeq[]") List<Integer> deleteCartSeq) throws Exception {
        productService.deleteCart(deleteCartSeq);
        return "success";
    }

    @RequestMapping("/paymentDetails")   //결제 테이블 인서트, 결제 정보 보여주기
    @Transactional
    public String paymentDetails(Model model, String id, Integer price, String carts, Integer seq, Integer pdTotalSum, @RequestParam(required = false) Integer usedPoint, @RequestParam String testArray) throws Exception {
        if (usedPoint == null) usedPoint = 0;
        //productArr - 가격
        JsonParser jsonParser = new JsonParser();
        JsonArray jsonObject2 = (JsonArray) jsonParser.parse(testArray);
        Integer totalPdPrice = 0;
        double totalNewPoint = 0.0;

        DefaultTransactionDefinition def = new DefaultTransactionDefinition();
        TransactionStatus status = transactionManager.getTransaction(def); //트랜잭션 상태 가져옴

        for (int i = 0; i < jsonObject2.size(); i++) {
            JsonObject jsonObject1 = (JsonObject) jsonObject2.get(i);
            Integer pdSeq = jsonObject1.get("pdSeq").getAsInt();
            Integer pdStock = jsonObject1.get("pdStock").getAsInt();
            Integer pdPrice = productService.getPdPrice(pdSeq);
            totalPdPrice += pdPrice * pdStock;
            double percent = productService.getPercent(pdSeq);
            totalNewPoint += pdStock * pdPrice * percent / 100;

            Integer optionCount = 0;
            JsonObject jsonObject = (JsonObject) jsonObject1.get(String.valueOf(i));
            Integer seq1 = jsonObject1.get("pdSeq").getAsInt();
            Integer count = jsonObject1.get("pdStock").getAsInt();

            //상품 재고 -
            Integer changedPdStock = productService.productStock(seq1);    //상품 재고 체크
            if (count > changedPdStock) { //재고보다 많을때
                //수동 커밋
                transactionManager.commit(status);
                return "redirect:/product/error";
            }else if (changedPdStock <= 0) { //재고가 0보다 작을때 status n으로
                transactionManager.commit(status);
                return "redirect:/product/error";
            } else {
                //상품 수량 -
                productService.chgPdCount(seq1, count);
                //수량 감소하고 재고가 0이 될 경우 status n
                Integer stock = productService.getPdStock(seq1);
                if (stock == 0) {
                    productService.updatePdStatus(seq1);
                }
            }

            //옵션 있을때 옵션 재고 -
            if (jsonObject1.has("optionArr")) {
                JsonArray jsonArray = (JsonArray) jsonParser.parse(jsonObject1.get("optionArr").toString());
                for (int k = 0; k < jsonArray.size(); k++) {
                    String[] option = jsonArray.get(k).getAsString().split("=");
                    String category = option[0].replace("\"", "");
                    String name = option[1].replace("\"", "");
                    optionCount = productService.productOptionStock(category, name, seq1); //옵션 있을때 옵션 수량 체크
                    OptionDTO optionDTO = productService.optionInfo(seq1, name, category);
                    if (count > optionCount) {  //재고보다 많을때
                        //수동 커밋
                        transactionManager.commit(status);
                        return "redirect:/product/error";
                    }else if (optionCount <= 0) { //재고가 0보다 작을때 status n으로
                        transactionManager.commit(status);
                        return "redirect:/product/error";
                    }else {
                        //옵션 재고 -
                        productService.chgOptCount(category, name, seq1, count);
                        //옵션 감소하고 재고가 0이 될 경우 status n
                        OptionDTO optionDTO1 = productService.optionInfo(seq1, name, category);
                        if (optionDTO1.getStock() == 0) {
                            productService.updateOptionStatus(optionDTO1.getOption_seq());
                        }
                    }
                }
            }
        }

        totalPdPrice -= usedPoint;
        //기본 배송지 수정
        productService.updDeliStatus(seq);
        productService.updStatus(seq);

        DeliDTO defaultAddr = productService.getDefaultAddr();
        String phone = defaultAddr.getPhone().substring(0, 3) + "-" + defaultAddr.getPhone().substring(3, 7) + "-" + defaultAddr.getPhone().substring(7, 11);
        defaultAddr.setPhone(phone);

        //결제 테이블에 인서트
        Map<String, Object> param = new HashMap<>();
        param.put("id", id);
        param.put("price", totalPdPrice);
        param.put("deliSeq", defaultAddr.getSeq());
        param.put("pdTotalSum", pdTotalSum);
        param.put("usedPoint", usedPoint);
        payService.insertPayInfo(param);
        Integer pay_seq = productService.currPaySeq();//현재 pay_seq
        Timestamp timestamp = productService.getPayDate(pay_seq);
        PayInfoDTO payInfoDTO = payService.getPayInfo(pay_seq);//결제 정보 가져오기

        JsonArray jsonArray = new JsonArray();
        JsonObject jsonObject = new JsonObject();
        List<String> list = new ArrayList<>();
        List<CartDTO> cartInfo = productService.getCart(id);  //결제 후 결제 내역에서 결제한것만 보여주기
        List<Map<String, Object>> cart = new ArrayList<>();
        Integer totalPrice = 0;  //상품 총 합계
        Integer totalSum = 0;  //상품 총 개수

        for (
                Integer i = 0; i < cartInfo.size(); i++) {
            Map<String, Object> item = new HashMap<>();
            item.put("id", cartInfo.get(i).getId());
            item.put("count", cartInfo.get(i).getCount());
            item.put("cart_seq", cartInfo.get(i).getCart_seq());
            item.put("status", cartInfo.get(i).getStatus());
            item.put("pd_seq", cartInfo.get(i).getPd_seq());
            item.put("name", cartInfo.get(i).getName());
            item.put("description", cartInfo.get(i).getDescription());
            item.put("price", cartInfo.get(i).getPrice());
            item.put("stock", cartInfo.get(i).getStock());
            item.put("img", cartInfo.get(i).getImg());
            item.put("category", cartInfo.get(i).getCategory());
            item.put("totalPrice", cartInfo.get(i).getPrice() * cartInfo.get(i).getCount());

            //돌면서 상품 개수, 상품 가격 가져오고 더하기
            Integer pdCount = cartInfo.get(i).getCount();
            Integer pdProduct_seq = cartInfo.get(i).getPd_seq();
            Integer pdPrice = productService.getPdPrice(pdProduct_seq);

            totalPrice += pdPrice * pdCount;
            totalSum += pdCount;

            Map<String, Object> salesParam = new HashMap<>();
            Integer productPrice = cartInfo.get(i).getStock() * cartInfo.get(i).getPrice(); //상품 가격 * 상품 개수
            if (cartInfo.get(i).getOptions() != null) { //옵션 있을때
                salesParam.put("option", cartInfo.get(i).getOptions());
                Map<String, Object> parameter = new HashMap<>();
                parameter.put("pd_seq", cartInfo.get(i).getPd_seq());
                parameter.put("option", cartInfo.get(i).getOptions());
                parameter.put("payPd_seq", pay_seq);
                parameter.put("count", cartInfo.get(i).getCount());
                productService.insertPayProduct(parameter);//결제한 상품

                Object object = jsonParser.parse(cartInfo.get(i).getOptions());
                jsonObject = (JsonObject) object;
                jsonArray = (JsonArray) jsonObject.get("name");

                list = productService.getOptionCategory(cartInfo.get(i).getCart_seq());
                List<Map<String, Object>> optionMap = new ArrayList<>();
                for (Integer k = 0; k < list.size(); k++) {
                    Map<String, Object> map = new HashMap<>();
                    String category = list.get(k);
                    String option = String.valueOf(jsonArray.get(k)).replace("\"", "");
                    map.put(category, option);
                    optionMap.add(map);
                }
                item.put("option", optionMap);
                cart.add(item);
            } else if (cartInfo.get(i).getOptions() == null) {
                cart.add(item);
                productService.insertPayPd(cartInfo.get(i).getPd_seq(), pay_seq, cartInfo.get(i).getCount());//결제한 상품
            }

            //판매 테이블에 인서트할 map (상품당 insert)
            Integer currPayPdSeq = productService.getCurrPayPdSeq();//현재 payPd_seq 가져오기
            PayInfoDTO payInfoDTO1 = productService.getPayInfo(pay_seq);
            salesParam.put("id", id); //id
            salesParam.put("pd_seq", cartInfo.get(i).getPd_seq()); //pd_seq
            salesParam.put("stock", payInfoDTO1.getCount()); //stock
            salesParam.put("productPrice", payInfoDTO1.getPrice());//price
            salesParam.put("salesDate", timestamp); //판매 시간
            salesParam.put("payPdSeq", currPayPdSeq); //payPd_seq
            productService.insertSales(salesParam);
        }

//        //상품 수량, 옵션 수량 변경
//        //for update
//        for (int i = 0; i < cartInfo.size(); i++) {
//            Integer pd_seq = cartInfo.get(i).getPd_seq();
//            Integer pdStock = productService.getPdStock(pd_seq);    //상품 재고 체크
//            System.out.println("상품재고체크 = " + pdStock);
//            Integer count = cartInfo.get(i).getCount();
//            //상품 수량 변경
//            productService.chgPdCount(pd_seq, count);
//
//            if (cartInfo.get(i).getOptions() != null) {
//                Object object = jsonParser.parse(cartInfo.get(i).getOptions());
//                JsonObject jsonObject1 = (JsonObject) object;
//                JsonArray jsonArray1 = (JsonArray) jsonObject1.get("name");
//                //상품 옵션 수량 변경
//                if (pdStock <= 0) {
//                    productService.updatePdStatus(pd_seq);
//                }
//                for (int k = 0; k < jsonArray1.size(); k++) {
//
//                    String option = String.valueOf(jsonArray1.get(k)).replace("\"", "");
//
//                    Map<String, Object> map = new HashMap<>();
//                    map.put("pd_seq", pd_seq);
//                    map.put("option", option);
//                    map.put("count", count);
//                    //상품 수량이 0일때 status n으로
//                    OptionDTO optionStock = productService.getOptionStock(map);
//                    if (optionStock.getStock() <= 0) {
//                        //옵션 있고 옵션 수량이 0일때
//                        productService.updateOptionStatus(optionStock.getOption_seq());
//                        productService.chgOptionCount(map);
//                        //재고가 음수일떄 0으로 update해주기
//                        productService.updOptionStock(optionStock.getOption_seq(), optionStock.getPd_seq());
//                    } else if (optionStock.getStock() > 0) {
//                        //옵션 있고 옵션 수량 0이 아닐때
//                        productService.chgOptionCount(map);
//                    }
//                }
//            } else if (cartInfo.get(i).getOptions() == null) {
//                //옵션 없을때
//                Integer changedPdStock = productService.getPdStock(pd_seq);    //상품 재고 체크
//                if (changedPdStock <= 0) {
//                    //상품 수량이 0일때 status n으로
//                    productService.updatePdStatus(pd_seq);
//                }
//            }
//        }

        //장바구니 비우기
        productService.updCartStatus(id);
        model.addAttribute("cart", cart);
        model.addAttribute("totalPrice", totalPrice);
        model.addAttribute("usedPoint", usedPoint);
        model.addAttribute("price", price);
        model.addAttribute("totalSum", totalSum);
        model.addAttribute("defaultAddr", defaultAddr);
        model.addAttribute("payInfoDTO", payInfoDTO);
        model.addAttribute("totalPdPrice", totalPdPrice); // 총 결제 금액 (포인트뺀거)
//        Integer memPoint = productService.getMemPoint(id); //멤버 포인트 조회
        productService.updMemPoint(id, usedPoint, totalNewPoint); // 멤버 포인트 변경

        //적립될 포인트
        model.addAttribute("totalNewPoint", totalNewPoint);// 적립될 포인트
        return "/product/paymentDetail";
    }

    @ResponseBody
    @RequestMapping("/likeYN") //좋아요 눌렀는지 여부
    public Integer likeYN(String id, Integer pd_seq) throws Exception {
        Integer yn = productService.likeYN(id, pd_seq);
        return yn;
    }

    @ResponseBody
    @RequestMapping("/like") //좋아요 테이블 인서트
    public String like(String id, Integer pd_seq) throws Exception {
        productService.insertLike(id, pd_seq);
        return "success";
    }

    @ResponseBody
    @RequestMapping("/cancleLike") //좋아요 취소
    public String cancleLike(String id, Integer pd_seq) throws Exception {
        productService.cancleLike(id, pd_seq); //좋아요 취소 상태 n
        return "success";
    }

    @ResponseBody
    @PostMapping("/addPd")  //관리자 상품 추가
    public String addPd(@RequestParam Map<String, Object> map, HttpServletRequest request,
                        @RequestPart(value = "img", required = false) MultipartFile img) throws Exception {
        String path = "/resources/img/products/";

        String savePath = request.getServletContext().getRealPath(path); //webapp 폴더
        File fileSavePath = new File(savePath);

        if (!fileSavePath.exists()) {
            fileSavePath.mkdir();
        }

        String oriname = img.getOriginalFilename();
        String sysname = UUID.randomUUID() + "_" + oriname;

        img.transferTo(new File(fileSavePath + "/" + sysname));

        // 상품 인서트
        String name = map.get("name").toString();
        String description = map.get("description").toString();
        Integer stock = Integer.parseInt(map.get("stock").toString());
        Integer price = Integer.parseInt(map.get("price").toString());
        String category1 = map.get("category1").toString();
        String category2 = map.get("category2").toString();
        Integer point = Integer.parseInt(String.valueOf(map.get("point")));
        //상품 인서트할때 category_seq 가져오기
        Integer category_seq = productService.getCategorySeq(category1, category2);
        Map<String, Object> param = new HashMap<>();
        param.put("name", name);
        param.put("description", description);
        param.put("price", price);
        param.put("stock", stock);
        param.put("img", sysname);
        param.put("category", category_seq);
        param.put("point", point);

        productService.insertPd(param);

        //option json으로 파싱
        JsonParser jsonParser = new JsonParser();
        Object object = jsonParser.parse((String) map.get("option"));
        JsonArray optionArray = (JsonArray) object;

        //옵션이 없을때
        if (optionArray.size() == 0) {
//            System.out.println("옵션 없음");
        } else { //옵션이 있을때
            for (int i = 0; i < optionArray.size(); i++) {
                Object object1 = jsonParser.parse(optionArray.get(i).toString());
                JsonObject jsonObject = (JsonObject) object1;
                String category = jsonObject.get("category").toString().replace("\"", "");
                String optionName = jsonObject.get("name").toString().replace("\"", "");
                Integer optionStock = Integer.parseInt(jsonObject.get("stock").toString().replace("\"", ""));

                Integer currVal = productService.getPdCurrVal(); // 상품  currval 가져오기

                Map<String, Object> map1 = new HashMap<>();
                map1.put("category", category);
                map1.put("name", optionName);
                map1.put("stock", optionStock);
                map1.put("pd_seq", currVal);
                productService.insertOption(map1);///옵션 인서트
            }
        }
        return "success";
    }


    @ResponseBody
    @RequestMapping("/deletePd")   // 등록한 상품 삭제
    public String deletePd(Integer pd_seq) throws Exception {
        productService.deletePd(pd_seq);
        return "success";
    }

    @ResponseBody
    @RequestMapping("/updProduct") //관리자 상품 수정
    public String updProduct(@RequestParam Map<String, Object> map, HttpServletRequest request,
                             @RequestPart(value = "img", required = false) MultipartFile img) throws Exception {
        //상품 업데이트
        String name = map.get("name").toString();
        String description = map.get("description").toString();
        Integer stock = Integer.parseInt(map.get("stock").toString());
        Integer price = Integer.parseInt(map.get("price").toString());
        String category1 = map.get("category1").toString();
        String category2 = map.get("category2").toString();
        Integer pd_seq = Integer.parseInt(map.get("pd_seq").toString());
        Integer point = Integer.parseInt(map.get("point").toString());

        Map<String, Object> param = new HashMap<>();
        if (map.get("img").toString().replace("\"", "").length() != 0) { //이미지 변경 될때

            String path = "/resources/img/products/";

            String savePath = request.getServletContext().getRealPath(path); //webapp 폴더
            File fileSavePath = new File(savePath);

            if (!fileSavePath.exists()) {
                fileSavePath.mkdir();
            }

            String oriname = img.getOriginalFilename();
            String sysname = UUID.randomUUID() + "_" + oriname;

            img.transferTo(new File(fileSavePath + "/" + sysname));

            productService.updPdImg(pd_seq, sysname);
        }

        //상품 업데이트할때 category_seq 가져오기
        Integer category_seq = productService.getCategorySeq(category1, category2);
        param.put("name", name);
        param.put("description", description);
        param.put("stock", stock);
        param.put("price", price);
        param.put("category_seq", category_seq);
        param.put("pd_seq", pd_seq);
        param.put("point", point);
        productService.updProduct(param);//상품 정보 update

        /*옵션 업데이트*/
        //deleteOpt json으로 파싱
        JsonParser jsonParser = new JsonParser();
        Object object = jsonParser.parse((String) map.get("deleteOpt"));
        JsonArray deleteOpt = (JsonArray) object;
        //돌면서 삭제
        if (deleteOpt.size() != 0) {
            for (int i = 0; i < deleteOpt.size(); i++) {
                Object object1 = jsonParser.parse(String.valueOf(deleteOpt.get(i)));
                JsonObject jsonObject = (JsonObject) object1;
                Integer option_seq = Integer.parseInt(String.valueOf(jsonObject.get("key")));
                productService.updOptionStatus(option_seq); //옵션 삭제
            }
        }

        //updOpt json으로 파싱
        Object object1 = jsonParser.parse((String) map.get("updOpt"));
        JsonArray updOpt = (JsonArray) object1;
        //돌면서 수정
        if (updOpt.size() != 0) {
            for (int i = 0; i < updOpt.size(); i++) {
                Object object2 = jsonParser.parse(String.valueOf(updOpt.get(i)));
                JsonObject jsonObject = (JsonObject) object2;
                Integer option_seq = Integer.parseInt(String.valueOf(jsonObject.get("key")).replace("\"", ""));
                String category = String.valueOf(jsonObject.get("category")).replace("\"", "");
                String option_name = String.valueOf(jsonObject.get("name")).replace("\"", "");
                Integer option_stock = Integer.parseInt(String.valueOf(jsonObject.get("stock")).replace("\"", ""));
                Map<String, Object> updParam = new HashMap<>();
                updParam.put("category", category);
                updParam.put("option_name", option_name);
                updParam.put("option_stock", option_stock);
                updParam.put("option_seq", option_seq);
                productService.updOptions(updParam); //옵션 수정
            }
        }

        //newOpt json으로 파싱
        Object object2 = jsonParser.parse((String) map.get("newOpt"));
        JsonArray newOpt = (JsonArray) object2;
        //돌면서 추가
        if (newOpt.size() != 0) {
            for (int i = 0; i < newOpt.size(); i++) {
                Object object3 = jsonParser.parse(String.valueOf(newOpt.get(i)));
                JsonObject jsonObject = (JsonObject) object3;
                Integer option_seq = productService.getNextOptSeq(); //option_seq nextval가져오기
                String category = String.valueOf(jsonObject.get("category")).replace("\"", "");
                String option_name = String.valueOf(jsonObject.get("name")).replace("\"", "");
                Integer option_stock = Integer.parseInt(String.valueOf(jsonObject.get("stock")).replace("\"", ""));
                Map<String, Object> insertParam = new HashMap<>();
                insertParam.put("pd_seq", pd_seq);
                insertParam.put("category", category);
                insertParam.put("option_name", option_name);
                insertParam.put("option_stock", option_stock);
                insertParam.put("option_seq", option_seq);
                productService.insertNewOptions(insertParam); //새로운 옵션 추가
            }
        }
        return "success";
    }

    //상품 검색
    @RequestMapping("/searchPd")
    public String searchPd(String keyword, Model model, Integer cpage) throws Exception {
        if (cpage == null) cpage = 1;
        Integer naviPerPage = 10;
        Integer postCnt = productService.searchPdCnt(keyword);//검색한 상품 수
        Map<String, Object> paging = productService.paging(cpage, postCnt);
        Integer start = cpage * naviPerPage - (naviPerPage - 1); //시작 글 번호
        Integer end = cpage * naviPerPage; // 끝 글 번호
        List<ProductDTO> productDTOList = productService.getProductsByKeyword(keyword, start, end);
        model.addAttribute("productDTOList", productDTOList);
        model.addAttribute("keyword", keyword);
        model.addAttribute("paging", paging);
        return "/product/productList";
    }

    @ResponseBody
    @PostMapping("/cart/updFlag")  //cart flag n으로 변경
    public String updFlag(@RequestParam Integer cart_seq) throws Exception {
        productService.updCartFlag(cart_seq);
        return "success";
    }

    @ResponseBody
    @PostMapping("/cart/updFlagToY")  //cart flag n으로 변경
    public String updFlagToY(@RequestParam Integer cart_seq) throws Exception {
        productService.updFlagToY(cart_seq);
        return "success";
    }

    @RequestMapping("/addDeli") //배송지 추가
    public String addDeli(Model model, String id, @RequestParam(required = false) Integer point) throws Exception {
        model.addAttribute("id", id);
        model.addAttribute("point", point);
        return "/product/popup";
        //회원 배송지 정보 가져오기
    }

    @RequestMapping("/updDeliInfo") //배송지 수정
    public String updDeliInfo(Model model, Integer seq) throws Exception {
        DeliDTO deliDTO = productService.getSeqDeli(seq);
        model.addAttribute("deliDTO", deliDTO);
        return "/product/updPopup";
        //회원 배송지 정보 가져오기
    }

    @ResponseBody
    @PostMapping("/addDelivery")
    public Map<String, Object> addDeli(@RequestParam Map<String, Object> map) throws Exception {


        String name = map.get("name").toString();
        String phone = map.get("phone").toString();
        String address = map.get("address").toString();
        String nickname = map.get("nickname").toString();
        String def = map.get("def").toString();
        String id = map.get("id").toString();
//        Integer point = Integer.parseInt(map.get("point").toString());
        String flag = "N";
        if (def.equals("true")) flag = "Y";
        Map<String, Object> param = new HashMap<>();
        param.put("name", name);
        param.put("phone", phone);
        param.put("address", address);
        param.put("nickname", nickname);
        param.put("flag", flag);
        param.put("id", id);
//        param.put("point", point);
        productService.insertDeli(param);  //배송지 추가
        Integer currval = productService.getCurrval();//seq.currval
        if (flag.equals("Y")) productService.updDeliStatus(currval);  //flag Y일때 나머지 n으로 변경
        return param;
        //배달 정보에 insert
    }


    @ResponseBody
    @PostMapping("/getSeqDeli")
    public DeliDTO getSeqDeli(Integer seq) throws Exception {
        DeliDTO deliDTO = productService.getSeqDeli(seq);
        String phone = deliDTO.getPhone().substring(0, 3) + "-" + deliDTO.getPhone().substring(3, 7) + "-" + deliDTO.getPhone().substring(7, 11);
        deliDTO.setPhone(phone);
        return deliDTO;
    }

    @ResponseBody
    @PostMapping("/updDelivery")
    public String updDelivery(@RequestParam Map<String, Object> map) throws Exception {
        String name = map.get("name").toString();
        String phone = map.get("phone").toString();
        String address = map.get("address").toString();
        String nickname = map.get("nickname").toString();
        String def = map.get("def").toString();
        String id = map.get("id").toString();
        Integer seq = Integer.parseInt(map.get("seq").toString());
        String flag = "N";
        if (def.equals("true")) flag = "Y";
        Map<String, Object> param = new HashMap<>();
        param.put("name", name);
        param.put("phone", phone);
        param.put("address", address);
        param.put("nickname", nickname);
        param.put("flag", flag);
        param.put("id", id);
        param.put("seq", seq);
        productService.updDeli(param);  //배송지 수정
        productService.updDeliStatus(seq); //나머지 status n
        return "success";
    }

    @ResponseBody
    @PostMapping("/getDefaultAdr")  //기본 배송지 seq가져오기
    public Integer getDefaultAdr() throws Exception {
        Integer seq = productService.getDefaultAdr();
        return seq;
    }

    @ResponseBody
    @PostMapping("/deleteDeli")  //배송지 삭제
    public String deleteDeli(Integer seq) throws Exception {
        productService.deleteDeli(seq);
        return "success";
    }

    @RequestMapping("/history")  //구매내역 최신순부터
    public String history(String id, Model model, Integer cpage) throws Exception {
        if (cpage == null) cpage = 1;
        Map<String, Object> paging = productService.historyPaging(cpage, id);
        Integer naviPerPage = 10;
        Map<String, Object> pagingStartEnd = productService.pagingStartEnd(cpage, naviPerPage);
        Integer start = Integer.parseInt(pagingStartEnd.get("start").toString());
        Integer end = Integer.parseInt(pagingStartEnd.get("end").toString());

        //리뷰 상태 가져오기
        List<Map<String, Object>> historyList = new ArrayList<>();
        List<Map<String, Object>> payInfoDTOS = productService.getHistory(id, start, end);
        //옵션 정보 가져오기
        historyList = productService.pdOptionInfo(payInfoDTOS);
        model.addAttribute("historyList", historyList);
        model.addAttribute("paging", paging);
        return "/product/history";
    }

    @ResponseBody
    @PostMapping("/historyRepaging")
    public Map<String, Object> historyRepaging(Integer cpage, String id, String keyword) throws Exception {
        Map<String, Object> reMap = new HashMap<>();
        if (cpage == null) cpage = 1;
        Map<String, Object> paging = productService.historyPaging(cpage, id);
        Integer naviPerPage = 10;
        Map<String, Object> pagingStartEnd = productService.pagingStartEnd(cpage, naviPerPage);
        Integer start = Integer.parseInt(pagingStartEnd.get("start").toString());
        Integer end = Integer.parseInt(pagingStartEnd.get("end").toString());
        //리뷰 상태 가져오기
        List<Map<String, Object>> historyList = new ArrayList<>();
        List<Map<String, Object>> payInfoDTOS = productService.getHistory(id, start, end);
        //옵션 정보 가져오기
        historyList = productService.pdOptionInfo(payInfoDTOS);
        reMap.put("historyList", historyList);
        reMap.put("paging", paging);
        return reMap;
    }

    @ResponseBody
    @PostMapping("/rePaging")
    public Map<String, Object> rePaging(Integer cpage, String id, String keyword) throws Exception {
        Map<String, Object> reMap = new HashMap<>();
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
            if (isOptExist != 0) { //상품의 옵션이 있을 경우
                optionDTOList = productService.getOptByGroup(productDTO.getPd_seq());
                tmp.put("optionDTOList", optionDTOList);
            }
            tmp.put("productDTO", productDTO);
            registeredPd.add(tmp);
        }
        reMap.put("registeredPd", registeredPd);
        reMap.put("paging", paging);
        return reMap;
    }

    @ResponseBody
    @PostMapping("/rePagingPdList")
    public Map<String, Object> rePagingPdList(Integer cpage, String id, String keyword) throws Exception {
        Integer naviPerPage = 10;
        Map<String, Object> pagingStartEnd = productService.pagingStartEnd(cpage, naviPerPage);
        Integer start = Integer.parseInt(pagingStartEnd.get("start").toString());
        Integer end = Integer.parseInt(pagingStartEnd.get("end").toString());

        Map<String, Object> reMap = new HashMap<>();
        List<ProductDTO> productDTOList = productService.getProducts(keyword, start, end);
        Map<String, Object> paging = productService.pagingPdList(cpage, keyword);
        reMap.put("startNavi", Integer.parseInt(paging.get("startNavi").toString()));
        reMap.put("endNavi", Integer.parseInt(paging.get("endNavi").toString()));
        reMap.put("needPrev", Boolean.parseBoolean(paging.get("needPrev").toString()));
        reMap.put("needNext", Boolean.parseBoolean(paging.get("needNext").toString()));
        reMap.put("paging", paging);
        reMap.put("cpage", Integer.parseInt(paging.get("cpage").toString()));
        reMap.put("productDTOList", productDTOList);
        return reMap;
    }

    @ResponseBody
    @PostMapping("/rePagingSalesList")
    public List<Object> rePagingSalesList(Integer cpage, String id) throws Exception {
        JsonParser jsonParser = new JsonParser();
        JsonObject jsonObject = new JsonObject();
        JsonArray jsonArray = new JsonArray();

        List<Object> historyList = new ArrayList<>();
        Integer naviPerPage = 10;
        Map<String, Object> pagingStartEnd = productService.pagingStartEnd(cpage, naviPerPage);
        Integer start = Integer.parseInt(pagingStartEnd.get("start").toString());
        Integer end = Integer.parseInt(pagingStartEnd.get("end").toString());
        Integer postCnt = productService.countSalesPd(); //판매 상품 개수
        List<SalesDTO> salesDTOS = productService.getSalesList(start, end);//판매 테이블에서 가져오기
        Map<String, Object> paging = productService.paging(cpage, postCnt);
        for (SalesDTO salesDTO : salesDTOS) {
//            PayProductDTO payProductDTO = productService.getDeliYN(salesDTO.getSales_seq()); // deliYN, CODE 가져오기
            String deliYN = productService.getDeliYN(salesDTO.getSales_seq()); // deliYN, CODE 가져오기
            Map<String, Object> reMap = new HashMap<>();
            reMap.put("startNavi", Integer.parseInt(paging.get("startNavi").toString()));
            reMap.put("endNavi", Integer.parseInt(paging.get("endNavi").toString()));
            reMap.put("needPrev", Boolean.parseBoolean(paging.get("needPrev").toString()));
            reMap.put("needNext", Boolean.parseBoolean(paging.get("needNext").toString()));
            reMap.put("paging", paging);
            reMap.put("cpage", Integer.parseInt(paging.get("cpage").toString()));
            reMap.put("deliYN", deliYN);
//            reMap.put("deliYN", payProductDTO.getDeliYN());
//            reMap.put("code", payProductDTO.getCode());
            reMap.put("salesDTOS", salesDTO);
            ProductDTO productDTO = productService.getPdInfo(salesDTO.getPd_seq());
            reMap.put("productDTO", productDTO);

            if (salesDTO.getPdOption() != null) { //옵션 있을때 size : s
                List<Map<String, Object>> optionMapList = null;
                reMap.put("option", salesDTO.getPdOption());
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
                if (optionMapList.size() != 0) reMap.put("optionMapList", optionMapList);
            }
            historyList.add(reMap);
        }
        return historyList;
    }


//    @ResponseBody
//    @PostMapping("/insertDeliInfo")  //택배사 db 저장
//    public String insertDeliInfo(@RequestBody List<List<Object>> list) throws Exception {
//        for (int i = 0; i < list.size(); i++) {
//            for (int k = 0; k < list.get(i).size(); k++) {
//                Integer code = Integer.parseInt((String) list.get(i).get(0));
//                String name = (String) list.get(i).get(1);
//                productService.insert(code, name);
//            }
//        }
//        return "success";
//    }

    @ResponseBody
    @PostMapping("/chgDeliveryStatus")  //payProduct deliYN, code 변경  (배송 상태 변경 - 배송중으로)
    public String chgDeliveryStatus(@RequestParam Map<String, Object> data) throws Exception {
        Integer sales_seq = Integer.parseInt(data.get("sales_seq").toString()); //sales_seq
        Integer courierCode = productService.getCourierCode(data.get("courier").toString()); //택배사 이름
        String postNum = data.get("invoiceNum").toString(); //택배사 이름
        productService.updDeliveryStatus(sales_seq, courierCode, postNum); //sales table -> payPdSeq
        return "success";
    }


    @PostMapping("/refundPopup")  //환불 신청 팝업으로 이동
    public String toRefundPopup(Model model, @RequestParam Map<String, Object> map) throws Exception {
        String id = map.get("id").toString();
        Map<String, Object> refundPdInfo = productService.refundPdInfo(map);//교환할 상품 정보
        ProductDTO productDTO = productService.getPdInfo(Integer.parseInt(refundPdInfo.get("PD_SEQ").toString()));
        Integer pdPrice = Integer.parseInt(refundPdInfo.get("PRICE").toString());
        Integer count = Integer.parseInt(refundPdInfo.get("COUNT").toString());
        Integer price = pdPrice * count; //상품가격*개수
        if(Integer.parseInt(refundPdInfo.get("USEDPOINT").toString()) != 0){
            price -= Integer.parseInt(refundPdInfo.get("USEDPOINT").toString());
        }
        if (refundPdInfo.get("OPTIONS") != null) {
            List<Map<String, Object>> optionList = productService.refundPdWithOpt(refundPdInfo); //옵션 있으면 옵션 정보 가공해서 다시 가져옴
            model.addAttribute("optionList", optionList);
        }
        //배송지 불러오기 (별칭으로)
        List<DeliDTO> deliDTOList = productService.getDeliveryInfo(id);
        for (DeliDTO dto : deliDTOList) {
            String phone = dto.getPhone().substring(0, 3) + "-" + dto.getPhone().substring(3, 7) + "-" + dto.getPhone().substring(7, 11);
            dto.setPhone(phone);
        }
        model.addAttribute("productDTO", productDTO);
        model.addAttribute("refundPdInfo", refundPdInfo);
        model.addAttribute("deliDTOList", deliDTOList);
        model.addAttribute("deliDTOList", deliDTOList);
        model.addAttribute("price", price);
        return "/product/refundPopup";
    }


    @PostMapping("/exchangePopup")  //교환 신청 팝업으로 이동
    public String exchangePopup(Model model, @RequestParam Map<String, Object> map) throws Exception {
        String id = map.get("id").toString();
        Map<String, Object> refundPdInfo = productService.refundPdInfo(map);//교환할 상품 정보
        ProductDTO productDTO = productService.getPdInfo(Integer.parseInt(refundPdInfo.get("PD_SEQ").toString()));
        Integer pdPrice = Integer.parseInt(refundPdInfo.get("PRICE").toString());
        Integer count = Integer.parseInt(refundPdInfo.get("COUNT").toString());
        Integer price = pdPrice * count; //상품가격*개수
        if(Integer.parseInt(refundPdInfo.get("USEDPOINT").toString()) != 0){
            price -= Integer.parseInt(refundPdInfo.get("USEDPOINT").toString());
        }
        if (refundPdInfo.get("OPTIONS") != null) {
            List<Map<String, Object>> optionList = productService.refundPdWithOpt(refundPdInfo); //옵션 있으면 옵션 정보 가공해서 다시 가져옴
            model.addAttribute("optionList", optionList);
        }
        //배송지 불러오기 (별칭으로)
        List<DeliDTO> deliDTOList = productService.getDeliveryInfo(id);
        for (DeliDTO dto : deliDTOList) {
            String phone = dto.getPhone().substring(0, 3) + "-" + dto.getPhone().substring(3, 7) + "-" + dto.getPhone().substring(7, 11);
            dto.setPhone(phone);
        }
        model.addAttribute("productDTO", productDTO);
        model.addAttribute("refundPdInfo", refundPdInfo);
        model.addAttribute("deliDTOList", deliDTOList);
        model.addAttribute("deliDTOList", deliDTOList);
        model.addAttribute("price", price);
        return "/product/exchangePopup";
    }


    @PostMapping("/cancleRefundPopup") //환불 취소 창으로 이동
    public String cancleRefundPopup(Model model, @RequestParam Map<String, Object> map) throws Exception {
        String id = map.get("id").toString();
        Map<String, Object> refundPdInfo = productService.refundData(map);//교환할 상품 정보
        ProductDTO productDTO = productService.getPdInfo(Integer.parseInt(refundPdInfo.get("PD_SEQ").toString()));
        Integer pdPrice = Integer.parseInt(refundPdInfo.get("PRICE").toString());
        Integer count = Integer.parseInt(refundPdInfo.get("COUNT").toString());
        Integer price = pdPrice * count; //상품가격*개수
        if (refundPdInfo.get("OPTIONS") != null) {
            List<Map<String, Object>> optionList = productService.refundPdWithOpt(refundPdInfo); //옵션 있으면 옵션 정보 가공해서 다시 가져옴
            model.addAttribute("optionList", optionList);
        }
//        //배송지 불러오기 (별칭으로)
//        List<DeliDTO> deliDTOList = productService.getDeliveryInfo(id);
//        for (DeliDTO dto : deliDTOList) {
//            String phone = dto.getPhone().substring(0, 3) + "-" + dto.getPhone().substring(3, 7) + "-" + dto.getPhone().substring(7, 11);
//            dto.setPhone(phone);
//        }
        model.addAttribute("productDTO", productDTO);
        model.addAttribute("refundPdInfo", refundPdInfo);
//        model.addAttribute("deliDTOList", deliDTOList);
        model.addAttribute("price", price);
        return "/product/cancleRefundPopup";
    }

    @ResponseBody
    @PostMapping("/cancleRefund")
    public String cancleRefund(@RequestParam Map<String, Object> param) throws Exception {
        //환불 신청한거 status n으로 변경
        Integer payPd_seq = Integer.parseInt(param.get("payPd_seq").toString());
        productService.updRefundStatus(payPd_seq);
        return "success";
    }

    @ResponseBody
    @PostMapping("/refund")  //refund 테이블에 인서트 환불
    public String refundPd(@RequestParam Map<String, Object> param) throws Exception {
        productService.insertRefund(param);
        return "success";
    }

    @ResponseBody
    @PostMapping("/cancleExchange")
    public String cancleExchange(@RequestParam Map<String, Object> param) throws Exception {
        //환불 신청한거 status n으로 변경
        Integer payPd_seq = Integer.parseInt(param.get("payPd_seq").toString());
        productService.updRefundStatus(payPd_seq);
        return "success";
    }

    @PostMapping("/cancleExchangePopup") //교환 취소 창으로 이동
    public String cancleExchange(Model model, @RequestParam Map<String, Object> map) throws Exception {
        String id = map.get("id").toString();
        Map<String, Object> refundPdInfo = productService.refundData(map);//교환할 상품 정보
        ProductDTO productDTO = productService.getPdInfo(Integer.parseInt(refundPdInfo.get("PD_SEQ").toString()));
        Integer pdPrice = Integer.parseInt(refundPdInfo.get("PRICE").toString());
        Integer count = Integer.parseInt(refundPdInfo.get("COUNT").toString());
        Integer price = pdPrice * count; //상품가격*개수
        if (refundPdInfo.get("OPTIONS") != null) {
            List<Map<String, Object>> optionList = productService.refundPdWithOpt(refundPdInfo); //옵션 있으면 옵션 정보 가공해서 다시 가져옴
            model.addAttribute("optionList", optionList);
        }
        //배송지 불러오기 (별칭으로)
        List<DeliDTO> deliDTOList = productService.getDeliveryInfo(id);
        for (DeliDTO dto : deliDTOList) {
            String phone = dto.getPhone().substring(0, 3) + "-" + dto.getPhone().substring(3, 7) + "-" + dto.getPhone().substring(7, 11);
            dto.setPhone(phone);
        }
        model.addAttribute("productDTO", productDTO);
        model.addAttribute("refundPdInfo", refundPdInfo);
        model.addAttribute("deliDTOList", deliDTOList);
        model.addAttribute("price", price);
        return "/product/cancleExchangePopup";
    }

    @ResponseBody
    @PostMapping("/refundYN")
    public String refundYN(@RequestParam Map<String, Object> param) throws Exception {
        String result = "";
        String id = param.get("id").toString();
        Integer payPd_seq = Integer.parseInt(param.get("payPdSeq").toString());
        Integer count = productService.refundYN(payPd_seq);
        if (count != 0) {
            result = "Y";
        } else {
            result = "N";
        }
        return result;
    }

    @ResponseBody
    @PostMapping("/exchange")  //refund 테이블에 인서트 교환
    public String exchange(@RequestParam Map<String, Object> param) throws Exception {
        productService.insertExchange(param);
        return "success";
    }

    @RequestMapping("noticePopup") // 교환 신청 클릭 시 안내 팝업 띄움
    public String toNoticePopup() throws Exception {
        return "/product/noticePopup";
    }

    @ResponseBody
    @PostMapping("/checkStock")
    public boolean checkStock(@RequestParam String testArray) throws Exception {
        JsonParser jsonParser = new JsonParser();
        JsonArray jsonObject2 = (JsonArray) jsonParser.parse(testArray);
        boolean result = productService.checkStock(jsonObject2);
        return result;
    }

    @ResponseBody
    @PostMapping("/checkStockInCart")
    public boolean checkStockInCart(@RequestParam String testArray) throws Exception {
        JsonParser jsonParser = new JsonParser();
        JsonArray jsonObject2 = (JsonArray) jsonParser.parse(testArray);
        boolean result = productService.checkStockInCart(jsonObject2);
        return result;
    }

    @RequestMapping("/error")
    public String toErrorPage() throws Exception{
        return "/product/error";
    }



}