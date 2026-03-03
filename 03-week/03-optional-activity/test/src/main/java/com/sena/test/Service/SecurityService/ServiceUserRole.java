package com.sena.test.Service.SecurityService;

import com.sena.test.DTO.SecurityDTO.UserRoleDTORequest;
import com.sena.test.DTO.SecurityDTO.UserRoleDTOResponse;
import com.sena.test.Entity.Security.UserRole;
import com.sena.test.Entity.Security.User;
import com.sena.test.Entity.Security.Role;
import com.sena.test.IRepository.ISecurityRepository.IRepositoryUserRole;
import com.sena.test.IRepository.ISecurityRepository.IRepositoryUser;
import com.sena.test.IRepository.ISecurityRepository.IRepositoryRole;
import com.sena.test.IService.ISecurityService.IServiceUserRole;
import com.sena.test.Utils.UserRoleMapper;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class ServiceUserRole implements IServiceUserRole {

    private final IRepositoryUserRole repository;
    private final IRepositoryUser userRepository;
    private final IRepositoryRole roleRepository;

    public ServiceUserRole(IRepositoryUserRole repository,
                           IRepositoryUser userRepository,
                           IRepositoryRole roleRepository) {
        this.repository = repository;
        this.userRepository = userRepository;
        this.roleRepository = roleRepository;
    }

    @Override
    public UserRoleDTOResponse create(UserRoleDTORequest dto) {

        User user = userRepository.findById(dto.getUserId())
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));

        Role role = roleRepository.findById(dto.getRoleId())
                .orElseThrow(() -> new RuntimeException("Rol no encontrado"));

        UserRole userRole = new UserRole();
        userRole.setUser(user);
        userRole.setRole(role);

        return UserRoleMapper.toResponseDTO(repository.save(userRole));
    }

    @Override
    public UserRoleDTOResponse update(Long id, UserRoleDTORequest dto) {

        UserRole userRole = repository.findById(id)
                .orElseThrow(() -> new RuntimeException("UserRole no encontrado"));

        User user = userRepository.findById(dto.getUserId())
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));

        Role role = roleRepository.findById(dto.getRoleId())
                .orElseThrow(() -> new RuntimeException("Rol no encontrado"));

        userRole.setUser(user);
        userRole.setRole(role);

        return UserRoleMapper.toResponseDTO(repository.save(userRole));
    }

    @Override
    public UserRoleDTOResponse findById(Long id) {

        UserRole userRole = repository.findById(id)
                .orElseThrow(() -> new RuntimeException("UserRole no encontrado"));

        return UserRoleMapper.toResponseDTO(userRole);
    }

    @Override
    public void delete(Long id) {
        repository.deleteById(id);
    }

    @Override
    public List<UserRoleDTOResponse> findAll() {

        return repository.findAll()
                .stream()
                .map(UserRoleMapper::toResponseDTO)
                .collect(Collectors.toList());
    }
}