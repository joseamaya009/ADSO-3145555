package com.sena.test.Service;

import com.sena.test.Entity.UserRole;
import com.sena.test.dto.UserRoleDto;

import java.util.List;

public interface IUserRoleService {

    UserRole create(UserRoleDto dto);

    List<UserRole> findAll();

    UserRole findById(Long id);

    UserRole update(Long id, UserRoleDto dto);

    void delete(Long id);
}
