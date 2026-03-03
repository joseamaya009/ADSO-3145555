package com.sena.test.IRepository.IInventoryRepository;

import com.sena.test.Entity.Inventory.Product;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.List;

public interface IRepositoryProduct extends JpaRepository<Product, Long>{
    Optional<Product> findByName(String name);

    boolean existsByName(String name);

    List<Product> findByCategoryId(Long categoryId);
}
