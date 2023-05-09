package com.example.Spring_Project.service;

import com.example.Spring_Project.dto.*;
import com.example.Spring_Project.mapper.ProductMapper;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.print.DocFlavor;
import java.rmi.MarshalledObject;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ProductService {

    @Autowired
    private ProductMapper productMapper;


    public List<ProductDTO> getProducts() throws Exception { //상품 리스트 가져오기
        return productMapper.getProducts();
    }

    public ProductDTO getProductDetail(Integer pd_seq) throws Exception { //상품 상세 정보
        return productMapper.getProductDetail(pd_seq);
    }

    public List<ProductDTO> getWProduct() throws Exception { //여자 카테고리
        return productMapper.getWProduct();
    }

    public List<ProductDTO> getWOuter() throws Exception { //여자 아우터
        return productMapper.getWOuter();
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

    public List<String> getCategory(Integer pd_seq) throws Exception { //상품 옵션 가져오기
        return productMapper.getCategory(pd_seq);
    }

    public List<String> optionByCategory(Integer pd_seq) throws Exception { //상품 카테고리별 옵션 정보
        return productMapper.optionByCategory(pd_seq);
    }

    public List<OptionListDTO> getOptionByGroup(String category, Integer pd_seq) throws Exception { //ex 색상 항목들
        return productMapper.getOptionByGroup(category, pd_seq);
    }

//    public void insertCart(Map<String, Object> map) throws Exception {
//        productMapper.insertCart(map);
//    }

    public void insertCart(String id, Integer count, Integer pd_seq, String optionList) throws Exception {
        productMapper.insertCart(id, count, pd_seq, optionList);
    }

    public void insertCartWtOption(String id, Integer count, Integer pd_seq) throws Exception {
        productMapper.insertCartWtOption(id, count, pd_seq);
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

    public List<ProductDTO> getProductsByKeyword(String keyword) throws Exception {
        return productMapper.getProductsByKeyword(keyword);
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

    public void insertPayPd(Integer pd_seq, Integer pay_seq) throws Exception {
        productMapper.insertPayPd(pd_seq, pay_seq);
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

    //페이징
    public Map<String, Object> paging(Integer cpage) throws Exception {
        //현재 페이지
        System.out.println("cpage = " + cpage);
        Integer postCount = countPost(); //글 개수
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

        System.out.println("startNavi = " + startNavi);
        System.out.println("endNavi = " + endNavi);
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

    //구매한 상품,옵션 정보 가져오기
    public List<Map<String, Object>> pdOptionInfo(List<Map<String, Object>> payInfoDTOS) throws Exception {
        List<Map<String, Object>> historyList = new ArrayList<>();

        JsonParser jsonParser = new JsonParser();
        JsonObject jsonObject = new JsonObject();
        JsonArray jsonArray = new JsonArray();

        for (Map<String, Object> payInfoDTO : payInfoDTOS) {
            Map<String, Object> map = new HashMap<>();
            ProductDTO productDTO = this.getPdInfo(Integer.parseInt(payInfoDTO.get("PD_SEQ").toString())); //상품 정보
            Integer price = Integer.parseInt(payInfoDTO.get("PRICE").toString());  //결제 금액
            String payMethod = payInfoDTO.get("PAYMETHOD").toString();  //결제 방법
            String payDate = payInfoDTO.get("PAYDATE").toString(); //결제 일자
            DeliDTO deliDTO = this.getDeliInfoBySeq(Integer.parseInt(payInfoDTO.get("DELI_SEQ").toString())); //배송지
            Integer count = Integer.parseInt(payInfoDTO.get("COUNT").toString());
            map.put("productDTO", productDTO);
            map.put("price", price);
            map.put("payMethod", payMethod);
            map.put("payDate", payDate);
            String phone = deliDTO.getPhone();
            String parsedPhone = phone.substring(0, 3) + "-" + phone.substring(3, 7) + "-" + phone.substring(7, 11);
            deliDTO.setPhone(parsedPhone);
            map.put("deliDTO", deliDTO);
            map.put("count", count);
            System.out.println("payInfoDTO = " + payInfoDTO.containsKey("OPTIONS"));
            if (payInfoDTO.containsKey("OPTIONS")) { //옵션 있을때
                Object object = jsonParser.parse(payInfoDTO.get("OPTIONS").toString());
                jsonObject = (JsonObject) object;
                jsonArray = (JsonArray) jsonObject.get("name");
                List<Map<String, Object>> optionMapList = new ArrayList<>();
                Map<String, Object> optionMap = null;
                System.out.println("jsonArray = " + jsonArray);
                System.out.println("jsonArray = " + jsonArray.size());
                for (int i = 0; i < jsonArray.size(); i++) {
                    optionMap = new HashMap<>();
                    //size = s
                    String optName = jsonArray.get(i).toString().replace("\"", "");
                    String optCategory = this.getOptCategory(productDTO.getPd_seq(), optName); //옵션 카테고리 이름 가져오기 (size)
                    System.out.println("optName = " + optName);
                    System.out.println("optCategory = " + optCategory);
                    optionMap.put(optCategory, optName);
                    optionMapList.add(optionMap);
                }
                System.out.println("optionMap = " + optionMap);
                System.out.println("optionMapList = " + optionMapList);
                map.put("option", optionMapList);
            }
            historyList.add(map);
        }
        return historyList;
    }

    //결제 테이블 인서트 시 결제 일자
    public Timestamp getPayDate(Integer pay_seq) throws Exception{
        return productMapper.getPayDate(pay_seq);
    }

    //결제 테이블 insert
    public void insertSales(Map<String,Object>salesParam) throws Exception{
        productMapper.insertSales(salesParam);
    }

    public List<SalesDTO> getSalesList() throws Exception{
        return productMapper.getSalesList();
    }
}