package com.sena.test.Utils;

import com.sena.test.DTO.SecurityDTO.PersonDTORequest;
import com.sena.test.DTO.SecurityDTO.PersonDTOResponse;
import com.sena.test.Entity.Security.Person;

public class PersonMapper {

    private PersonMapper() {}

    public static Person toEntity(PersonDTORequest dto) {
        Person person = new Person();
        person.setFirstName(dto.getFirstName());
        person.setLastName(dto.getLastName());
        person.setEmail(dto.getEmail());
        person.setIdentity(dto.getIdentity());
        return person;
    }

    public static PersonDTOResponse toResponseDTO(Person person) {
        PersonDTOResponse dto = new PersonDTOResponse();
        dto.setId(person.getId());
        dto.setFirstName(person.getFirstName());
        dto.setLastName(person.getLastName());
        dto.setEmail(person.getEmail());
        return dto;
    }

    public static void updateEntity(Person person, PersonDTORequest dto) {
        person.setFirstName(dto.getFirstName());
        person.setLastName(dto.getLastName());
        person.setEmail(dto.getEmail());
        person.setIdentity(dto.getIdentity());
    }
}