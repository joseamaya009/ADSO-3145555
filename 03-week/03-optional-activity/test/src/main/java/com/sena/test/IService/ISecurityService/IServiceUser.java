package com.sena.test.IService.ISecurityService;

import java.util.List;
import com.sena.test.DTO.SecurityDTO.UserDTORequest;
import com.sena.test.DTO.SecurityDTO.UserDTOResponse;

public interface IServiceUser {

    UserDTOResponse create(UserDTORequest dto);

    UserDTOResponse update(Long id, UserDTORequest dto);

    UserDTOResponse findById(Long id);

    List<UserDTOResponse> findAll();

    void delete(Long id);
}