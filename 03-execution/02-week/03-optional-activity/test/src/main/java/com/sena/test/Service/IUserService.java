package com.sena.test.Service;

import com.sena.test.Entity.User;
import com.sena.test.dto.UserDto;

import java.util.List;

public interface IUserService {

    User create(UserDto dto);

    List<User> findAll();

    User findById(Long id);

    User update(Long id, UserDto dto);

    void delete(Long id);
}