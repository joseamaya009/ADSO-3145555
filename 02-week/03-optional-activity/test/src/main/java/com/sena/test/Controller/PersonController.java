package com.sena.test.Controller;
import com.sena.test.dto.PersonDto;
import com.sena.test.Entity.Person;
import com.sena.test.Service.IPersonService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/persons") //La clase maneja peticiones HTTP , Devuelve datos en formato JSON
public class PersonController {

    @Autowired
    private IPersonService service; //solo llama al servicio

    @PostMapping //Lo convierte automáticamente en PersonDto , Llama al service.create()
    public ResponseEntity<Person> create(@RequestBody PersonDto dto) {
        Person person = service.create(dto);
        return ResponseEntity.status(HttpStatus.CREATED).body(person); //El objeto guardado
    }

    @GetMapping //Lista de personas
    public ResponseEntity<List<Person>> findAll() {
        return ResponseEntity.ok(service.findAll());
    }

    @GetMapping("/{id}")
    public ResponseEntity<Person> findById(@PathVariable Long id) {
        Person person = service.findById(id);
        return ResponseEntity.ok(person);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Person> update(@PathVariable Long id, @RequestBody PersonDto dto) {
        Person updated = service.update(id, dto);
        return ResponseEntity.ok(updated);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        service.delete(id);
        return ResponseEntity.noContent().build();
    }
}