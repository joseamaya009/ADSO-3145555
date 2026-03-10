package com.sena.test.IRepository.ISecurityRepository;

import com.sena.test.Entity.Security.UserRole;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface IRepositoryUserRole extends JpaRepository<UserRole, Long>{
    List<UserRole> findByUserId(Long userId);

    List<UserRole> findByRoleId(Long roleId);
}
