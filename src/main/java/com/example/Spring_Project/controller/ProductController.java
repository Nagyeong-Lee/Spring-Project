package com.example.Spring_Project.controller;

import aj.org.objectweb.asm.TypeReference;
import com.example.Spring_Project.dto.*;
import com.example.Spring_Project.service.MemberService;
import com.example.Spring_Project.service.PayService;
import com.example.Spring_Project.service.ProductService;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.*;
import com.google.gson.reflect.TypeToken;
import org.apache.logging.log4j.util.PerformanceSensitive;
import org.json.JSONArray;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.lang.reflect.Type;
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

    @RequestMapping("/list") //전체 상품 리스트
    public String productList(Model model, Integer cpage) throws Exception {
        if (cpage == null) cpage = 1;
        Map<String, Object> paging = productService.pagingPdList(cpage);
        Integer naviPerPage = 10;
        Integer start = cpage * naviPerPage - (naviPerPage - 1); //시작 글 번호
        Integer end = cpage * naviPerPage; // 끝 글 번호

        List<ProductDTO> productDTOList = productService.getProducts(start, end);
        model.addAttribute("productDTOList", productDTOList);
        model.addAttribute("paging", paging);
        return "/product/productList";
    }

    //상품 디테일
    @RequestMapping("/detail")
    public String detail(Model model, Integer pd_seq) throws Exception {
        ProductDTO productDTO = productService.getProductDetail(pd_seq); //상품 상세 정보
        List<OptionDTO> optionDTO = productService.getOptions(pd_seq); //상품 옵션 정보
        List<String> category = productService.getCategory(pd_seq);//옵션 카테고리

        Map<String, List<OptionListDTO>> optionList = new HashMap();

        if (optionDTO != null || optionDTO.size() != 0) {
            for (Integer i = 0; i < category.size(); i++) {
                String cg = category.get(i);
                List<OptionListDTO> getOptionByGroup = productService.getOptionByGroup(category.get(i), pd_seq);  //카테고리별 optionList
                optionList.put(cg, getOptionByGroup);
            }
            model.addAttribute("productDTO", productDTO);
            model.addAttribute("optionDTO", optionDTO);
            model.addAttribute("category", category);
            model.addAttribute("optionList", optionList);
        }
        return "/product/detail";
    }

    //여성 카테고리
    @RequestMapping("/women")
    public String wProduct(Model model) throws Exception {
        List<ProductDTO> productDTOList = productService.getWProduct();
        model.addAttribute("productDTOList", productDTOList);
        return "/product/women";
    }

    @RequestMapping("/women/outer")
    public String wOuter(Model model) throws Exception {
        List<ProductDTO> productDTOList = productService.getWOuter();
        model.addAttribute("productDTOList", productDTOList);
        return "/product/women/outer";
    }

    @RequestMapping("/women/top")
    public String wTop(Model model) throws Exception {
        List<ProductDTO> productDTOList = productService.getWTop();
        model.addAttribute("productDTOList", productDTOList);
        return "/product/women/top";
    }

    @RequestMapping("/women/pants")
    public String wPants(Model model) throws Exception {
        List<ProductDTO> productDTOList = productService.getWPants();
        model.addAttribute("productDTOList", productDTOList);
        return "/product/women/pants";
    }

    @RequestMapping("/women/accessories")
    public String wAccessories(Model model) throws Exception {
        List<ProductDTO> productDTOList = productService.getWAccessories();
        model.addAttribute("productDTOList", productDTOList);
        return "/product/women/accessories";
    }

    //남성 카테고리
    @RequestMapping("/men")
    public String mProduct(Model model) throws Exception {
        List<ProductDTO> productDTOList = productService.getMProduct();
        model.addAttribute("productDTOList", productDTOList);
        return "/product/men";
    }

    @RequestMapping("/men/outer")
    public String mOuter(Model model) throws Exception {
        List<ProductDTO> productDTOList = productService.getMOuter();
        model.addAttribute("productDTOList", productDTOList);
        return "/product/men/outer";
    }

    @RequestMapping("/men/top")
    public String mTop(Model model) throws Exception {
        List<ProductDTO> productDTOList = productService.getMTop();
        model.addAttribute("productDTOList", productDTOList);
        return "/product/men/top";
    }

    @RequestMapping("/men/pants")
    public String mPants(Model model) throws Exception {
        List<ProductDTO> productDTOList = productService.getMPants();
        model.addAttribute("productDTOList", productDTOList);
        return "/product/men/pants";
    }

    @RequestMapping("/men/accessories")
    public String mAccessories(Model model) throws Exception {
        List<ProductDTO> productDTOList = productService.getMAccessories();
        model.addAttribute("productDTOList", productDTOList);
        return "/product/men/accessories";
    }

    //신상품 카테고리
    @RequestMapping("/new")
    public String newProduct(Model model) throws Exception {
        List<ProductDTO> productDTOList = productService.getNewProduct();
        model.addAttribute("productDTOList", productDTOList);
        return "/product/new";
    }

    @RequestMapping("/new/outer")
    public String newOuter(Model model) throws Exception {
        List<ProductDTO> productDTOList = productService.getNewOuter();
        model.addAttribute("productDTOList", productDTOList);
        return "/product/new/outer";
    }

    @RequestMapping("/new/top")
    public String newTop(Model model) throws Exception {
        List<ProductDTO> productDTOList = productService.getNewTop();
        model.addAttribute("productDTOList", productDTOList);
        return "/product/new/pants";
    }

    @RequestMapping("/new/pants")
    public String newPants(Model model) throws Exception {
        List<ProductDTO> productDTOList = productService.getNewPants();
        model.addAttribute("productDTOList", productDTOList);
        return "/product/new/top";
    }

    @RequestMapping("/new/accessories")
    public String newAccessories(Model model) throws Exception {
        List<ProductDTO> productDTOList = productService.getNewAccessories();
        model.addAttribute("productDTOList", productDTOList);
        return "/product/new/accessories";
    }

    //장바구니에 상품 추가
    @ResponseBody
    @PostMapping("/addProduct")
    public String addProduct(@RequestParam Map<String, Object> map) throws Exception {
//        "count":cnt,
//        "id":id,
//        "pd_seq":pd_seq,
//        "optionList":integerArray2

        Integer count = Integer.parseInt(map.get("count").toString());
        String id = map.get("id").toString();
        Integer pd_seq = Integer.parseInt(map.get("pd_seq").toString());

        if (map.get("optionList") != null) {

            String[] test = map.get("optionList").toString().split(",");
            System.out.println("test = " + test);

            for (Integer i = 0; i < test.length; i++) {
                test[i] = map.get("optionList").toString().split(",")[i];
                System.out.println("test[i] = " + test[i]);
            }

            List<String> list = new ArrayList<>();
            System.out.println("list = " + list);
            Map<String, List<String>> optionList = new HashMap<>();

            for (Integer i = 0; i < test.length; i++) {
                Map<String, Object> options = new HashMap<>();
                String option_name = test[i].substring(0, test[i].indexOf("("));

                list.add(option_name);
                optionList.put("name", list);
            }
            System.out.println("optionList = " + optionList);
            //장바구니 insert 옵션 있을때
            productService.insertCart(id, count, pd_seq, optionList.toString());
        } else if (map.get("optionList") == null) {
            //옵션 없을때
            productService.insertCartWtOption(id, count, pd_seq);
        }

        return "success";
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
                stock = productService.getOptionCount(pd_seq, option);
                list[i] = stock;
            }
            stock = Arrays.stream(list).min().getAsInt();
        } else if (cartOption.size() == 1) {
            Integer pd_seq = productService.getPdSeq(cart_seq);// pd_seq 가져오기
            stock = productService.getPdStock(pd_seq);
        }
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

    @RequestMapping("/payInfo") //결제하기
    public String toPayInfo(Model model, String data, Integer price, String buyPdSeq) throws Exception { //data : id
        System.out.println("buyPdSeq = " + buyPdSeq);
        String[] arr = buyPdSeq.split(",");
        List<Integer> buyList = new ArrayList<>();
        // 구매할 cart_seq
        for (int i = 0; i < arr.length; i++) {
            buyList.add(Integer.parseInt(arr[i]));
        }
        List<Map<String, Object>> optionList = new ArrayList<>();
        JsonParser jsonParser = new JsonParser();
        JsonArray jsonArray = new JsonArray();
        JsonObject jsonObject = new JsonObject();
        List<String> list = new ArrayList<>();
        List<CartDTO> cartInfo = productService.getCartInfo(data);
        List<Map<String, Object>> cart = new ArrayList<>();
        Integer totalPrice = 0;  //상품 총 합계
        Integer totalSum = 0;  //상품 총 개수

        /*중복 제거*/

        for (Integer i = 0; i < buyList.size(); i++) {
            //count,pd_seq,options
            Integer pd_seq = productService.getPdSeq(buyList.get(i));
            ProductDTO productDTO = productService.getPdInfo(pd_seq);
            list = productService.getOptionCategory(buyList.get(i));
            //돌면서 상품 개수, 상품 가격 가져오고 더하기
            Integer count = productService.getPdCount(buyList.get(i));
            Integer pd_price = productService.getPdPrice(pd_seq);

            System.out.println("count = " + count);
            System.out.println("pd_seq = " + pd_seq);
            System.out.println("pd_price = " + pd_price);
            totalPrice += count * pd_price;
            totalSum += count;

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
                    System.out.println("list.size() = " + list.size());
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

        //배송 주소 관련
//        Map<String, Object> deliAddress = new HashMap<>();
//        String name = productService.getName(data);//이름
//        String phone = productService.getPhone(data);//폰
//        phone = phone.substring(0, 3) + "-" + phone.substring(3, 7) + "-" + phone.substring(7, 11);
//        String defaultAddress = productService.getDefaultAddress(data);
//        deliAddress.put("name", name);
//        deliAddress.put("phone", phone);
//        deliAddress.put("defaultAddress", defaultAddress);
//
        MemberDTO memberDTO = memberService.getMemInfo(data);

//        if (productService.getId(data) != 0) {
//            productService.updateBuyPd(data,totalSum,totalPrice);
//            //update
//        } else {
//            //insert
//            productService.insertBuyPd(data,totalSum,totalPrice);
//        }


        //배송지 불러오기 (별칭으로)
        List<DeliDTO> deliDTOList = productService.getDeliveryInfo(data);
        List<DeliDTO> deliveryInfo = productService.deliveryInfo(data);
        System.out.println("deliDTOList = " + deliDTOList);
        model.addAttribute("cart", cart);
        model.addAttribute("deliDTOList", deliDTOList);
        model.addAttribute("deliveryInfo", deliveryInfo);
//        model.addAttribute("deliAddress", deliAddress);
        model.addAttribute("price", price);
        model.addAttribute("memberDTO", memberDTO); //회원 정보
        model.addAttribute("totalPrice", totalPrice); // 최종 금액
        model.addAttribute("totalSum", totalSum); // 최종 수량
        return "/product/payInfo";
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

    @ResponseBody
    @RequestMapping("/getAdditionalAddr")
    public String getAdditionalAddr(String id) throws Exception {
        String additionalAddress1 = productService.getAdditionalAddress1(id);
        return additionalAddress1;
    }

    @ResponseBody
    @RequestMapping("/getAdditionalAddr2")
    public String getAdditionalAddr2(String id) throws Exception {
        String additionalAddress2 = productService.getAdditionalAddress2(id);
        return additionalAddress2;
    }

    @ResponseBody
    @RequestMapping("/getDefaultAddr")
    public String getDefaultAddr(String id) throws Exception {
        String defaultAddress = productService.getDefaultAddress(id);
        return defaultAddress;
    }

    //선택삭제 테스트
    @ResponseBody
    @RequestMapping("/cart/delCart")
    public String deleteItem(@RequestParam(value = "deleteCartSeq[]") List<Integer> deleteCartSeq) throws
            Exception {

        for (Integer i : deleteCartSeq) {
            productService.deleteItem(i);
        }
        return "success";
    }

    @RequestMapping("/paymentDetails")
    @Transactional
    public String paymentDetails(Model model, String id, Integer price, String carts, Integer seq, Integer pdTotalSum) throws Exception {

        //기본 배송지 수정
        productService.updDeliStatus(seq);
        productService.updStatus(seq);

        DeliDTO defaultAddr = productService.getDefaultAddr();

        //결제 테이블에 인서트
        Map<String, Object> param = new HashMap<>();
        param.put("id", id);
        param.put("price", price);
        param.put("deliSeq", defaultAddr.getSeq());
        param.put("pdTotalSum", pdTotalSum);
        System.out.println("\"tq\" = " + "tq");
        System.out.println("param = " + param);
        payService.insertPayInfo(param);
        Integer pay_seq = productService.currPaySeq();//현재 pay_seq
        Timestamp timestamp = productService.getPayDate(pay_seq);

        PayInfoDTO payInfoDTO = payService.getPayInfo(pay_seq);//결제 정보 가져오기

        JsonParser jsonParser = new JsonParser();
        JsonArray jsonArray = new JsonArray();
        JsonObject jsonObject = new JsonObject();
        List<String> list = new ArrayList<>();
        List<CartDTO> cartInfo = productService.getCart(id);  //결제 후 결제 내역에서 결제한것만 보여주기
        List<Map<String, Object>> cart = new ArrayList<>();
        Integer totalPrice = 0;  //상품 총 합계
        Integer totalSum = 0;  //상품 총 개수

        for (Integer i = 0; i < cartInfo.size(); i++) {

            System.out.println("cartInfo.get(i).getPd_seq() = " + cartInfo.get(i).getPd_seq());
            System.out.println("cartInfo.get(i).getCount() = " + cartInfo.get(i).getCount());
            System.out.println("cartInfo.get(i).getName() = " + cartInfo.get(i).getName());
            System.out.println("cartInfo.get(i).getPrice    () = " + cartInfo.get(i).getPrice());

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
                productService.insertPayPd(cartInfo.get(i).getPd_seq(), pay_seq);//결제한 상품
            }

            //판매 테이블에 인서트할 map (상품당 insert)
            Integer currPayPdSeq = productService.getCurrPayPdSeq();//현재 payPd_seq 가져오기
            PayInfoDTO payInfoDTO1 = productService.getPayInfo(pay_seq);
            System.out.println("payInfoDTO1 = " + payInfoDTO1.getCount());
            System.out.println("getPrice = " + payInfoDTO1.getPrice());
            salesParam.put("id", id); //id
            salesParam.put("pd_seq", cartInfo.get(i).getPd_seq()); //pd_seq
            salesParam.put("stock", payInfoDTO1.getCount()); //stock
            salesParam.put("productPrice",payInfoDTO1.getPrice());//price
            salesParam.put("salesDate", timestamp); //판매 시간
            salesParam.put("payPdSeq", currPayPdSeq); //payPd_seq
            productService.insertSales(salesParam);
        }

        //상품 수량, 옵션 수량 변경
        for (int i = 0; i < cartInfo.size(); i++) {
            Integer pd_seq = cartInfo.get(i).getPd_seq();
            Integer count = cartInfo.get(i).getCount();
            //상품 수량 변경
            productService.chgPdCount(pd_seq, count);
            //상품 수량이 0일때 status n으로
            Integer pdStock = productService.getPdStock(pd_seq);
            if (cartInfo.get(i).getOptions() != null) {
                Object object = jsonParser.parse(cartInfo.get(i).getOptions());
                JsonObject jsonObject1 = (JsonObject) object;
                JsonArray jsonArray1 = (JsonArray) jsonObject1.get("name");
                //상품 옵션 수량 변경
                if (pdStock <= 0) {
                    productService.updatePdStatus(pd_seq);
                }
                for (int k = 0; k < jsonArray1.size(); k++) {

                    String option = String.valueOf(jsonArray1.get(k)).replace("\"", "");

                    Map<String, Object> map = new HashMap<>();
                    map.put("pd_seq", pd_seq);
                    map.put("option", option);
                    map.put("count", count);
                    //상품 수량이 0일때 status n으로
                    OptionDTO optionStock = productService.getOptionStock(map);

                    if (optionStock.getStock() <= 0) {
                        //옵션 있고 옵션 수량이 0일때
                        productService.updateOptionStatus(optionStock.getOption_seq());
                        productService.chgOptionCount(map);
                        //재고가 음수일떄 0으로 update해주기
                        productService.updOptionStock(optionStock.getOption_seq(), optionStock.getPd_seq());
                    } else if (optionStock.getStock() > 0) {
                        //옵션 있고 옵션 수량 0이 아닐때
                        productService.chgOptionCount(map);
                    }
                }
            } else if (cartInfo.get(i).getOptions() == null) {
                //옵션 없을때
                if (pdStock <= 0) {
                    productService.updatePdStatus(pd_seq);
                }
            }
        }


        //장바구니 비우기
        productService.updCartStatus(id);
        model.addAttribute("cart", cart);
        model.addAttribute("totalPrice", totalPrice);
        model.addAttribute("price", price);
        model.addAttribute("totalSum", totalSum);
        model.addAttribute("defaultAddr", defaultAddr);
        model.addAttribute("payInfoDTO", payInfoDTO);
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
        //상품 인서트할때 category_seq 가져오기
        Integer category_seq = productService.getCategorySeq(category1, category2);

        Map<String, Object> param = new HashMap<>();
        param.put("name", name);
        param.put("description", description);
        param.put("price", price);
        param.put("stock", stock);
        param.put("img", sysname);
        param.put("category", category_seq);

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
    public String searchPd(String keyword, Model model) throws Exception {
        List<ProductDTO> productDTOList = productService.getProductsByKeyword(keyword);
        model.addAttribute("productDTOList", productDTOList);
        model.addAttribute("keyword", keyword);
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
    public String addDeli(String id) throws Exception {
        System.out.println("id = " + id);
        return "/product/popup";
        //회원 배송지 정보 가져오기
    }

    @RequestMapping("/updDeliInfo") //배송지 수정
    public String updDeliInfo(Model model, Integer seq) throws Exception {
        System.out.println("seq " + seq);
        DeliDTO deliDTO = productService.getSeqDeli(seq);
        model.addAttribute("deliDTO", deliDTO);
        return "/product/updPopup";
        //회원 배송지 정보 가져오기
    }

    @ResponseBody
    @PostMapping("/addDelivery")
    public String addDeli(@RequestParam Map<String, Object> map) throws Exception {

        System.out.println("map = " + map);
        String name = map.get("name").toString();
        String phone = map.get("phone").toString();
        String address = map.get("address").toString();
        String nickname = map.get("nickname").toString();
        String def = map.get("def").toString();
        String id = map.get("id").toString();
        String flag = "N";
        if (def.equals("true")) {
            flag = "Y";
        }
        System.out.println("flag = " + flag);
        Map<String, Object> param = new HashMap<>();
        param.put("name", name);
        param.put("phone", phone);
        param.put("address", address);
        param.put("nickname", nickname);
        param.put("flag", flag);
        param.put("id", id);
        productService.insertDeli(param);  //배송지 추가
        Integer currval = productService.getCurrval();//seq.currval
        if (flag.equals("Y")) { //flag Y일때 나머지 n으로 변경
            productService.updDeliStatus(currval);
        }
        return "success";
        //배달 정보에 insert
    }


    @ResponseBody
    @PostMapping("/getSeqDeli")
    public DeliDTO getSeqDeli(Integer seq) throws Exception {
        DeliDTO deliDTO = productService.getSeqDeli(seq);
        return deliDTO;
    }

    @ResponseBody
    @PostMapping("/updDelivery")
    public String updDelivery(@RequestParam Map<String, Object> map) throws Exception {
        System.out.println("map = " + map);
        String name = map.get("name").toString();
        String phone = map.get("phone").toString();
        String address = map.get("address").toString();
        String nickname = map.get("nickname").toString();
        String def = map.get("def").toString();
        String id = map.get("id").toString();
        Integer seq = Integer.parseInt(map.get("seq").toString());
        String flag = "N";
        if (def.equals("true")) {
            flag = "Y";
        }
        System.out.println("flag = " + flag);
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
        Map<String, Object> paging = productService.paging(cpage);
        Integer naviPerPage = 10;
        Integer start = cpage * naviPerPage - (naviPerPage - 1); //시작 글 번호
        Integer end = cpage * naviPerPage; // 끝 글 번호

        List<Map<String, Object>> historyList = new ArrayList<>();
        List<Map<String, Object>> payInfoDTOS = productService.getHistory(id, start, end);
        //옵션 정보 가져오기
        historyList = productService.pdOptionInfo(payInfoDTOS);
        model.addAttribute("historyList", historyList);
        model.addAttribute("paging", paging);
        return "/product/history";
    }

    @ResponseBody
    @PostMapping("/rePaging")
    public Map<String, Object> rePaging(Integer cpage, String id) throws Exception {
        List<Map<String, Object>> historyList = new ArrayList<>();
        Integer naviPerPage = 10;
        Integer start = cpage * naviPerPage - (naviPerPage - 1); //시작 글 번호
        Integer end = cpage * naviPerPage; // 끝 글 번호
        Map<String, Object> reMap = new HashMap<>();
        List<Map<String, Object>> payInfoDTOS = productService.getHistory(id, start, end);
        Map<String, Object> paging = productService.paging(cpage);
        reMap.put("startNavi", Integer.parseInt(paging.get("startNavi").toString()));
        reMap.put("endNavi", Integer.parseInt(paging.get("endNavi").toString()));
        reMap.put("needPrev", Boolean.parseBoolean(paging.get("needPrev").toString()));
        reMap.put("needNext", Boolean.parseBoolean(paging.get("needNext").toString()));
        reMap.put("paging", paging);
        reMap.put("cpage", Integer.parseInt(paging.get("cpage").toString()));

        //옵션 정보 가져오기
        historyList = productService.pdOptionInfo(payInfoDTOS);
        reMap.put("historyList", historyList);
        return reMap;
    }

    @ResponseBody
    @PostMapping("/rePagingPdList")
    public Map<String, Object> rePagingPdList(Integer cpage, String id) throws Exception {
        Integer naviPerPage = 10;
        Integer start = cpage * naviPerPage - (naviPerPage - 1); //시작 글 번호
        Integer end = cpage * naviPerPage; // 끝 글 번호
        Map<String, Object> reMap = new HashMap<>();
        List<ProductDTO> productDTOList = productService.getProducts(start, end);
        Map<String, Object> paging = productService.pagingPdList(cpage);
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
        Integer start = cpage * naviPerPage - (naviPerPage - 1); //시작 글 번호
        Integer end = cpage * naviPerPage; // 끝 글 번호
        List<SalesDTO> salesDTOS = productService.getSalesList(start, end);//판매 테이블에서 가져오기
        Map<String, Object> paging = productService.paging(cpage);
        for (SalesDTO salesDTO : salesDTOS) {
            PayProductDTO payProductDTO = productService.getDeliYN(salesDTO.getSales_seq()); // deliYN, CODE 가져오기
            Map<String, Object> reMap = new HashMap<>();
            reMap.put("startNavi", Integer.parseInt(paging.get("startNavi").toString()));
            reMap.put("endNavi", Integer.parseInt(paging.get("endNavi").toString()));
            reMap.put("needPrev", Boolean.parseBoolean(paging.get("needPrev").toString()));
            reMap.put("needNext", Boolean.parseBoolean(paging.get("needNext").toString()));
            reMap.put("paging", paging);
            reMap.put("cpage", Integer.parseInt(paging.get("cpage").toString()));
            reMap.put("deliYN", payProductDTO.getDeliYN());
            reMap.put("code", payProductDTO.getCode());
            reMap.put("salesDTOS", salesDTO);
            System.out.println("salesDTO.getPd_seq() = " + salesDTO.getPd_seq());
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
                    System.out.println("optName = " + optName);
                    System.out.println("optCategory = " + optCategory);
                    optionMap.put(optCategory, optName);
                    optionMapList.add(optionMap);
                }
                if (optionMapList.size() != 0) reMap.put("optionMapList", optionMapList);
            }
            historyList.add(reMap);
        }
        return historyList;
    }


    @ResponseBody
    @PostMapping("/insertDeliInfo")  //택배사 db 저장
    public String insertDeliInfo(@RequestBody List<List<Object>>list) throws Exception {
        System.out.println("data = " + list);
        for(int i = 0 ; i<list.size(); i++){
            for(int k = 0 ; k<list.get(i).size(); k++){
                Integer code = Integer.parseInt((String) list.get(i).get(0));
                String name = (String) list.get(i).get(1);
                System.out.println(code+":"+name);
                productService.insert(code,name);
            }

        }
        return "success";
    }

    @ResponseBody
    @PostMapping("/chgDeliveryStatus")  //payProduct deliYN, code 변경
    public String chgDeliveryStatus(@RequestParam Map<String,Object> data) throws Exception{
        System.out.println("DATA = " + data);
        //배송 상태 변경 (배송중으로)
        Integer sales_seq = Integer.parseInt(data.get("sales_seq").toString()); //sales_seq
        Integer courierCode = productService.getCourierCode(data.get("courier").toString()); //택배사 이름
        productService.updDeliveryStatus(sales_seq,courierCode); //sales table -> payPdSeq
        return "success";
    }
}