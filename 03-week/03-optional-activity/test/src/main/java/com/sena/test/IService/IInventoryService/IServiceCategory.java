package com.sena.test.IService.IInventoryService;

//import com.sena.test.Entity.Inventory.Category;
import com.sena.test.DTO.InventoryDTO.CategoryDTOResponse;
import com.sena.test.DTO.InventoryDTO.CategoryDTORequest;

import java.util.List;

public interface IServiceCategory {
    CategoryDTOResponse create (CategoryDTORequest dto);
    CategoryDTOResponse update (Long id, CategoryDTORequest dto);
    CategoryDTOResponse findById(Long id);
    List<CategoryDTOResponse> findAll();
    void delete (Long id);
    
}
