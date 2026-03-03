package com.sena.test.DTO.BillDTO;


    import lombok.Getter;
    import lombok.Setter;

    @Getter
    @Setter

public class BillDetailDTORequest {

    private Long quantity;
    private Double price;
    private Long productId; 

}
