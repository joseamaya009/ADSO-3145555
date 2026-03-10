package com.sena.test.Service.InventoryService;


import com.sena.test.IService.IInventoryService.IServiceProduct;
import com.sena.test.IRepository.IInventoryRepository.IRepositoryProduct;
import com.sena.test.IRepository.IInventoryRepository.IRepositoryCategory;
import com.sena.test.DTO.InventoryDTO.ProductDTORequest;
import com.sena.test.DTO.InventoryDTO.ProductDTOResponse;
import com.sena.test.Entity.Inventory.Product;
import com.sena.test.Entity.Inventory.Category;
import com.sena.test.Utils.ProductMapper;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class ServiceProduct implements IServiceProduct {

    private final IRepositoryProduct productRepository;
    private final IRepositoryCategory categoryRepository;

    public ServiceProduct(IRepositoryProduct productRepository,
                          IRepositoryCategory categoryRepository) {
        this.productRepository = productRepository;
        this.categoryRepository = categoryRepository;
    }

    @Override
    public ProductDTOResponse create(ProductDTORequest dto) {

        if (productRepository.existsByName(dto.getName())) {
            throw new RuntimeException("Product already exists");
        }

        Category category = categoryRepository.findById(dto.getCategoryId())
                .orElseThrow(() -> new RuntimeException("Category not found"));

        Product product = ProductMapper.toEntity(dto, category);

        return ProductMapper.toResponse(productRepository.save(product));
    }

    @Override
    public ProductDTOResponse update(Long id, ProductDTORequest dto) {

        Product product = productRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Product not found"));

        Category category = categoryRepository.findById(dto.getCategoryId())
                .orElseThrow(() -> new RuntimeException("Category not found"));

        product.setName(dto.getName());
        product.setPrice(dto.getPrice());
        product.setCategory(category);

        return ProductMapper.toResponse(productRepository.save(product));
    }

    @Override
    public ProductDTOResponse findById(Long id) {
        Product product = productRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Product not found"));

        return ProductMapper.toResponse(product);
    }

    @Override
    public List<ProductDTOResponse> findAll() {
        return productRepository.findAll()
                .stream()
                .map(ProductMapper::toResponse)
                .collect(Collectors.toList());
    }

    @Override
    public void delete(Long id) {
        if (!productRepository.existsById(id)) {
            throw new RuntimeException("Product not found");
        }
        productRepository.deleteById(id);
    }
}
