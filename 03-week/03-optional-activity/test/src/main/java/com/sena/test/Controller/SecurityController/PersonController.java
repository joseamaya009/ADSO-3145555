package com.sena.test.Controller.SecurityController;

import com.sena.test.DTO.SecurityDTO.PersonDTORequest;
import com.sena.test.DTO.SecurityDTO.PersonDTOResponse;
import com.sena.test.IService.ISecurityService.IServicePerson;

import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/persons")
public class PersonController {

    private final IServicePerson service;

    public PersonController(IServicePerson service) {
        this.service = service;
    }

    @PostMapping
    public PersonDTOResponse create(@RequestBody PersonDTORequest dto) {
        return service.create(dto);
    }

    @GetMapping
    public List<PersonDTOResponse> findAll() {
        return service.findAll();
    }

    @GetMapping("/{id}")
    public PersonDTOResponse findById(@PathVariable Long id) {
        return service.findById(id);
    }

    @PutMapping("/{id}")
    public PersonDTOResponse update(@PathVariable Long id, @RequestBody PersonDTORequest dto) {
        return service.update(id, dto);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        service.delete(id);
    }
}
