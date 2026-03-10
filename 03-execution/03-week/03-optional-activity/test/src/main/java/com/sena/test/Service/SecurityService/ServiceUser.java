package com.sena.test.Service.SecurityService;

import com.sena.test.Entity.Security.User;
import com.sena.test.Entity.Security.Person;
import com.sena.test.DTO.SecurityDTO.UserDTOResponse;
import com.sena.test.DTO.SecurityDTO.UserDTORequest;
import com.sena.test.IRepository.ISecurityRepository.IRepositoryUser;
import com.sena.test.IRepository.ISecurityRepository.IRepositoryPerson;
import com.sena.test.IService.ISecurityService.IServiceUser;
import com.sena.test.Utils.UserMapper;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class ServiceUser implements IServiceUser {

    private final IRepositoryUser repository;
    private final IRepositoryPerson personRepository;

    public ServiceUser(IRepositoryUser repository,
                       IRepositoryPerson personRepository) {
        this.repository = repository;
        this.personRepository = personRepository;
    }

    @Override
    public UserDTOResponse create(UserDTORequest dto) {

        Person person = personRepository.findById(dto.getPersonId())
                .orElseThrow(() -> new RuntimeException("Persona no encontrada"));

        repository.findByPersonId(person.getId())
                .ifPresent(u -> {
                    throw new RuntimeException("Esta persona ya tiene un usuario");
                });

        User user = new User();
        user.setPassword(dto.getPassword());
        user.setUsername(dto.getUsername()); // 🔹 SETEAR USERNAME
        user.setPerson(person);

        return UserMapper.toResponseDTO(repository.save(user));
    }

    @Override
    public UserDTOResponse update(Long id, UserDTORequest dto) {

        User user = repository.findById(id)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));

        Person person = personRepository.findById(dto.getPersonId())
                .orElseThrow(() -> new RuntimeException("Persona no encontrada"));

        repository.findByPersonId(person.getId())
                .ifPresent(existingUser -> {
                    if (!existingUser.getId().equals(id)) {
                        throw new RuntimeException("Esta persona ya está asignada a otro usuario");
                    }
                });

        user.setPassword(dto.getPassword());
        user.setUsername(dto.getUsername()); // 🔹 SETEAR USERNAME
        user.setPerson(person);

        return UserMapper.toResponseDTO(repository.save(user));
    }

    @Override
    public UserDTOResponse findById(Long id) {

        User user = repository.findById(id)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));

        return UserMapper.toResponseDTO(user);
    }

    @Override
    public List<UserDTOResponse> findAll() {

        return repository.findAll()
                .stream()
                .map(UserMapper::toResponseDTO)
                .collect(Collectors.toList());
    }

    @Override
    public void delete(Long id) {

        if (!repository.existsById(id)) {
            throw new RuntimeException("Usuario no encontrado");
        }

        repository.deleteById(id);
    }
}