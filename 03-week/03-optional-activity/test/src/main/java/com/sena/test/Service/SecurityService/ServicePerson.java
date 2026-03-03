package com.sena.test.Service.SecurityService;
import com.sena.test.DTO.SecurityDTO.PersonDTORequest;
import com.sena.test.DTO.SecurityDTO.PersonDTOResponse;
import com.sena.test.Entity.Security.Person;
import com.sena.test.IRepository.ISecurityRepository.IRepositoryPerson;
import com.sena.test.IService.ISecurityService.IServicePerson;
import com.sena.test.Utils.PersonMapper;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ServicePerson implements IServicePerson {

    private final IRepositoryPerson repository;

    public ServicePerson(IRepositoryPerson repository) {
        this.repository = repository;
    }

    @Override
    public PersonDTOResponse create(PersonDTORequest dto) {

        validateUniqueFields(dto.getEmail(), dto.getIdentity(), null);

        Person person = PersonMapper.toEntity(dto);
        Person saved = repository.save(person);

        return PersonMapper.toResponseDTO(saved);
    }

    @Override
    public PersonDTOResponse update(Long id, PersonDTORequest dto) {

        Person person = repository.findById(id)
                .orElseThrow(() -> new RuntimeException("Persona no encontrada"));

        validateUniqueFields(dto.getEmail(), dto.getIdentity(), id);

        PersonMapper.updateEntity(person, dto);

        Person updated = repository.save(person);

        return PersonMapper.toResponseDTO(updated);
    }

    @Override
    public PersonDTOResponse findById(Long id) {

        Person person = repository.findById(id)
                .orElseThrow(() -> new RuntimeException("Persona no encontrada"));

        return PersonMapper.toResponseDTO(person);
    }

    @Override
    public List<PersonDTOResponse> findAll() {

        return repository.findAll()
                .stream()
                .map(PersonMapper::toResponseDTO)
                .toList();
    }

    @Override
    public void delete(Long id) {

        if (!repository.existsById(id)) {
            throw new RuntimeException("Persona no encontrada");
        }

        repository.deleteById(id);
    }

    private void validateUniqueFields(String email, String identity, Long id) {

        repository.findByEmail(email)
                .filter(p -> id == null || !p.getId().equals(id))
                .ifPresent(p -> {
                    throw new RuntimeException("El email ya está en uso");
                });

        repository.findByIdentity(identity)
                .filter(p -> id == null || !p.getId().equals(id))
                .ifPresent(p -> {
                    throw new RuntimeException("La identidad ya está en uso");
                });
    }
}