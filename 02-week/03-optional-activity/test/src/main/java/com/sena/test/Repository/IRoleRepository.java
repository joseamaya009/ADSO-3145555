package com.sena.test.Repository;


import com.sena.test.Entity.Role;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface IRoleRepository extends JpaRepository<Role, Long> {

    Optional<Role> findByName(String name);
}