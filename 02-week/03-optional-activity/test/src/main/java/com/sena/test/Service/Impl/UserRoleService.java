package com.sena.test.Service.Impl;


import com.sena.test.Entity.User;
import com.sena.test.Entity.Role;
import com.sena.test.Entity.UserRole;
import com.sena.test.Repository.IUserRepository;
import com.sena.test.Repository.IRoleRepository;
import com.sena.test.Repository.IUserRoleRepository;
import com.sena.test.Service.IUserRoleService;
import com.sena.test.dto.UserRoleDto;

import org.springframework.stereotype.Service;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;

@Service
public class UserRoleService implements IUserRoleService {

    @Autowired
    private IUserRoleRepository repository;

    @Autowired
    private IUserRepository userRepository;

    @Autowired
    private IRoleRepository roleRepository;

    @Override
    public UserRole create(UserRoleDto dto) {

        User user = userRepository.findById(dto.getUserId())
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));

        Role role = roleRepository.findById(dto.getRoleId())
                .orElseThrow(() -> new RuntimeException("Rol no encontrado"));

        UserRole ur = new UserRole();
        ur.setUser(user);
        ur.setRole(role);

        return repository.save(ur);
    }

    @Override
    public List<UserRole> findAll() {
        return repository.findAll();
    }

    @Override
    public UserRole findById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new RuntimeException("UserRole no encontrado"));
    }

    @Override
    public UserRole update(Long id, UserRoleDto dto) {

        UserRole ur = findById(id);

        User user = userRepository.findById(dto.getUserId())
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));

        Role role = roleRepository.findById(dto.getRoleId())
                .orElseThrow(() -> new RuntimeException("Rol no encontrado"));

        ur.setUser(user);
        ur.setRole(role);

        return repository.save(ur);
    }

    @Override
    public void delete(Long id) {
        repository.deleteById(id);
    }
}