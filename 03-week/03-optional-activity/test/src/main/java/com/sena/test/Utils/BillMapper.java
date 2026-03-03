package com.sena.test.Utils;

import com.sena.test.Entity.Bill.Bill;
import com.sena.test.Entity.Security.User;
import com.sena.test.DTO.BillDTO.BillDTORequest;
import com.sena.test.DTO.BillDTO.BillDTOResponse;

import java.util.stream.Collectors;

public class BillMapper {

    private BillMapper() {}

    // Request → Entity
    public static Bill toEntity(BillDTORequest dto, User user) {
        Bill bill = new Bill();
        bill.setDate(dto.getDate());
        bill.setUser(user);
        bill.setTotal(0.0);
        return bill;
    }

    // Entity → Response
    public static BillDTOResponse toResponseDTO(Bill bill) {
        BillDTOResponse dto = new BillDTOResponse();

        dto.setId(bill.getId());
        dto.setDate(bill.getDate());
        dto.setTotal(bill.getTotal());

        if (bill.getUser() != null && bill.getUser().getPerson() != null) {
            dto.setUsername(bill.getUser().getPerson().getFirstName());
        }

        if (bill.getDetails() != null) {
            dto.setDetails(
                bill.getDetails()
                        .stream()
                        .map(BillDetailMapper::toResponseDTO)
                        .collect(Collectors.toList())
            );
        }

        return dto;
    }
}