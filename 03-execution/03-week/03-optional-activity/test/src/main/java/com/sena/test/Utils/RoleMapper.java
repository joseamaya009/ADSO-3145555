package com.sena.test.Utils;

import com.sena.test.DTO.SecurityDTO.RoleDTORequest;
import com.sena.test.DTO.SecurityDTO.RoleDTOResponse;
import com.sena.test.Entity.Security.Role;

public class RoleMapper {

    private RoleMapper() {}

    public static Role toEntity(RoleDTORequest dto) {
        Role role = new Role();
        role.setName(dto.getName());
        return role;
    }

    public static RoleDTOResponse toResponseDTO(Role role) {
        RoleDTOResponse dto = new RoleDTOResponse();
        dto.setId(role.getId());
        dto.setName(role.getName());
        return dto;
    }
}