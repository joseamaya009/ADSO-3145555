package com.sena.test.IRepository.ISecurityRepository;

import com.sena.test.Entity.Security.Person;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;



public interface IRepositoryPerson extends JpaRepository<Person, Long> {

    Optional<Person> findByEmail(String email);

    Optional<Person> findByIdentity(String identity);

}
