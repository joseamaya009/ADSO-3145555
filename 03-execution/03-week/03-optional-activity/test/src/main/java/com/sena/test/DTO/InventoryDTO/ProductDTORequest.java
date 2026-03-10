package com.sena.test.DTO.InventoryDTO;

    import lombok.Getter;
    import lombok.Setter;

    @Getter
    @Setter
    
public class ProductDTORequest {
    private String name;
    private double price;
    private Long  categoryId;
}
