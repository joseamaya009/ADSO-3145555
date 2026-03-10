package com.sena.test.IService.IInventoryService;

//import com.sena.test.Entity.Inventory.Product;
import com.sena.test.DTO.InventoryDTO.ProductDTOResponse;
import com.sena.test.DTO.InventoryDTO.ProductDTORequest;

import java.util.List;

public interface IServiceProduct {
    ProductDTOResponse create (ProductDTORequest dto);
    ProductDTOResponse update (Long id, ProductDTORequest dto);
    ProductDTOResponse findById(Long id);
    List<ProductDTOResponse> findAll();
    void delete (Long id);
}
