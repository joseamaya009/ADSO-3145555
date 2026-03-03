package com.sena.test.Service.BillService;


import com.sena.test.DTO.BillDTO.*;
import com.sena.test.Entity.Bill.*;
import com.sena.test.Entity.Security.User;
import com.sena.test.IRepository.IBillRepository.IRepositoryBill;
import com.sena.test.IRepository.ISecurityRepository.IRepositoryUser;
import com.sena.test.IService.IBillService.IServiceBill;
import com.sena.test.Utils.BillMapper;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class ServiceBill implements IServiceBill {

    private final IRepositoryBill repositoryBill;
    private final IRepositoryUser repositoryUser;

    public ServiceBill(IRepositoryBill repositoryBill, IRepositoryUser repositoryUser) {
        this.repositoryBill = repositoryBill;
        this.repositoryUser = repositoryUser;
    }

    @Override
    public BillDTOResponse create(BillDTORequest dto) {

        User user = repositoryUser.findById(dto.getUserId())
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));

        Bill bill = BillMapper.toEntity(dto, user);

        bill = repositoryBill.save(bill);

        return BillMapper.toResponseDTO(bill);
    }

    @Override
    public List<BillDTOResponse> findAll() {
        return repositoryBill.findAll()
                .stream()
                .map(BillMapper::toResponseDTO)
                .collect(Collectors.toList());
    }

    @Override
    public BillDTOResponse findById(Long id) {
        Bill bill = repositoryBill.findById(id)
                .orElseThrow(() -> new RuntimeException("Factura no encontrada"));

        return BillMapper.toResponseDTO(bill);
    }
}