package com.sena.test.Controller.SecurityController;


import com.sena.test.DTO.SecurityDTO.RoleDTORequest;
import com.sena.test.DTO.SecurityDTO.RoleDTOResponse;
import com.sena.test.IService.ISecurityService.IServiceRole;

import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/roles")
public class RoleController {

    private final IServiceRole service;

    public RoleController(IServiceRole service) {
        this.service = service;
    }

    @PostMapping
    public RoleDTOResponse create(@RequestBody RoleDTORequest dto) {
        return service.create(dto);
    }

    @GetMapping
    public List<RoleDTOResponse> findAll() {
        return service.findAll();
    }

    @GetMapping("/{id}")
    public RoleDTOResponse findById(@PathVariable Long id) {
        return service.findById(id);
    }

    @PutMapping("/{id}")
    public RoleDTOResponse update(@PathVariable Long id, @RequestBody RoleDTORequest dto) {
        return service.update(id, dto);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        service.delete(id);
    }
}