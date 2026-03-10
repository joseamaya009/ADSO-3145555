package com.sena.test.IRepository.ISecurityRepository;

import com.sena.test.Entity.Security.User;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;
public interface IRepositoryUser extends JpaRepository<User, Long>{
    Optional<User> findByPersonId(Long personId);

}
