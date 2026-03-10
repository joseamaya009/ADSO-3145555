package com.sena.test.Controller;


import com.sena.test.Entity.UserRole;
import com.sena.test.Service.IUserRoleService;
import com.sena.test.dto.UserRoleDto;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/user-roles")
public class UserRoleController {

    @Autowired
    private IUserRoleService service;

    @PostMapping
    public ResponseEntity<UserRole> create(@RequestBody UserRoleDto dto) {
        UserRole userRole = service.create(dto);
        return ResponseEntity.status(HttpStatus.CREATED).body(userRole);
    }

    @GetMapping
    public ResponseEntity<List<UserRole>> findAll() {
        return ResponseEntity.ok(service.findAll());
    }

    @GetMapping("/{id}")
    public ResponseEntity<UserRole> findById(@PathVariable Long id) {
        return ResponseEntity.ok(service.findById(id));
    }

    @PutMapping("/{id}")
    public ResponseEntity<UserRole> update(@PathVariable Long id, @RequestBody UserRoleDto dto) {
        return ResponseEntity.ok(service.update(id, dto));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        service.delete(id);
        return ResponseEntity.noContent().build();
    }
}