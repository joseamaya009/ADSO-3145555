package com.sena.test.Service.InventoryService;

import com.sena.test.IService.IInventoryService.IServiceCategory;
import com.sena.test.IRepository.IInventoryRepository.IRepositoryCategory;
import com.sena.test.DTO.InventoryDTO.CategoryDTORequest;
import com.sena.test.DTO.InventoryDTO.CategoryDTOResponse;
import com.sena.test.Entity.Inventory.Category;
import com.sena.test.Utils.CategoryMapper;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class ServiceCategory implements IServiceCategory {

    private final IRepositoryCategory categoryRepository;

    public ServiceCategory(IRepositoryCategory categoryRepository) {
        this.categoryRepository = categoryRepository;
    }

    @Override
    public CategoryDTOResponse create(CategoryDTORequest dto) {

        if (categoryRepository.existsByName(dto.getName())) {
            throw new RuntimeException("Category already exists");
        }

        Category category = CategoryMapper.toEntity(dto);

        return CategoryMapper.toResponse(categoryRepository.save(category));
    }

    @Override
    public CategoryDTOResponse update(Long id, CategoryDTORequest dto) {

        Category category = categoryRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Category not found"));

        category.setName(dto.getName());

        return CategoryMapper.toResponse(categoryRepository.save(category));
    }

    @Override
    public CategoryDTOResponse findById(Long id) {

        Category category = categoryRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Category not found"));

        return CategoryMapper.toResponse(category);
    }

    @Override
    public List<CategoryDTOResponse> findAll() {

        return categoryRepository.findAll()
                .stream()
                .map(CategoryMapper::toResponse)
                .collect(Collectors.toList());
    }

    @Override
    public void delete(Long id) {

        if (!categoryRepository.existsById(id)) {
            throw new RuntimeException("Category not found");
        }

        categoryRepository.deleteById(id);
    }
}