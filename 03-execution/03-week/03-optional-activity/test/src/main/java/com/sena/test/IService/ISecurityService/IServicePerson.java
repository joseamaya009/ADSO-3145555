package com.sena.test.IService.ISecurityService;

//import com.sena.test.Entity.Security.Person;
import com.sena.test.DTO.SecurityDTO.PersonDTOResponse;
import com.sena.test.DTO.SecurityDTO.PersonDTORequest;


import java.util.List;

public interface IServicePerson {
//Entrada → PersonDTORequest
//Salida → PersonDTOResponse
PersonDTOResponse create(PersonDTORequest dto);
//Recibe DTO de entrada → devuelve DTO de salida.
PersonDTOResponse update(Long id, PersonDTORequest dto);
//Actualiza usando el ID + datos del DTO.
PersonDTOResponse findById(Long id);
//Devuelve un solo DTO de salida.
List<PersonDTOResponse> findAll();
//Devuelve una lista de DTO de salida.
void delete (Long id);
//Elimina una persona.
}
