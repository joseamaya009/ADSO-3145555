package com.sena.test.Service;

import com.sena.test.Entity.Person;
import com.sena.test.dto.PersonDto;

import java.util.List;

public interface IPersonService {

    Person create(PersonDto dto);

    List<Person> findAll();

    Person findById(Long id);

    Person update(Long id, PersonDto dto);

    void delete(Long id);
}