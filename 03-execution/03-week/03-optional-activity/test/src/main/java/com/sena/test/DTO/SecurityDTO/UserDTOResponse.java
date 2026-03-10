package com.sena.test.DTO.SecurityDTO;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter

public class UserDTOResponse {
    private Long id;

    private Long personId;
    private String personFirstName;
    private String personLastName;
}
