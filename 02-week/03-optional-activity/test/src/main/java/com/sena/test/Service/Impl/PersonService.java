package com.sena.test.Service.Impl;

import com.sena.test.Entity.Person;
import com.sena.test.Repository.IPersonRepository;
import com.sena.test.Service.IPersonService;
import com.sena.test.dto.PersonDto;

import org.springframework.stereotype.Service;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;

@Service //Esta clase pertenece a la capa de negocio.
public class PersonService implements IPersonService { //PersonService está obligada a implementar todos los métodos definidos en la interfaz.

    @Autowired
    private IPersonRepository repository; //Aquí estámos conectando la capa Service con la capa Repository.

    @Override
    public Person create(PersonDto dto) {

        if (repository.findByEmail(dto.getEmail()).isPresent()) { //No permitir correos repetidos
            throw new RuntimeException("El correo ya está registrado.");
        }

        if (repository.findByIdentidad(dto.getIdentidad()).isPresent()) { //No permitir identidad duplicada
            throw new RuntimeException("La identidad ya está registrada.");
        }

        Person p = new Person();
        p.setFirstName(dto.getFirstName());
        p.setLastName(dto.getLastName());
        p.setEmail(dto.getEmail());
        p.setPassword(dto.getPassword());
        p.setIdentidad(dto.getIdentidad());

        return repository.save(p); //si tiene ID actualiza , si no retorna
    }

    @Override
    public List<Person> findAll() { //Devuelve todas las personas.
        return repository.findAll();
    }

    @Override
    public Person findById(Long id) { //Evita NullPointerException
        return repository.findById(id)
                .orElseThrow(() -> new RuntimeException("Persona no encontrada"));
    }

    @Override
    public Person update(Long id, PersonDto dto) {

        Person p = findById(id);

        p.setFirstName(dto.getFirstName());
        p.setLastName(dto.getLastName());
        p.setEmail(dto.getEmail());
        p.setPassword(dto.getPassword());
        p.setIdentidad(dto.getIdentidad());

        return repository.save(p);
    }

    @Override
    public void delete(Long id) {
        repository.deleteById(id);
    }
}