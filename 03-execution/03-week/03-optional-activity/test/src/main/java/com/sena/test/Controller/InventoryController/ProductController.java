package com.sena.test.Controller.InventoryController;

import com.sena.test.IService.IInventoryService.IServiceProduct;
import com.sena.test.DTO.InventoryDTO.ProductDTORequest;
import com.sena.test.DTO.InventoryDTO.ProductDTOResponse;

import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/products")
public class ProductController {

    private final IServiceProduct service;

    public ProductController(IServiceProduct service) {
        this.service = service;
    }

    @PostMapping
    public ProductDTOResponse create(@RequestBody ProductDTORequest dto) {
        return service.create(dto);
    }

    @GetMapping
    public List<ProductDTOResponse> findAll() {
        return service.findAll();
    }

    @GetMapping("/{id}")
    public ProductDTOResponse findById(@PathVariable Long id) {
        return service.findById(id);
    }

    @PutMapping("/{id}")
    public ProductDTOResponse update(@PathVariable Long id, @RequestBody ProductDTORequest dto) {
        return service.update(id, dto);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        service.delete(id);
    }
}