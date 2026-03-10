package com.sena.test.Utils;

import com.sena.test.Entity.Security.User;
import com.sena.test.Entity.Security.Person;
import com.sena.test.DTO.SecurityDTO.UserDTORequest;
import com.sena.test.DTO.SecurityDTO.UserDTOResponse;

public class UserMapper {

    private UserMapper() {}

    public static User toEntity(UserDTORequest dto, Person person) {
        User user = new User();
        user.setUsername(dto.getUsername());
        user.setPassword(dto.getPassword());
        user.setPerson(person);
        return user;
    }

    public static UserDTOResponse toResponseDTO(User user) {
        if (user == null) return null;

        UserDTOResponse dto = new UserDTOResponse();
        dto.setId(user.getId());

        if (user.getPerson() != null) {
            dto.setPersonId(user.getPerson().getId());
            dto.setPersonFirstName(user.getPerson().getFirstName());
            dto.setPersonLastName(user.getPerson().getLastName());
        }

        return dto;
    }
}