package com.sena.test.Utils;

import com.sena.test.Entity.Inventory.Category;
import com.sena.test.DTO.InventoryDTO.CategoryDTORequest;
import com.sena.test.DTO.InventoryDTO.CategoryDTOResponse;

public class CategoryMapper {

    private CategoryMapper() {}

    public static Category toEntity(CategoryDTORequest dto) {
        Category category = new Category();
        category.setName(dto.getName());
        return category;
    }

    public static CategoryDTOResponse toResponse(Category category) {
        CategoryDTOResponse dto = new CategoryDTOResponse();
        dto.setId(category.getId());
        dto.setName(category.getName());
        return dto;
    }
}
