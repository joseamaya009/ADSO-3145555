package com.sena.test.Repository;


import com.sena.test.Entity.Person;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface IPersonRepository extends JpaRepository<Person, Long> { //Long → Tipo de dato del ID

    Optional<Person> findByEmail(String email);
        //Spring Data JPA genera automáticamente la consulta SQL solo por el nombre del método.

    Optional<Person> findByIdentidad(String identidad);
}