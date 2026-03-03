package com.sena.test.Controller.InventoryController;


import com.sena.test.IService.IInventoryService.IServiceCategory;
import com.sena.test.DTO.InventoryDTO.CategoryDTORequest;
import com.sena.test.DTO.InventoryDTO.CategoryDTOResponse;

import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/categories")
public class CategoryController {

    private final IServiceCategory service;

    public CategoryController(IServiceCategory service) {
        this.service = service;
    }

    @PostMapping
    public CategoryDTOResponse create(@RequestBody CategoryDTORequest dto) {
        return service.create(dto);
    }

    @GetMapping
    public List<CategoryDTOResponse> findAll() {
        return service.findAll();
    }

    @GetMapping("/{id}")
    public CategoryDTOResponse findById(@PathVariable Long id) {
        return service.findById(id);
    }

    @PutMapping("/{id}")
    public CategoryDTOResponse update(@PathVariable Long id, @RequestBody CategoryDTORequest dto) {
        return service.update(id, dto);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        service.delete(id);
    }
}