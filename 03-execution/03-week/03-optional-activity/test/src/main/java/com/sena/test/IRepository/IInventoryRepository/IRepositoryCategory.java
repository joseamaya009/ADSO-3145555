package com.sena.test.IRepository.IInventoryRepository;

import com.sena.test.Entity.Inventory.Category;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface IRepositoryCategory extends JpaRepository<Category, Long>{
    Optional<Category> findByName(String name);

    boolean existsByName(String name);
}
