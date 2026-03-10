package com.sena.test.Utils;

import com.sena.test.Entity.Inventory.Product;
import com.sena.test.Entity.Inventory.Category;
import com.sena.test.DTO.InventoryDTO.ProductDTORequest;
import com.sena.test.DTO.InventoryDTO.ProductDTOResponse;

public class ProductMapper {

    private ProductMapper() {}

    public static Product toEntity(ProductDTORequest dto, Category category) {
        Product product = new Product();
        product.setName(dto.getName());
        product.setPrice(dto.getPrice());
        product.setCategory(category);
        return product;
    }

    public static ProductDTOResponse toResponse(Product product) {
        ProductDTOResponse dto = new ProductDTOResponse();
        dto.setId(product.getId());
        dto.setName(product.getName());
        dto.setPrice(product.getPrice());

        if (product.getCategory() != null) {
            dto.setCategoryName(product.getCategory().getName());
        }

        return dto;
    }
}
