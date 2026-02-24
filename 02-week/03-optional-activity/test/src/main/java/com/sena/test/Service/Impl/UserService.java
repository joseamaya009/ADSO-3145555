package com.sena.test.Service.Impl;
import com.sena.test.Entity.Person;
import com.sena.test.Entity.User;
import com.sena.test.Repository.IUserRepository;
import com.sena.test.Repository.IPersonRepository;
import com.sena.test.Service.IUserService;
import com.sena.test.dto.UserDto;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserService implements IUserService {

    @Autowired
    private IUserRepository userRepository;

    @Autowired
    private IPersonRepository personRepository;

    @Override
    public User create(UserDto dto) {

        // Validar username único
        if (userRepository.findByUsername(dto.getUsername()).isPresent()) {
            throw new RuntimeException("El usuario ya existe.");
        }

        // Validar que la persona exista
        Person person = personRepository.findById(dto.getPersonId())
                .orElseThrow(() -> new RuntimeException("Persona no encontrada."));

        User user = new User();
        user.setPerson(person);
        user.setUsername(dto.getUsername());
        user.setPassword(dto.getPassword());

        return userRepository.save(user);
    }

    @Override
    public List<User> findAll() {
        return userRepository.findAll();
    }

    @Override
    public User findById(Long id) {
        return userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));
    }

    @Override
    public User update(Long id, UserDto dto) {
        User u = findById(id);

        u.setUsername(dto.getUsername());
        u.setPassword(dto.getPassword());

        return userRepository.save(u);
    }

    @Override
    public void delete(Long id) {
        userRepository.deleteById(id);
    }
}