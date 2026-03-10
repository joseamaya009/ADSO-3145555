package com.sena.test.IRepository.ISecurityRepository;

import com.sena.test.Entity.Security.Role;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface IRepositoryRole extends JpaRepository<Role, Long>{
        Optional<Role> findByName(String name);

}
