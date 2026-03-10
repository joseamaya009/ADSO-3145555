package com.sena.test.dto;


import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UserDto {
    private Long personId;   // de qué persona saldrá el usuario
    private String username; // identidad o correo
    private String password; // normalmente será el de person
}
