package com.sena.test.Controller.SecurityController;

import com.sena.test.DTO.SecurityDTO.UserRoleDTORequest;
import com.sena.test.DTO.SecurityDTO.UserRoleDTOResponse;
import com.sena.test.IService.ISecurityService.IServiceUserRole;

import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/user-roles")
public class UserRoleController {

    private final IServiceUserRole service;

    public UserRoleController(IServiceUserRole service) {
        this.service = service;
    }

    @PostMapping
    public UserRoleDTOResponse create(@RequestBody UserRoleDTORequest dto) {
        return service.create(dto);
    }

    @GetMapping
    public List<UserRoleDTOResponse> findAll() {
        return service.findAll();
    }

    @GetMapping("/{id}")
    public UserRoleDTOResponse findById(@PathVariable Long id) {
        return service.findById(id);
    }

    @PutMapping("/{id}")
    public UserRoleDTOResponse update(@PathVariable Long id, @RequestBody UserRoleDTORequest dto) {
        return service.update(id, dto);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        service.delete(id);
    }
}