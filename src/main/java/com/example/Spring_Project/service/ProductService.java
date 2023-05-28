package com.example.Spring_Project.service;

import com.example.Spring_Project.dto.*;
import com.example.Spring_Project.mapper.ProductMapper;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.swing.text.html.Option;
import java.sql.Timestamp;
import java.util.*;

@Service
public class ProductService {

    @Autowired
    private ProductMapper productMapper;

    @Autowired
    private PdReviewService pdReviewService;


    public List<ProductDTO> getProducts(String keyword, Integer start, Integer end) throws Exception { //상품 리스트 가져오기
        return productMapper.getProducts(keyword, start, end);
    }

    public Integer countRegisteredPd() throws Exception {
        return productMapper.countRegisteredPd();
    }

    public Integer countSalesPd() throws Exception {
        return productMapper.countSalesPd();
    }

    public ProductDTO getProductDetail(Integer pd_seq) throws Exception { //상품 상세 정보
        return productMapper.getProductDetail(pd_seq);
    }

    public List<ProductDTO> getWProduct() throws Exception { //여자 카테고리
        return productMapper.getWProduct();
    }

    public Integer wOuterCnt() throws Exception {
        return productMapper.wOuterCnt();
    }

    public Integer wCnt() throws Exception {
        return productMapper.wCnt();
    }

    public Integer wTopCnt() throws Exception {
        return productMapper.wTopCnt();
    }

    public Integer wPantsCnt() throws Exception {
        return productMapper.wPantsCnt();
    }

    public Integer wAccCnt() throws Exception {
        return productMapper.wAccCnt();
    }

    public Integer mOuter() throws Exception {
        return productMapper.mOuter();
    }

    public Integer mTop() throws Exception {
        return productMapper.mTop();
    }

    public Integer mPants() throws Exception {
        return productMapper.mPants();
    }

    public Integer mAcc() throws Exception {
        return productMapper.mAcc();
    }

    public Integer nOuter() throws Exception {
        return productMapper.nOuter();
    }

    public Integer nTop() throws Exception {
        return productMapper.nTop();
    }

    public Integer nPants() throws Exception {
        return productMapper.nPants();
    }

    public Integer nAcc() throws Exception {
        return productMapper.nAcc();
    }

    public Integer mCnt() throws Exception {
        return productMapper.mCnt();
    }

    public Integer nCnt() throws Exception {
        return productMapper.nCnt();
    }

    public List<ProductDTO> getWOuter(Integer start, Integer end) throws Exception { //여자 아우터
        return productMapper.getWOuter(start, end);
    }

    public List<ProductDTO> getWTop() throws Exception { //여자 상의
        return productMapper.getWTop();
    }

    public List<ProductDTO> getWPants() throws Exception {  //여자 하의
        return productMapper.getWPants();
    }


    public List<ProductDTO> getWAccessories() throws Exception {  //여자 악세사리
        return productMapper.getWAccessories();
    }

    public List<ProductDTO> getMProduct() throws Exception {  // 남자 카테고리
        return productMapper.getMProduct();
    }

    public List<ProductDTO> getMOuter() throws Exception {  // 남자 아우터
        return productMapper.getMOuter();
    }

    public List<ProductDTO> getMTop() throws Exception {  // 남자 상의
        return productMapper.getMTop();
    }

    public List<ProductDTO> getMPants() throws Exception {  // 남자 하의
        return productMapper.getMPants();
    }

    public List<ProductDTO> getMAccessories() throws Exception {  // 남자 악세사리
        return productMapper.getMAccessories();
    }

    public List<ProductDTO> getNewProduct() throws Exception {  //신상품
        return productMapper.getNewProduct();
    }

    public List<ProductDTO> getNewOuter() throws Exception {  //신상아우터
        return productMapper.getNewOuter();
    }

    public List<ProductDTO> getNewTop() throws Exception {  //신상 상의
        return productMapper.getNewTop();
    }

    public List<ProductDTO> getNewPants() throws Exception {  //신상 하의
        return productMapper.getNewPants();
    }

    public List<ProductDTO> getNewAccessories() throws Exception {  //신상 악세사리
        return productMapper.getNewAccessories();
    }

    public List<OptionDTO> getOptions(Integer pd_seq) throws Exception { //상품 옵션 가져오기
        return productMapper.getOptions(pd_seq);
    }

    //옵션 개수 확인
    public void checkOptionStock(List<OptionDTO> optionDTO) throws Exception {
        for (OptionDTO dto : optionDTO) {
            Integer option_seq = dto.getOption_seq();
            Integer stock = productMapper.checkOptionStockBySeq(option_seq);
            if (stock == 0) productMapper.updateOptionStatus(option_seq);  //옵션 재고 0이면 status n으로
        }
    }

    public List<String> getCategory(Integer pd_seq) throws Exception { //상품 옵션 가져오기
        return productMapper.getCategory(pd_seq);
    }

    public List<String> optionByCategory(Integer pd_seq) throws Exception { //상품 카테고리별 옵션 정보
        return productMapper.optionByCategory(pd_seq);
    }

    public List<OptionListDTO> getOptionByGroup(String category, Integer pd_seq) throws Exception { //ex 색상 항목들
        return productMapper.getOptionByGroup(category, pd_seq);
    }

    public Map<String, Object> pagingStartEnd(Integer cpage, Integer naviPerPage) throws Exception {
        Integer start = cpage * naviPerPage - (naviPerPage - 1); //시작 글 번호
        Integer end = cpage * naviPerPage; // 끝 글 번호
        Map<String, Object> map = new HashMap<>();
        map.put("start", start);
        map.put("end", end);
        return map;
    }

    public void insertCart(String id, Integer count, Integer pd_seq, String optionList) throws Exception {
        productMapper.insertCart(id, count, pd_seq, optionList);
    }

    public void insertCartWtOption(String id, Integer count, Integer pd_seq) throws Exception {
        productMapper.insertCartWtOption(id, count, pd_seq);
    }

    public Integer isPdInCart(Integer pd_seq, String id) throws Exception {
        return productMapper.isPdInCart(pd_seq, id);
    }

    public void minusOption(Integer pd_seq, String optionName) throws Exception {
        productMapper.minusOption(pd_seq, optionName);
    }

    public void minusPd(Integer pd_seq) throws Exception {
        productMapper.minusPd(pd_seq);
    }

    public OptionDTO getOptionStock(Map<String, Object> map) throws Exception {
        return productMapper.getOptionStock(map);
    }

    public void updateOptionStatus(Integer option_seq) throws Exception {
        productMapper.updateOptionStatus(option_seq);
    }

    public void updatePdStatus(Integer product_seq) throws Exception {
        productMapper.updatePdStatus(product_seq);
    }

    public Integer getPdStock(Integer pd_seq) throws Exception {
        return productMapper.getPdStock(pd_seq);
    }

    public List<CartDTO> getCartInfo(String id) throws Exception {
        return productMapper.getCartInfo(id);
    }

    public List<String> getOptionCategory(Integer cart_seq) throws Exception {
        return productMapper.getOptionCategory(cart_seq);
    }

    public void deleteItem(Integer cart_seq) throws Exception {  //장바구니에서 아이템 삭제
        productMapper.deleteItem(cart_seq);
    }

    public void deleteCart(List<Integer> deleteCartSeq) throws Exception {
        for (Integer i : deleteCartSeq) {
            deleteItem(i);
        }
    }

    public Map<String, Object> getCartOption(Integer cart_seq) throws Exception {  // 상품 하나당 옵션 가져오기
        return productMapper.getCartOption(cart_seq);
    }

    public Integer getOptionCount(Integer pd_seq, String option) throws Exception {
        return productMapper.getOptionCount(pd_seq, option);
    }

    public Integer getPdPrice(Integer pd_seq) throws Exception {
        return productMapper.getPdPrice(pd_seq);
    }

    public Integer getMemberSeq(String id) throws Exception { //m_seq 가져오기
        return productMapper.getMemberSeq(id);
    }

    public List<CouponDTO> getCoupon(Integer m_seq) throws Exception { //쿠폰리스트 가져오기
        return productMapper.getCoupon(m_seq);
    }

    public Integer getMemPoint(String id) throws Exception {
        return productMapper.getMemPoint(id);
    }

    public void updateCount(Integer count, Integer cart_seq) throws Exception {
        productMapper.updateCount(count, cart_seq);
    }

    public Integer getChangedPrice(Integer discount, Integer price) throws Exception {  //쿠폰 먹여서 가격 변경하기
        return productMapper.getChangedPrice(discount, price);
    }

    public String getDefaultAddress(String id) throws Exception {
        return productMapper.getDefaultAddress(id);
    }

    public String getAdditionalAddress1(String id) throws Exception {
        return productMapper.getAdditionalAddress1(id);
    }

    public String getAdditionalAddress2(String id) throws Exception {
        return productMapper.getAdditionalAddress2(id);
    }

    public String getName(String id) throws Exception {
        return productMapper.getName(id);
    }

    public String getPhone(String id) throws Exception {
        return productMapper.getPhone(id);
    }

    public List<CouponDTO> checkCouponPr() throws Exception {  //쿠폰 리스트
        return productMapper.checkCouponPr();
    }

    public void updCoupon(Integer cp_seq) throws Exception {  //쿠폰 상태 변경
        productMapper.updCoupon(cp_seq);
    }

    public void updCartStatus(String id) throws Exception {
        productMapper.updCartStatus(id);
    }

    public void chgPdCount(Integer pd_seq, Integer count) throws Exception {  //상품 수량 변경
        productMapper.chgPdCount(pd_seq, count);
    }

    public void chgOptionCount(Map<String, Object> map) throws Exception {  //상품 옵션 수량 변경
        productMapper.chgOptionCount(map);
    }

    public Integer getPdSeq(Integer cart_seq) throws Exception {
        return productMapper.getPdSeq(cart_seq);
    }

    public void updOptionStock(Integer option_seq, Integer pd_seq) throws Exception {
        productMapper.updOptionStock(option_seq, pd_seq);
    }

    public Integer likeYN(String id, Integer pd_seq) throws Exception {
        return productMapper.likeYN(id, pd_seq);
    }

    public void insertLike(String id, Integer pd_seq) throws Exception {
        productMapper.insertLike(id, pd_seq);
    }

    public void cancleLike(String id, Integer pd_seq) throws Exception {
        productMapper.cancleLike(id, pd_seq);
    }

    public Integer getCategorySeq(String category1, String category2) throws Exception {
        return productMapper.getCategorySeq(category1, category2);
    }

    public void insertPd(Map<String, Object> param) throws Exception {
        productMapper.insertPd(param);
    }

    public Integer getPdCurrVal() throws Exception {
        return productMapper.getPdCurrVal();
    }

    public void insertOption(Map<String, Object> map1) throws Exception {
        productMapper.insertOption(map1);
    }

    public Integer isOptExist(Integer pd_seq) throws Exception {
        return productMapper.isOptExist(pd_seq);
    }

    public List<OptionDTO> getOptByGroup(Integer pd_seq) throws Exception {
        return productMapper.getOptByGroup(pd_seq);
    }

    public void deletePd(Integer pd_seq) throws Exception {
        productMapper.deletePd(pd_seq);
    }

    public ProductDTO getPdInfo(Integer pd_seq) throws Exception {
        return productMapper.getPdInfo(pd_seq);
    }

    public CategoryDTO getPdCategory(Integer category) throws Exception {
        return productMapper.getPdCategory(category);
    }

    public CategoryDTO getPdSubCategory(Integer category) throws Exception {
        return productMapper.getPdSubCategory(category);
    }

    public void updPdImg(Integer pd_seq, String sysname) throws Exception {
        productMapper.updPdImg(pd_seq, sysname);
    }

    public void updProduct(Map<String, Object> param) throws Exception {
        productMapper.updProduct(param);
    }

    public void updOptionStatus(Integer option_seq) throws Exception {
        productMapper.updOptionStatus(option_seq);
    }

    public Integer getNextOptSeq() throws Exception {
        return productMapper.getNextOptSeq();
    }

    public void insertNewOptions(Map<String, Object> insertParam) throws Exception {
        productMapper.insertNewOptions(insertParam);
    }

    public void updOptions(Map<String, Object> updParam) throws Exception {
        productMapper.updOptions(updParam);
    }

    public List<ProductDTO> getProductsByKeyword(String keyword, Integer start, Integer end) throws Exception {
        return productMapper.getProductsByKeyword(keyword, start, end);
    }

    public List<CartDTO> cartInfo(Integer cart_seq) throws Exception {
        return productMapper.cartInfo(cart_seq);
    }

    public Integer getPdCount(Integer cart_seq) throws Exception {
        return productMapper.getPdCount(cart_seq);
    }

    public String getOption(Integer cart_seq) throws Exception {
        return productMapper.getOption(cart_seq);
    }

    public void updMemPoint(String id, Integer usedPoint, double totalNewPoint) throws Exception {
        productMapper.updMemPoint(id, usedPoint, totalNewPoint);
    }

    public Integer getId(String id) throws Exception {
        return productMapper.getId(id);
    }

    public void insertBuyPd(String id, Integer sum, Integer price) throws Exception {
        productMapper.insertBuyPd(id, sum, price);
    }

    public void updateBuyPd(String id, Integer sum, Integer price) throws Exception {
        productMapper.updateBuyPd(id, sum, price);
    }

    public Integer getSum(String id) throws Exception {
        return productMapper.getSum(id);
    }

    public Integer getPrice(String id) throws Exception {
        return productMapper.getPrice(id);
    }

//    public Integer getPrice(Integer pdSeq) throws Exception{
//        return productMapper.getPrice(pdSeq);
//    }

    public Double getPercent(Integer pdSeq) throws Exception {
        return productMapper.getPercent(pdSeq);
    }

    public void updCartFlag(Integer cart_seq) throws Exception {
        productMapper.updCartFlag(cart_seq);
    }

    public void updFlagToY(Integer cart_seq) throws Exception {
        productMapper.updFlagToY(cart_seq);
    }

    public List<CartDTO> getCart(String id) throws Exception {
        return productMapper.getCart(id);
    }

    public List<DeliDTO> getDeliveryInfo(String id) throws Exception {
        return productMapper.getDeliveryInfo(id);
    }

    public List<DeliDTO> deliveryInfo(String id) throws Exception {
        return productMapper.deliveryInfo(id);
    }

    public void insertDeli(Map<String, Object> param) throws Exception {
        productMapper.insertDeli(param);
    }

    public DeliDTO getSeqDeli(Integer seq) throws Exception {
        return productMapper.getSeqDeli(seq);
    }

    public Integer getCurrval() throws Exception {
        return productMapper.getCurrval();
    }

    public void updDeliStatus(Integer seq) throws Exception {
        productMapper.updDeliStatus(seq);
    }

    public void updDeli(Map<String, Object> param) throws Exception {
        productMapper.updDeli(param);
    }

    public void deleteDeli(Integer seq) throws Exception {
        productMapper.deleteDeli(seq);
    }

    public void updStatus(Integer seq) throws Exception {
        productMapper.updStatus(seq);
    }

    public DeliDTO getDefaultAddr() throws Exception {
        return productMapper.getDefaultAddr();
    }

    public Integer currPaySeq() throws Exception {
        return productMapper.currPaySeq();
    }

    public void insertPayProduct(Map<String, Object> parameter) throws Exception {
        productMapper.insertPayProduct(parameter);
    }

    public void insertPayPd(Integer pd_seq, Integer pay_seq, Integer count) throws Exception {
        productMapper.insertPayPd(pd_seq, pay_seq, count);
    }

    public Integer getDefaultAdr() throws Exception {
        return productMapper.getDefaultAdr();
    }


    public List<Map<String, Object>> getHistory(String id, Integer start, Integer end) throws Exception {
        return productMapper.getHistory(id, start, end);
    }

    public DeliDTO getDeliInfoBySeq(Integer deli_seq) throws Exception {
        return productMapper.getDeliInfoBySeq(deli_seq);
    }

    public String getOptCategory(Integer pd_seq, String optName) throws Exception {
        return productMapper.getOptCategory(pd_seq, optName);
    }

    public Integer countPost() throws Exception {  //글 개수
        return productMapper.countPost();
    }

    public Integer salesPdCount() throws Exception {  //글 개수
        return productMapper.salesPdCount();
    }

    public Integer productCnt(String keyword) throws Exception {  //상품 총 개수
        return productMapper.productCnt(keyword);
    }

    public PayProductDTO getPayProductInfo(Integer pay_seq, Integer pd_seq) throws Exception {
        return productMapper.getPayProductInfo(pay_seq, pd_seq);
    }

    //페이징
    public Map<String, Object> pagingPdList(Integer cpage, String keyword) throws Exception {
        //현재 페이지
        System.out.println("cpage = " + cpage);
        Integer postCount = productCnt(keyword); //전체 상품수
        Integer postPerPage = 10; //페이지 당 글 개수
        Integer naviPerPage = 10; //페이지 당 내비 수
        Integer totalPageCount = 0; //전체 페이지 수
        Map<String, Object> map = new HashMap<>();
        if (postCount % naviPerPage > 0) {
            totalPageCount = postCount / naviPerPage + 1;
        } else {
            totalPageCount = postCount / naviPerPage;
        }

        if (cpage > totalPageCount) {
            cpage = totalPageCount;
        }

        int startNavi = (cpage - 1) / naviPerPage * naviPerPage + 1;  //페이지 start
        int endNavi = startNavi + naviPerPage - 1; //페이지 end

        if (endNavi > totalPageCount) {
            endNavi = totalPageCount;
        }

        boolean needPrev = true;
        boolean needNext = true;

        if (startNavi == 1) {
            needPrev = false;
        }
        if (endNavi == totalPageCount) {
            needNext = false;
        }

        map.put("startNavi", startNavi);
        map.put("endNavi", endNavi);
        map.put("needPrev", needPrev);
        map.put("needNext", needNext);
        map.put("totalPageCount", totalPageCount);
        map.put("cpage", cpage);
        return map;
    }

    //페이징
    public Map<String, Object> paging(Integer cpage, Integer postCnt) throws Exception {
        //현재 페이지
//        Integer postCount = salesPdCount(); //판매 상품수
        Integer postCount = postCnt; //판매 상품수
        System.out.println("postCount = " + postCount);
        Integer postPerPage = 10; //페이지 당 글 개수
        Integer naviPerPage = 10; //페이지 당 내비 수
        Integer totalPageCount = 0; //전체 페이지 수
        Map<String, Object> map = new HashMap<>();
        if (postCount % naviPerPage > 0) {
            totalPageCount = postCount / naviPerPage + 1;
        } else {
            totalPageCount = postCount / naviPerPage;
        }

        if (cpage > totalPageCount) {
            cpage = totalPageCount;
        }

        int startNavi = (cpage - 1) / naviPerPage * naviPerPage + 1;  //페이지 start
        int endNavi = startNavi + naviPerPage - 1; //페이지 end

        if (endNavi > totalPageCount) {
            endNavi = totalPageCount;
        }

        boolean needPrev = true;
        boolean needNext = true;

        if (startNavi == 1) {
            needPrev = false;
        }
        if (endNavi == totalPageCount) {
            needNext = false;
        }

        map.put("startNavi", startNavi);
        map.put("endNavi", endNavi);
        map.put("needPrev", needPrev);
        map.put("needNext", needNext);
        map.put("totalPageCount", totalPageCount);
        map.put("cpage", cpage);
        return map;
    }

    public Integer historyCnt(String id) throws Exception {
        return productMapper.historyCnt(id);
    }

    public Map<String, Object> historyPaging(Integer cpage, String id) throws Exception {
        //현재 페이지
        Integer postCount = historyCnt(id); //판매 상품수
        Integer postPerPage = 10; //페이지 당 글 개수
        Integer naviPerPage = 10; //페이지 당 내비 수
        Integer totalPageCount = 0; //전체 페이지 수
        Map<String, Object> map = new HashMap<>();
        if (postCount % naviPerPage > 0) {
            totalPageCount = postCount / naviPerPage + 1;
        } else {
            totalPageCount = postCount / naviPerPage;
        }

        if (cpage > totalPageCount) {
            cpage = totalPageCount;
        }

        int startNavi = (cpage - 1) / naviPerPage * naviPerPage + 1;  //페이지 start
        int endNavi = startNavi + naviPerPage - 1; //페이지 end

        if (endNavi > totalPageCount) {
            endNavi = totalPageCount;
        }

        boolean needPrev = true;
        boolean needNext = true;

        if (startNavi == 1) {
            needPrev = false;
        }
        if (endNavi == totalPageCount) {
            needNext = false;
        }

        map.put("startNavi", startNavi);
        map.put("endNavi", endNavi);
        map.put("needPrev", needPrev);
        map.put("needNext", needNext);
        map.put("totalPageCount", totalPageCount);
        map.put("cpage", cpage);
        return map;
    }

    public RefundDTO refundInfo(Integer payPd_seq) throws Exception {
        return productMapper.refundInfo(payPd_seq);
    }

    //관리자가 환불 승인했는지
    public Integer isRefundApprove(Integer refund_seq) throws Exception {
        return productMapper.isRefundApprove(refund_seq);
    }

    //구매한 상품,옵션 정보 가져오기
    public List<Map<String, Object>> pdOptionInfo(List<Map<String, Object>> payInfoDTOS) throws Exception {
        List<Map<String, Object>> historyList = new ArrayList<>();

        JsonParser jsonParser = new JsonParser();
        JsonObject jsonObject = new JsonObject();
        JsonArray jsonArray = new JsonArray();

        for (Map<String, Object> payInfoDTO : payInfoDTOS) {
            System.out.println("payInfoDTOS = " + payInfoDTOS);
            Map<String, Object> map = new HashMap<>();
            ProductDTO productDTO = this.getPdInfo(Integer.parseInt(payInfoDTO.get("PD_SEQ").toString())); //상품 정보
            Integer price = Integer.parseInt(payInfoDTO.get("PRICE").toString());  //결제 금액
            String payMethod = payInfoDTO.get("PAYMETHOD").toString();  //결제 방법
            String payDate = payInfoDTO.get("PAYDATE").toString(); //결제 일자
            DeliDTO deliDTO = this.getDeliInfoBySeq(Integer.parseInt(payInfoDTO.get("DELI_SEQ").toString())); //배송지
            Integer count = Integer.parseInt(payInfoDTO.get("TOTALPAYPDCNT").toString());  //한 번에 결제했을때 총 결제한 개수
            Integer cntPerPd = Integer.parseInt(payInfoDTO.get("PAYPDCNT").toString()); //상품 하나당 결제 개수
            Integer pay_seq = Integer.parseInt(payInfoDTO.get("PAY_SEQ").toString());
            Integer pd_seq = Integer.parseInt(payInfoDTO.get("PD_SEQ").toString());
            Integer payPd_seq = Integer.parseInt(payInfoDTO.get("PAYPD_SEQ").toString());
            PayProductDTO payProductDTO1 = this.getPayProductInfo(pay_seq, pd_seq);
            RefundDTO refundDTO = refundInfo(payPd_seq);
            //관리자가 환불 승인했는지
            Integer isRefundApprove = 0;
            if (refundDTO != null) {
                isRefundApprove = isRefundApprove(refundDTO.getRefund_seq());
            }

            // 한 번 구매할때 행수
            Integer payPdCnt = productMapper.getPayPdCnt(pay_seq);

            ReviewDTO reviewDTO = pdReviewService.reviewInfo(payPd_seq);//리뷰 상태
            String deliStatus = "";
            if (refundDTO != null) {
                //구매내역 들어갈때마다 반품 처리 배송 완료 되어있는지 확인
                // shopRefund status = Y -> refund status = Y로 변경
                deliStatus = productMapper.getDeliStatusByRefundSeq(refundDTO.getRefund_seq());
            }
            if (deliStatus != null) {
                if (deliStatus.equals("Y")) {
//                productMapper.updRefundStatus(refundDTO.getRefund_seq());
                    refundDTO.setStatus("Y");
                }
            }

            if (reviewDTO != null) {
                map.put("reviewDTO", reviewDTO);
            }


            map.put("isRefundApprove", isRefundApprove);
            map.put("productDTO", productDTO);
            map.put("payPdCnt", payPdCnt);
            map.put("refundDTO", refundDTO);
            map.put("price", price);
            map.put("payMethod", payMethod);
            map.put("payDate", payDate);
            map.put("deliYN", payProductDTO1.getDeliYN());
            map.put("code", payProductDTO1.getCode());
            map.put("payPd_seq", payInfoDTO.get("PAYPD_SEQ"));
            map.put("pay_seq", payInfoDTO.get("PAY_SEQ"));
            String phone = deliDTO.getPhone();
            String parsedPhone = phone.substring(0, 3) + "-" + phone.substring(3, 7) + "-" + phone.substring(7, 11);
            deliDTO.setPhone(parsedPhone);
            map.put("deliDTO", deliDTO);
            map.put("count", count);
            map.put("cntPerPd", cntPerPd);
            map.put("usedPoint", Integer.parseInt(payInfoDTO.get("USEDPOINT").toString()));
            if (payInfoDTO.containsKey("OPTIONS")) { //옵션 있을때
                Object object = jsonParser.parse(payInfoDTO.get("OPTIONS").toString());
                jsonObject = (JsonObject) object;
                jsonArray = (JsonArray) jsonObject.get("name");
                List<Map<String, Object>> optionMapList = new ArrayList<>();
                Map<String, Object> optionMap = null;
                for (int i = 0; i < jsonArray.size(); i++) {
                    optionMap = new HashMap<>();
                    //size = s
                    String optName = jsonArray.get(i).toString().replace("\"", "");
                    String optCategory = this.getOptCategory(productDTO.getPd_seq(), optName); //옵션 카테고리 이름 가져오기 (size)
                    optionMap.put(optCategory, optName);
                    optionMapList.add(optionMap);
                }
                map.put("option", optionMapList);
            }
            historyList.add(map);
        }
        return historyList;
    }

    //결제 테이블 인서트 시 결제 일자
    public Timestamp getPayDate(Integer pay_seq) throws Exception {
        return productMapper.getPayDate(pay_seq);
    }

    //결제 테이블 insert
    public void insertSales(Map<String, Object> salesParam) throws Exception {
        productMapper.insertSales(salesParam);
    }

    public List<SalesDTO> getSalesList(Integer start, Integer end) throws Exception {
        return productMapper.getSalesList(start, end);
    }

    public List<CourierDTO> getCourierInfo() throws Exception {
        return productMapper.getCourierInfo();
    }

    public void insert(Integer code, String name) throws Exception {
        productMapper.insert(code, name);
    }

    public Integer getCourierCode(String name) throws Exception {
        return productMapper.getCourierCode(name);
    }

    public void chgRefundStatus(Integer payPd_seq, Integer refund_seq) throws Exception {
        productMapper.chgRefundStatus(payPd_seq, refund_seq);
    }

    public void deliveryStatus(Integer code, Integer sales_seq) throws Exception {
        productMapper.deliveryStatus(code, sales_seq);
    }

    public PayInfoDTO getPayInfo(Integer pay_seq) throws Exception {
        return productMapper.getPayInfo(pay_seq);
    }

    public Integer getCurrPayPdSeq() throws Exception {
        return productMapper.getCurrPayPdSeq();
    }

    public PayProductDTO getDeliYN(Integer salesSeq) throws Exception {
        return productMapper.getDeliYN(salesSeq);
    }

    public void updDeliveryStatus(Integer sales_seq, Integer courierCode, String postNum) throws Exception {
        productMapper.updDeliveryStatus(sales_seq, courierCode, postNum);
    }

    //상품 디테일
    public Map<String, List<OptionListDTO>> pdDetail(List<OptionDTO> optionDTO, List<String> category, Integer pd_seq) throws Exception {
        Map<String, List<OptionListDTO>> optionList = new HashMap();
        Integer size = optionDTO.size();
        if (optionDTO != null || size != 0) {
            for (Integer i = 0; i < category.size(); i++) {
                String cg = category.get(i);
                List<OptionListDTO> getOptionByGroup = this.getOptionByGroup(category.get(i), pd_seq);  //카테고리별 optionList
                optionList.put(cg, getOptionByGroup);
            }
        }
        return optionList;
    }

    //옵션 있을때 장바구니에 상품 추가
    public Map<String, List<String>> getOptionList(Map<String, Object> map) throws Exception {
        String[] test = map.get("optionList").toString().split(",");
        for (Integer i = 0; i < test.length; i++) {
            test[i] = map.get("optionList").toString().split(",")[i];
        }
        List<String> list = new ArrayList<>();
        Map<String, List<String>> optionList = new HashMap<>();
        for (int i = 0; i < test.length; i++) {
            Map<String, Object> options = new HashMap<>();
            String option_name = test[i].substring(0, test[i].indexOf("("));
            list.add(option_name);
            optionList.put("name", list);
        }
        return optionList;
    }


    //pd 재고 count
    public Integer count(Map<String, Object> cartOption, Integer cart_seq) throws Exception {
        int stock = 0;
        if (cartOption.size() != 1) {
            //pd_seq
            Integer pd_seq = Integer.parseInt(cartOption.get("PD_SEQ").toString());
            //옵션
            JsonParser jsonParser = new JsonParser();
            JsonObject jsonObject = (JsonObject) jsonParser.parse((String) cartOption.get("OPTIONS"));

            JsonArray jsonArray = (JsonArray) jsonObject.get("name");

            int[] list = new int[jsonArray.size()];

            for (int i = 0; i < jsonArray.size(); i++) {
                int index = jsonArray.get(i).toString().indexOf("\"");
                String option = jsonArray.get(i).toString().substring(index + 1, jsonArray.get(i).toString().length() - 1);
                stock = this.getOptionCount(pd_seq, option);
                list[i] = stock;
            }
            stock = Arrays.stream(list).min().getAsInt();
        } else if (cartOption.size() == 1) {
            Integer pd_seq = this.getPdSeq(cart_seq);// pd_seq 가져오기
            stock = this.getPdStock(pd_seq);
        }
        return stock;
    }

    public List<String> getParentCategory() throws Exception {
        return productMapper.getParentCategory();
    }

    public List<String> getChildCategory() throws Exception {
        return productMapper.getChildCategory();
    }

    public Integer parentCategorySeq(String parentCtgOption) throws Exception {
        return productMapper.parentCategorySeq(parentCtgOption);
    }

    public Integer pdCategorySeq(Integer parentCategorySeq, String childCtgOption) throws Exception {
        return productMapper.pdCategorySeq(parentCategorySeq, childCtgOption);
    }

    public Map<String, Object> revCategory(Integer parentCategorySeq, Integer pdCategorySeq) throws Exception {
        return productMapper.revCategory(parentCategorySeq, pdCategorySeq);
    }

    public Integer countReview() throws Exception {
        return productMapper.countReview();
    }

    public Integer searchPdCnt(String keyword) throws Exception {
        return productMapper.searchPdCnt(keyword);
    }

    public Map<String, Object> refundPdInfo(Map<String, Object> map) throws Exception {
        Integer payPdSeq = Integer.parseInt(map.get("payPdSeq").toString());
        String id = map.get("id").toString();
        Map<String, Object> refundPdInfo = productMapper.refundPdInfo(payPdSeq);
        return refundPdInfo;
    }

    public Map<String, Object> refundData(Map<String, Object> map) throws Exception {
        Integer payPdSeq = Integer.parseInt(map.get("payPdSeq").toString());
        String id = map.get("id").toString();
        Map<String, Object> refundPdInfo = productMapper.refundData(payPdSeq);
        return refundPdInfo;
    }

    public List<Map<String, Object>> refundPdWithOpt(Map<String, Object> refundPdInfo) throws Exception {
        System.out.println("refundPdInfo = " + refundPdInfo);
        JsonParser jsonParser = new JsonParser();
        Object object = jsonParser.parse((String) refundPdInfo.get("OPTIONS"));
        JsonObject jsonObject = (JsonObject) object;
        JsonArray jsonArray = (JsonArray) jsonObject.get("name");
        List<Map<String, Object>> optionMapList = new ArrayList<>();
        Map<String, Object> optionMap = null;
        for (int i = 0; i < jsonArray.size(); i++) {
            optionMap = new HashMap<>();
            //size = s
            String optName = jsonArray.get(i).toString().replace("\"", "");
            String optCategory = this.getOptCategory(Integer.parseInt(refundPdInfo.get("PD_SEQ").toString()), optName); //옵션 카테고리 이름 가져오기 (size)
            optionMap.put(optCategory, optName);
            optionMapList.add(optionMap);
        }
        return optionMapList;
    }


    //환불 테이블 인서트
    public void insertRefund(Map<String, Object> param) throws Exception {
        productMapper.insertRefund(param);
    }

    //교환 테이블 인서트
    public void insertExchange(Map<String, Object> param) throws Exception {
        productMapper.insertExchange(param);
    }

    public void updRefundStatus(Integer payPd_seq) throws Exception {
        productMapper.updRefundStatus(payPd_seq);
    }

    //환불 교환 개수
    public Integer refundCount() throws Exception {
        return productMapper.refundCount();
    }

    //타입별 환불 교환 개수
    public Integer refundCntByType(String type) throws Exception {
        return productMapper.refundCntByType(type);
    }

    //환불 교환 리스트
    public List<RefundDTO> refundList(Integer start, Integer end) throws Exception {
        return productMapper.refundList(start, end);
    }

    //타입별 환불 교환 리스트
    public List<RefundDTO> refundListByType(Integer start, Integer end, String type) throws Exception {
        return productMapper.refundListByType(start, end, type);
    }

    public PayProductDTO payPdInfo(Integer payPd_seq) throws Exception {
        return productMapper.payPdInfo(payPd_seq);
    }

    public ShopRefundDTO refundInfoByPayPd_seq(Integer refund_seq) throws Exception {
        return productMapper.refundInfoByPayPd_seq(refund_seq);
    }

    @Transactional
    public List<Object> getRefundInfo(List<RefundDTO> refundList) throws Exception {
        JsonParser jsonParser = new JsonParser();
        List<Object> refundInfoList = new ArrayList<>();
        List<Map<String, Object>> optionMapList = new ArrayList<>();
        if (refundList != null) {
            for (RefundDTO dto : refundList) {
                Map<String, Object> map = new HashMap<>();
                Integer payPd_seq = dto.getPayPd_seq();
                PayProductDTO payProductDTO = payPdInfo(payPd_seq);
                ProductDTO productDTO = productMapper.getPdInfo(payProductDTO.getPd_seq());
                if (dto.getType().equals("exchange")) {
                    DeliDTO deliDTO = productMapper.getDeliInfoBySeq(dto.getDeli_seq());
                    String phone = deliDTO.getPhone().substring(0, 3) + "-" + deliDTO.getPhone().substring(3, 7) + "-" + deliDTO.getPhone().substring(7, 11);
                    deliDTO.setPhone(phone);
                    map.put("deliDTO", deliDTO);
                }
                ShopRefundDTO shopRefundDTO = refundInfoByPayPd_seq(dto.getRefund_seq());
//                if (shopRefundDTO != null) {
//                    if (shopRefundDTO.getDeliStatus().equals("Y")) {   //교환 반품 -> 배송완료되면 refundDTO status Y로 변경
////                    productMapper.updRefundStatus(dto.getRefund_seq()); //refundDTO status Y로 변경
//                        //포인트 환불
//                        //
//                    }
//                }
                RefundDetailDTO refundDetailDTO = productMapper.getRefundDetail(payPd_seq);
                if (dto.getType().equals("refund")) {
                    Integer payTotalSum = refundDetailDTO.getPayTotalSum();  //전체 구매 개수
                    Integer refundPdCount = refundDetailDTO.getRefundPdCount(); //환불 신청한 상품 개수
                    Integer originalPdPrice = refundDetailDTO.getOriginalPdPrice(); //환불 신청한 상품 원래 가격
                    Integer refundPoint = 0; //환불받을 포인트
                    if (refundDetailDTO.getUsedPoint() != 0) {
                        refundPoint = Math.round(refundDetailDTO.getUsedPoint() / payTotalSum);
                    }
                    Integer refundMoney = originalPdPrice * refundPdCount - refundPoint;
                    map.put("refundPoint", refundPoint); //환불받을 포인트
                    map.put("refundMoney", refundMoney); //환불받을 돈
                    //멤버 포인트 다시 증가시킴
                    productMapper.increaseMemPoint(dto.getId(), refundPoint);

                }

                map.put("shopRefundDTO", shopRefundDTO);
                map.put("content", dto.getContent());
                map.put("applyDate", dto.getApplyDate());
                map.put("deliSeq", dto.getDeli_seq());
                map.put("id", dto.getId());
                map.put("count", payProductDTO.getCount());
                map.put("pd_seq", payProductDTO.getPd_seq());
                map.put("payPd_seq", dto.getPayPd_seq());
                map.put("refund_seq", dto.getRefund_seq());
                Integer price = payProductDTO.getCount() * productDTO.getPrice();
                map.put("price", price);
                map.put("productDTO", productDTO);
                map.put("refundDTO", dto);

                //옵션 있으면
                Map<String, Object> optionMap = null;
                if (payProductDTO.getOptions() != null) {
                    Object object = jsonParser.parse((String) payProductDTO.getOptions());
                    JsonObject jsonObject = (JsonObject) object;
                    JsonArray jsonArray = (JsonArray) jsonObject.get("name");
                    for (int i = 0; i < jsonArray.size(); i++) {
                        optionMap = new HashMap<>();
                        //size = s
                        String optName = jsonArray.get(i).toString().replace("\"", "");
                        String optCategory = this.getOptCategory(payProductDTO.getPd_seq(), optName); //옵션 카테고리 이름 가져오기 (size)
                        optionMap.put(optCategory, optName);
                        optionMapList.add(optionMap);
                    }
                    map.put("optionMapList", optionMapList);
                }
                refundInfoList.add(map);
            }
        }
        return refundInfoList;
    }

    public Integer isPdInCartWtOpt(Integer pd_seq, String options, String id) throws Exception {
        return productMapper.isPdInCartWtOpt(pd_seq, options, id);
    }

    public Integer refundYN(Integer payPd_seq) throws Exception {
        return productMapper.refundYN(payPd_seq);
    }

    public Integer getParentCategorySeq(String parentCategory) throws Exception {
        return productMapper.getParentCategorySeq(parentCategory);
    }

    public Integer getChildCategorySeq(Integer parent_category_seq, String childCategory) throws Exception {
        return productMapper.getChildCategorySeq(parent_category_seq, childCategory);
    }

    public Integer pdCntByCategory(Integer child_category_seq) throws Exception {
        return productMapper.pdCntByCategory(child_category_seq);
    }

    public Integer pdCountByParent_category() throws Exception {
        return productMapper.pdCountByParent_category();
    }

    public Integer pdCountByMen() throws Exception {
        return productMapper.pdCountByMen();
    }

    public Integer pdCountByNew() throws Exception {
        return productMapper.pdCountByNew();
    }

    public List<ProductDTO> pdListByCategory(Integer start, Integer end, Integer child_category_seq) throws Exception {
        return productMapper.pdListByCategory(start, end, child_category_seq);
    }

    public List<ProductDTO> pdListByParentCategory(Integer start, Integer end) throws Exception {
        return productMapper.pdListByParentCategory(start, end);
    }

    public List<ProductDTO> pdListByMen(Integer start, Integer end) throws Exception {
        return productMapper.pdListByMen(start, end);
    }

    public List<ProductDTO> pdListByNew(Integer start, Integer end) throws Exception {
        return productMapper.pdListByNew(start, end);
    }
}
