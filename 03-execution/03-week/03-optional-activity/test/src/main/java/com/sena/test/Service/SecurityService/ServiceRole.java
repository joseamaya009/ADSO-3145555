package com.sena.test.Service.SecurityService;

import com.sena.test.DTO.SecurityDTO.RoleDTORequest;
import com.sena.test.DTO.SecurityDTO.RoleDTOResponse;
import com.sena.test.Entity.Security.Role;
import com.sena.test.IRepository.ISecurityRepository.IRepositoryRole;
import com.sena.test.IService.ISecurityService.IServiceRole;
import com.sena.test.Utils.RoleMapper;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class ServiceRole implements IServiceRole {

    private final IRepositoryRole repository;

    public ServiceRole(IRepositoryRole repository) {
        this.repository = repository;
    }

    @Override
    public RoleDTOResponse create(RoleDTORequest dto) {
        Role role = RoleMapper.toEntity(dto);
        return RoleMapper.toResponseDTO(repository.save(role));
    }

    @Override
    public RoleDTOResponse update(Long id, RoleDTORequest dto) {

        Role role = repository.findById(id)
                .orElseThrow(() -> new RuntimeException("Rol no encontrado"));

        role.setName(dto.getName());

        return RoleMapper.toResponseDTO(repository.save(role));
    }

    @Override
    public RoleDTOResponse findById(Long id) {
        Role role = repository.findById(id)
                .orElseThrow(() -> new RuntimeException("Rol no encontrado"));

        return RoleMapper.toResponseDTO(role);
    }

    @Override
    public List<RoleDTOResponse> findAll() {
        return repository.findAll()
                .stream()
                .map(RoleMapper::toResponseDTO)
                .collect(Collectors.toList());
    }

    @Override
    public void delete(Long id) {
        repository.deleteById(id);
    }
}