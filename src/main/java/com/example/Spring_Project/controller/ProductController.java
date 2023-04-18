package com.example.Spring_Project.controller;

import com.example.Spring_Project.dto.OptionDTO;
import com.example.Spring_Project.dto.OptionListDTO;
import com.example.Spring_Project.dto.ProductDTO;
import com.example.Spring_Project.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/product")
public class ProductController {

    @Autowired
    private ProductService productService;

    //전체 상품
    @RequestMapping("/list")
    public String productList(Model model) throws Exception {
        List<ProductDTO> product = productService.getProducts();
        model.addAttribute("product", product);
        return "/member/productList";
    }

    //상품 디테일
    @RequestMapping("/detail")
    public String detail(Model model, Integer pd_seq) throws Exception {
        ProductDTO productDTO = productService.getProductDetail(pd_seq); //상품 상세 정보
        List<OptionDTO> optionDTO = productService.getOptions(pd_seq); //상품 옵션 정보
//      List<OptionDTO>optionByCategory = productService.optionByCategory(pd_seq); //상품 카테고리별 옵션 정보
        List<String> category = productService.getCategory(pd_seq);//옵션 카테고리

        Map<String, List<OptionListDTO>> optionList = new HashMap();
        for (Integer i = 0; i < category.size(); i++) {
            String cg = category.get(i);
            List<OptionListDTO> getOptionByGroup = productService.getOptionByGroup(category.get(i), pd_seq);  //카테고리별 optionList
            optionList.put(cg, getOptionByGroup);
        }
        model.addAttribute("productDTO", productDTO);
        model.addAttribute("optionDTO", optionDTO);
        model.addAttribute("category", category);
        model.addAttribute("optionList", optionList);
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

    //장바구니로 이동
    @RequestMapping("/cart")
    public String toCart() throws Exception {
        return "/product/cart";
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
        List<String> optionList = (List) map.get("optionList");
        List<String> changeOption = new ArrayList<>();

        Integer product_seq=0,option_seq=0;
        for (String str : optionList) {
            changeOption.add(str);
        }
//        Map<String,Object> param = new HashMap<>();

        for (Integer i = 0; i < optionList.size(); i++) { //옵션 수량 0일때
            option_seq=productService.getOptionStock(pd_seq, optionList.get(i));
            if(option_seq !=0){
                productService.updateOptionStatus(option_seq);
            }
        }
        product_seq=productService.getPdStock(pd_seq);
        if (product_seq != 0) { //상품 수량 0일때 상태 n으로
            productService.updatePdStatus(product_seq);
        }
        else{
            productService.insertCart(map); //장바구니 table insert
            for (Integer i = 0; i < optionList.size(); i++) {
                productService.minusOption(pd_seq, optionList.get(i));
            }//옵션들 -1
            productService.minusPd(pd_seq);//총 수량 -1
        }
        return "success";
    }

}
