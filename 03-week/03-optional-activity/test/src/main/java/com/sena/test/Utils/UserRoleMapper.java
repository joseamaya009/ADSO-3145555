package com.sena.test.Utils;

import com.sena.test.DTO.SecurityDTO.UserRoleDTORequest;
import com.sena.test.DTO.SecurityDTO.UserRoleDTOResponse;
import com.sena.test.Entity.Security.UserRole;
import com.sena.test.Entity.Security.User;
import com.sena.test.Entity.Security.Role;

public class UserRoleMapper {

    private UserRoleMapper() {}

    public static UserRole toEntity(UserRoleDTORequest dto, User user, Role role) {
        UserRole userRole = new UserRole();
        userRole.setUser(user);
        userRole.setRole(role);
        return userRole;
    }

    public static UserRoleDTOResponse toResponseDTO(UserRole userRole) {
        UserRoleDTOResponse dto = new UserRoleDTOResponse();
        dto.setId(userRole.getId());

        if (userRole.getUser() != null) {
            dto.setUserId(userRole.getUser().getId());
        }

        if (userRole.getRole() != null) {
            dto.setRoleId(userRole.getRole().getId());
        }

        return dto;
    }
}