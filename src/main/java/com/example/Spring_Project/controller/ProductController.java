package com.example.Spring_Project.controller;

import com.example.Spring_Project.dto.OptionDTO;
import com.example.Spring_Project.dto.OptionListDTO;
import com.example.Spring_Project.dto.ProductDTO;
import com.example.Spring_Project.service.ProductService;
import org.dom4j.rule.Mode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

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
    public String productList(Model model) throws Exception{
        List<ProductDTO>product = productService.getProducts();
        model.addAttribute("product",product);
        return "/member/productList";
    }

    //상품 디테일
    @RequestMapping("/detail")
    public String detail(Model model, Integer pd_seq) throws Exception{
        ProductDTO productDTO = productService.getProductDetail(pd_seq); //상품 상세 정보
        List<OptionDTO>optionDTO = productService.getOptions(pd_seq); //상품 옵션 정보
//      List<OptionDTO>optionByCategory = productService.optionByCategory(pd_seq); //상품 카테고리별 옵션 정보
        List<String>category= productService.getCategory(pd_seq);//옵션 카테고리

        Map<String,List<OptionListDTO>>optionList = new HashMap();
        for(Integer i = 0; i<category.size(); i++){
            String cg=category.get(i);
            List<OptionListDTO> getOptionByGroup = productService.getOptionByGroup(category.get(i),pd_seq);  //카테고리별 optionList
            optionList.put(cg,getOptionByGroup);
        }
        model.addAttribute("productDTO",productDTO);
        model.addAttribute("optionDTO",optionDTO);
        model.addAttribute("category",category);
        model.addAttribute("optionList",optionList);
        return "/product/detail";
    }


    //여성 카테고리
    @RequestMapping("/women")
    public String wProduct(Model model) throws Exception{
        List<ProductDTO>productDTOList = productService.getWProduct();
        model.addAttribute("productDTOList",productDTOList);
        return "/product/women";
    }

    @RequestMapping("/women/outer")
    public String wOuter(Model model) throws Exception{
        List<ProductDTO>productDTOList=productService.getWOuter();
        model.addAttribute("productDTOList",productDTOList);
        return "/product/women/outer";
    }
    @RequestMapping("/women/top")
    public String wTop(Model model) throws Exception{
        List<ProductDTO>productDTOList=productService.getWTop();
        model.addAttribute("productDTOList",productDTOList);
        return "/product/women/top";
    }
    @RequestMapping("/women/pants")
    public String wPants(Model model) throws Exception{
        List<ProductDTO>productDTOList=productService.getWPants();
        model.addAttribute("productDTOList",productDTOList);
        return "/product/women/pants";
    }
    @RequestMapping("/women/accessories")
    public String wAccessories(Model model) throws Exception{
        List<ProductDTO>productDTOList=productService.getWAccessories();
        model.addAttribute("productDTOList",productDTOList);
        return "/product/women/accessories";
    }


    //남성 카테고리
    @RequestMapping("/men")
    public String mProduct(Model model) throws Exception{
        List<ProductDTO>productDTOList = productService.getMProduct();
        model.addAttribute("productDTOList",productDTOList);
        return "/product/men";
    }

    @RequestMapping("/men/outer")
    public String mOuter(Model model) throws Exception{
        List<ProductDTO>productDTOList = productService.getMOuter();
        model.addAttribute("productDTOList",productDTOList);
        return "/product/men/outer";
    }
    @RequestMapping("/men/top")
    public String mTop(Model model) throws Exception{
        List<ProductDTO>productDTOList = productService.getMTop();
        model.addAttribute("productDTOList",productDTOList);
        return "/product/men/top";
    }
    @RequestMapping("/men/pants")
    public String mPants(Model model) throws Exception{
        List<ProductDTO>productDTOList = productService.getMPants();
        model.addAttribute("productDTOList",productDTOList);
        return "/product/men/pants";
    }
    @RequestMapping("/men/accessories")
    public String mAccessories(Model model) throws Exception{
        List<ProductDTO>productDTOList = productService.getMAccessories();
        model.addAttribute("productDTOList",productDTOList);
        return "/product/men/accessories";
    }

    //신상품 카테고리
    @RequestMapping("/new")
    public String newProduct(Model model) throws Exception{
        List<ProductDTO>productDTOList = productService.getNewProduct();
        model.addAttribute("productDTOList",productDTOList);
        return "/product/new";
    }

    @RequestMapping("/new/outer")
    public String newOuter(Model model) throws Exception{
            List<ProductDTO>productDTOList = productService.getNewOuter();
            model.addAttribute("productDTOList",productDTOList);
            return "/product/new/outer";
    }
    @RequestMapping("/new/top")
    public String newTop(Model model) throws Exception{
        List<ProductDTO>productDTOList = productService.getNewTop();
        model.addAttribute("productDTOList",productDTOList);
        return "/product/new/pants";
    }
    @RequestMapping("/new/pants")
    public String newPants(Model model) throws Exception{
        List<ProductDTO>productDTOList = productService.getNewPants();
        model.addAttribute("productDTOList",productDTOList);
        return "/product/new/top";
    }
    @RequestMapping("/new/accessories")
    public String newAccessories(Model model) throws Exception{
        List<ProductDTO>productDTOList = productService.getNewAccessories();
        model.addAttribute("productDTOList",productDTOList);
        return "/product/new/accessories";
    }

}
