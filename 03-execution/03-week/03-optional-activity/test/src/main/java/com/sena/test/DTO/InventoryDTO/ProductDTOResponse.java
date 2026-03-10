package com.sena.test.DTO.InventoryDTO;

    import lombok.Getter;
    import lombok.Setter;

    @Getter
    @Setter
    
public class ProductDTOResponse {
    private Long id;
    private String name;
    private Double price;
    private String categoryName;
}
