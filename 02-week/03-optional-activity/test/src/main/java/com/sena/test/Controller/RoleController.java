package com.sena.test.Controller;


import com.sena.test.Entity.Role;
import com.sena.test.Service.IRoleService;
import com.sena.test.dto.RoleDto;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/roles")
public class RoleController {

    @Autowired
    private IRoleService service;

    @PostMapping
    public ResponseEntity<Role> create(@RequestBody RoleDto dto) {
        Role role = service.create(dto);
        return ResponseEntity.status(HttpStatus.CREATED).body(role);
    }

    @GetMapping
    public ResponseEntity<List<Role>> findAll() {
        return ResponseEntity.ok(service.findAll());
    }

    @GetMapping("/{id}")
    public ResponseEntity<Role> findById(@PathVariable Long id) {
        return ResponseEntity.ok(service.findById(id));
    }

    @PutMapping("/{id}")
    public ResponseEntity<Role> update(@PathVariable Long id, @RequestBody RoleDto dto) {
        return ResponseEntity.ok(service.update(id, dto));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        service.delete(id);
        return ResponseEntity.noContent().build();
    }
}
