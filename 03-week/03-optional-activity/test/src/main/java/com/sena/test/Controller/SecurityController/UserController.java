package com.sena.test.Controller.SecurityController;

import com.sena.test.DTO.SecurityDTO.UserDTORequest;
import com.sena.test.DTO.SecurityDTO.UserDTOResponse;
import com.sena.test.IService.ISecurityService.IServiceUser;

import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/users")
public class UserController {

    private final IServiceUser service;

    public UserController(IServiceUser service) {
        this.service = service;
    }

    @PostMapping
    public UserDTOResponse create(@RequestBody UserDTORequest dto) {
        return service.create(dto);
    }

    @GetMapping
    public List<UserDTOResponse> findAll() {
        return service.findAll();
    }

    @GetMapping("/{id}")
    public UserDTOResponse findById(@PathVariable Long id) {
        return service.findById(id);
    }

    @PutMapping("/{id}")
    public UserDTOResponse update(@PathVariable Long id, @RequestBody UserDTORequest dto) {
        return service.update(id, dto);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        service.delete(id);
    }
}