package com.sena.test.Service;


import com.sena.test.Entity.Role;
import com.sena.test.dto.RoleDto;

import java.util.List;

public interface IRoleService {

    Role create(RoleDto dto);

    List<Role> findAll();

    Role findById(Long id);

    Role update(Long id, RoleDto dto);

    void delete(Long id);
}