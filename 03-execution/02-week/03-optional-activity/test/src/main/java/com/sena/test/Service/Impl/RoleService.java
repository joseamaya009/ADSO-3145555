package com.sena.test.Service.Impl;

import com.sena.test.Entity.Role;
import com.sena.test.Repository.IRoleRepository;
import com.sena.test.Service.IRoleService;
import com.sena.test.dto.RoleDto;
import org.springframework.stereotype.Service;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;

@Service
public class RoleService implements IRoleService {

    @Autowired
    private IRoleRepository repository;

    @Override
    public Role create(RoleDto dto) {

        if (repository.findByName(dto.getName()).isPresent()) {
            throw new RuntimeException("El rol ya existe");
        }

        Role r = new Role();
        r.setName(dto.getName());

        return repository.save(r);
    }

    @Override
    public List<Role> findAll() {
        return repository.findAll();
    }

    @Override
    public Role findById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new RuntimeException("Rol no encontrado"));
    }

    @Override
    public Role update(Long id, RoleDto dto) {

        Role r = findById(id);
        r.setName(dto.getName());

        return repository.save(r);
    }

    @Override
    public void delete(Long id) {
        repository.deleteById(id);
    }
}
