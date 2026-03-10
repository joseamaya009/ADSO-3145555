package com.sena.test.DTO.SecurityDTO;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter

public class UserDTORequest {
    private String username;
    private String password;
    private Long personId;
}
