package com.sena.test.IService.ISecurityService;

//import com.sena.test.Entity.Security.Role;
import com.sena.test.DTO.SecurityDTO.RoleDTOResponse;
import com.sena.test.DTO.SecurityDTO.RoleDTORequest;


import java.util.List;

public interface IServiceRole {
    RoleDTOResponse create (RoleDTORequest dto);
    RoleDTOResponse update (Long id, RoleDTORequest dto);
    RoleDTOResponse findById(Long id);
    List<RoleDTOResponse> findAll();
    void delete (Long id);
}
