package com.sena.test.Utils;

import com.sena.test.DTO.BillDTO.BillDetailDTORequest;
import com.sena.test.DTO.BillDTO.BillDetailDTOResponse;
import com.sena.test.Entity.Bill.Bill;
import com.sena.test.Entity.Bill.BillDetail;
import com.sena.test.Entity.Inventory.Product;

public class BillDetailMapper {

    private BillDetailMapper() {}

    // Request → Entity
    public static BillDetail toEntity(BillDetailDTORequest dto, Bill bill, Product product) {
        BillDetail detail = new BillDetail();
        detail.setQuantity(dto.getQuantity());
        detail.setPrice(dto.getPrice());
        detail.setBill(bill);
        detail.setProduct(product);
        return detail;
    }

    // Entity → Response
    public static BillDetailDTOResponse toResponseDTO(BillDetail detail) {
        BillDetailDTOResponse dto = new BillDetailDTOResponse();

        dto.setId(detail.getId());
        dto.setQuantity(detail.getQuantity());
        dto.setPrice(detail.getPrice());

        if (detail.getProduct() != null) {
            dto.setProductName(detail.getProduct().getName());
        }

        return dto;
    }
}